//
//  PasteboardHelper.m
//  excerptor
//
//  Created by Chen Guo on 17/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

@import AppKit;

#import "PasteboardHelper.h"
#import "SelectionLocation.h"

@implementation PasteboardHelper

static NSString *const InputPasteboardName = @"name.guoc.excerptor.ExcerptorToPDFReader";
static NSString *const OutputPasteboardName = @"name.guoc.excerptor.PDFReaderToExcerptor";
static NSString *const PasteboardType = @"org.nspasteboard.TransientType";

+ (Location *)readPasteboard {
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:InputPasteboardName];
    NSData *data = [pasteboard dataForType:PasteboardType];
    if (!data) {
        return nil;
    }
    NSObject *unarchivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (![unarchivedObject isKindOfClass:[Location class]]) {
        return nil;
    }
    return (Location *)unarchivedObject;
}

+ (bool)writePasteboardWithSelectionLocation: (SelectionLocation *)selectionLocation {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:selectionLocation];
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:OutputPasteboardName];
    [pasteboard clearContents];
    return [pasteboard setData:data forType:PasteboardType];
}

+ (bool)writePasteboardWithErrorMessage: (NSString *)errorMessage {
    if ([[PasteboardHelper readPasteboard] isKindOfClass:[Location class]]) {
        return NO;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: [@"Excerptor PDFReaderPlugin: " stringByAppendingString: errorMessage]];
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:OutputPasteboardName];
    [pasteboard clearContents];
    return [pasteboard setData:data forType:PasteboardType];
}

+ (void)clearInputPasteboard {
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:InputPasteboardName];
    [pasteboard clearContents];
}

@end
