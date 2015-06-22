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
    } else {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

+ (bool)writePasteboardWithSelectionLocation: (SelectionLocation *)selectionLocation {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:selectionLocation];
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:OutputPasteboardName];
    [pasteboard clearContents];
    return [pasteboard setData:data forType:PasteboardType];
}

+ (void)clearInputPasteboard {
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:InputPasteboardName];
    [pasteboard clearContents];
}

@end
