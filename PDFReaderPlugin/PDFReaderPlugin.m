//
//  PDFReaderPlugin.m
//  excerptor
//
//  Created by Chen Guo on 17/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import "PDFReaderPlugin.h"

@import ObjectiveC;
@import AppKit;
@import Quartz;

#import "Preview.h"
#import "Skim.h"
#import "PasteboardHelper.h"
#import "NSArray+Map.h"
#import "PDFSelection+BoundsDescription.h"
#import "Location.h"
#import "SelectionLineLocation.h"

@implementation NSObject (PDFReaderPlugin)

static NSString *currentFilePath;

- (void)PDFReaderPlugin_windowDidLoad {
    [self PDFReaderPlugin_windowDidLoad];

    [self updateCurrentPDFFilePathWithMaybeWindowController:self];
    [self highlightSelectionOrAnnotationIfNecessary];
}

- (void)PDFReaderPlugin_setCurrentSelection: (PDFSelection *)selection {
    [self PDFReaderPlugin_setCurrentSelection:selection];
    
    [self updateCurrentSelectionInformationWithMaybeWindowController:nil];
}

- (void)windowDidBecomeMainNotificationHandler: (NSNotification *)notification {
    NSWindowController *windowController = [(NSWindow *)(notification.object) windowController];
    [self updateCurrentPDFFilePathWithMaybeWindowController:windowController];
    [self updateCurrentSelectionInformationWithMaybeWindowController:windowController];
}

- (void)windowDidBecomeKeyNotificationHandler:(NSNotification *)notification {
    NSWindowController *windowController = [(NSWindow *)(notification.object) windowController];
    [self updateCurrentPDFFilePathWithMaybeWindowController:windowController];
    [self highlightSelectionOrAnnotationIfNecessary];
}



// MARK: - Highligh selection or annotation

- (void)highlightSelectionOrAnnotationIfNecessary {
    Location *location = [PasteboardHelper readPasteboard];
    if ([self highlightSelectionOrAnnotationWithLocation:location]) {
        [PasteboardHelper clearInputPasteboard];
    }
}

- (BOOL)highlightSelectionOrAnnotationWithLocation: (Location *)location {
    NSString *filePath = location.pdfFilePath;
    NSWindowController *currentWindowController = [self getWindowControllerForFile:filePath];
    if (!currentWindowController) {
        return NO;
    }
    return [location locateByWindowController:currentWindowController];
}


// MARK: - Update current selection information

- (void)updateCurrentSelectionInformationWithMaybeWindowController: (NSWindowController *)windowController {
    NSString *filePath = [self getCurrentFilePath];
    if (!filePath) {
        [PasteboardHelper writePasteboardWithErrorMessage: @"Could not get current file path"];
        return;
    }

    id currentWindowController = windowController ? windowController : [self getCurrentWindowController];
    id pdfView = nil;
    if ([currentWindowController respondsToSelector:@selector(pdfView)]) {
        pdfView = [currentWindowController performSelector:@selector(pdfView)];
    }
    if (!pdfView) {
        [PasteboardHelper writePasteboardWithErrorMessage: @"Could not get PDF view"];
        return;
    }

    PDFSelection *currentSelection = [pdfView performSelector:@selector(currentSelection)];
    if (!currentSelection) {
        [PasteboardHelper writePasteboardWithErrorMessage: @"Could not get PDF current selection"];
        return;
    }
    
    NSArray *selections = [[currentSelection selectionsByLine] mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
        PDFSelection *selection = obj;
        NSString *string = [selection string];
        NSArray *pages = [selection pages];
        if (pages.count != 1) {
            [PasteboardHelper writePasteboardWithErrorMessage: @"Unexpected pages number of PDFSelection"];
            exit(1);
        }
        PDFPage *page = pages[0];
        PDFDocument *document = [page document];
        NSUInteger pageIndex = [document indexForPage:page];
        NSRect bound = [selection boundsForPage:page];
        NSRange range = [selection range];
        return [[SelectionLineLocation alloc] initWithString:string pageIndex:pageIndex range:range bound:bound];
    }];
    SelectionLocation *selectionLocation = [[SelectionLocation alloc] initWithPDFFilePath:filePath selectionLineLocations:selections];
    [PasteboardHelper writePasteboardWithSelectionLocation:selectionLocation];
}


// MARK: - Get correct window controller

- (NSWindowController *)getWindowControllerForFile: (NSString *)filePath {
    NSArray *windowControllers = [[self getDocumentForFile:filePath] windowControllers];
    Class classPVWindowController = objc_getClass("PVWindowController");
    Class classSKMainWindowController = objc_getClass("SKMainWindowController");
    for (NSWindowController *windowController in windowControllers) {
        if ([windowController isKindOfClass:classPVWindowController] || [windowController isKindOfClass:classSKMainWindowController]) {
            return windowController;
        }
    }
    return nil;
}

- (NSDocument *)getDocumentForFile: (NSString *)filePath {
    NSArray *documents = [NSApp orderedDocuments];
    for (NSDocument *document in documents) {
        if ([[[[document fileURL] path] stringByResolvingSymlinksInPath] isEqualToString:[filePath stringByResolvingSymlinksInPath]]) {
            return document;
        }
    }
    return nil;
}

- (NSString *)getCurrentFilePath {
    if (!currentFilePath) {
        id windowController = [self getCurrentWindowController];
        if (windowController) {
            [self updateCurrentPDFFilePathWithMaybeWindowController:windowController];
        }
    }
    return currentFilePath;
}

- (void)updateCurrentPDFFilePathWithMaybeWindowController: (id)currentWindowController {
    NSDocument *document;    // PVPDFPageContainer or SKMainDocument
    if (currentWindowController) {
        document = [currentWindowController performSelector:@selector(document)];
    } else {
        NSArray *documents = [NSApp orderedDocuments];
        if (documents.count == 0) {
            currentFilePath = nil;
            return;
        } else {
            document = documents[0];
        }
    }
    if ([document isKindOfClass:objc_getClass("PVPDFPageContainer")] || [document isKindOfClass:objc_getClass("SKMainDocument")]) {
        PDFDocument *pdfDocument = [document performSelector:@selector(pdfDocument)];
        currentFilePath = [[pdfDocument documentURL].path stringByResolvingSymlinksInPath];
    } else {
        currentFilePath = nil;
    }
}

- (id)getCurrentWindowController {
    if ([NSApp respondsToSelector:@selector(mainWindow)]) {
        id window = [NSApp performSelector:@selector(mainWindow)];
        if ([window respondsToSelector:@selector(delegate)]) {
            id windowController = [window performSelector:@selector(delegate)];
            if (windowController) {
                return windowController;
            }
        }
    }
    return nil;
}

@end


// MARK: - Replace methods

@implementation PDFReaderPlugin

+ (void) load
{
    PDFReaderPlugin *plugin = [PDFReaderPlugin sharedInstance];
    
    if (plugin) {
        Class classNSWindowController = objc_getClass("NSWindowController");
        Class to = objc_getClass("NSObject");
        method_exchangeImplementations(class_getInstanceMethod(classNSWindowController, @selector(windowDidLoad)),
                                       class_getInstanceMethod(to, @selector(PDFReaderPlugin_windowDidLoad)));
        
        Class classPDFView = objc_getClass("PDFView");
        method_exchangeImplementations(class_getInstanceMethod(classPDFView, @selector(setCurrentSelection:)),
                                       class_getInstanceMethod(to, @selector(PDFReaderPlugin_setCurrentSelection:)));
        
        [[NSNotificationCenter defaultCenter] addObserver:plugin selector:@selector(windowDidBecomeMainNotificationHandler:) name:NSWindowDidBecomeMainNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:plugin selector:@selector(windowDidBecomeKeyNotificationHandler:) name:NSWindowDidBecomeKeyNotification object:nil];
        
        
        [self highlightSelectionOrAnnotationIfNecessary];
    }
    
}

+ (PDFReaderPlugin *) sharedInstance
{
    static PDFReaderPlugin *plugin = nil;
    
    if (plugin == nil)
        plugin = [[PDFReaderPlugin alloc] init];
    
    return plugin;
}

@end
