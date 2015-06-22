//
//  PDFSelection+PDFSelection_Bounds.m
//  PDFReaderPlugin
//
//  Created by Chen Guo on 30/04/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import "PDFSelection+BoundsDescription.h"

@implementation PDFSelection (BoundsDescription)

- (NSRange)range {
    PDFPage *page = [[self pages] firstObject];
    NSString *pageString = [page string];
    NSString *mySelectionString = [self string];
    NSRect mySelectionRect = [self boundsForPage:page];
    NSPoint mySelectionRectCenter = NSMakePoint(mySelectionRect.origin.x + mySelectionRect.size.width / 2, mySelectionRect.origin.y + mySelectionRect.size.height / 2);
    
    NSRange range = [pageString rangeOfString:mySelectionString];
    NSPoint selectionRectCenter;
    while (range.location != NSNotFound) {
        PDFSelection *selection = [page selectionForRange:range];
        NSRect selectionRect = [selection boundsForPage:page];
        selectionRectCenter = NSMakePoint(selectionRect.origin.x + selectionRect.size.width / 2, selectionRect.origin.y + selectionRect.size.height / 2);
        if (fabs(selectionRectCenter.x - mySelectionRectCenter.x) < 1.0 && fabs(selectionRectCenter.y - mySelectionRectCenter.y) < 1.0) {
            break;
        }
        NSUInteger searchLocation = range.location + range.length;
        NSUInteger searchLength = [pageString length] - searchLocation;
        NSRange searchRange = NSMakeRange(searchLocation, searchLength);
        range = [pageString rangeOfString:mySelectionString options:0 range:searchRange];
    }
    if (range.location == NSNotFound) {
        return NSMakeRange(NSNotFound, 0);
    } else {
        return range;
    }
}

@end

