//
//  SelectionLocation.m
//  GoToPDFDestination
//
//  Created by Chen Guo on 7/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import <Quartz/Quartz.h>
#import "Preview.h"
#import "SelectionLocation.h"
#import "SelectionLineLocation.h"

@implementation SelectionLocation

@synthesize selectionLineLocations = _selectionLineLocations;

- (instancetype)initWithPDFFilePath:(NSString *)filePath selectionLineLocations:(NSArray *)selectionLineLocations {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.pdfFilePath = filePath;
    self.selectionLineLocations = selectionLineLocations;
    
    return self;
}

- (BOOL)locateByWindowController: (NSWindowController *)windowController {
    id pdfView = [windowController performSelector:@selector(pdfView)];
    PDFDocument *pdfDocument = nil;
    id windowDocument = [windowController document];
    if ([windowDocument isKindOfClass:[NSClassFromString(@"PVPDFPageContainer") class]] || [windowDocument isKindOfClass:[NSClassFromString(@"SKMainDocument") class]]) {
        pdfDocument = [windowDocument pdfDocument];
    } else {
        NSLog(@"Unexpected PDF document");
        return NO;
    }
    
    PDFSelection *selectionToHighlight = [[PDFSelection alloc] initWithDocument:pdfDocument];
    for (SelectionLineLocation *selectionLineLocation in self.selectionLineLocations) {
        NSUInteger pageIndex = selectionLineLocation.pageIndex;
        PDFPage *page = [pdfDocument pageAtIndex:pageIndex];
        NSRange range = selectionLineLocation.range;
        PDFSelection *selection = [page selectionForRange:range];
        [selectionToHighlight addSelection:selection];
    }
    [pdfView performSelector:@selector(setCurrentSelection:) withObject: selectionToHighlight];
    [pdfView performSelector:@selector(goToSelection:) withObject: selectionToHighlight];
    return YES;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.pdfFilePath = [aDecoder decodeObjectForKey:@"pdfFilePath"];
    self.selectionLineLocations = [aDecoder decodeObjectForKey:@"selectionLineLocations"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.pdfFilePath forKey:@"pdfFilePath"];
    [aCoder encodeObject:self.selectionLineLocations forKey:@"selectionLineLocations"];
}

@end
