//
//  AnnotationLocation.m
//  GoToPDFDestination
//
//  Created by Chen Guo on 8/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import <Quartz/Quartz.h>
#import "Preview.h"
#import "Skim.h"
#import "AnnotationLocation.h"

@implementation AnnotationLocation

@synthesize pageIndex = _pageIndex;
@synthesize annotationDate = _annotationDate;

- (id)initWithPDFFilePath:(NSString *)pdfFilePath pageIndex:(NSUInteger)pageIndex annotationDate:(NSDate *)annotationDate {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.pdfFilePath = pdfFilePath;
    self.pageIndex = pageIndex;
    self.annotationDate = annotationDate;
    
    return self;
}

- (BOOL)locateByWindowController:(NSWindowController *)windowController {
    id pdfView = [windowController performSelector:@selector(pdfView)];
    PDFPage *page = [[pdfView document] pageAtIndex:self.pageIndex];
    if (!self.annotationDate) {
        [pdfView goToPage:page];
        return YES;
    }
    
    if ([pdfView isKindOfClass:NSClassFromString(@"PVPDFView")]) {
        NSArray *annotations = [pdfView annotations];
        PVAnnotation *annotation;
        for (annotation in annotations) {
            if ([[annotation date] isEqualToDate:self.annotationDate]) {
                break;
            }
        }
        if ([[annotation date] isEqualToDate:self.annotationDate]) {
            CGRect rect = [annotation bounds];
            [pdfView goToRect:rect onPage:page];
            
            BOOL modifyingExistingSelection = NO;
            NSMethodSignature* signature = [[pdfView class] instanceMethodSignatureForSelector: @selector( selectAnnotation: byModifyingExistingSelection: )];
            NSInvocation* invocation = [NSInvocation invocationWithMethodSignature: signature];
            [invocation setTarget: pdfView];
            [invocation setSelector: @selector( selectAnnotation: byModifyingExistingSelection: )];
            [invocation setArgument: &annotation atIndex: 2];
            [invocation setArgument: &modifyingExistingSelection atIndex: 3];
            [invocation invoke];
            return YES;
        }
        return NO;
    } else {    // PDFAnnotation
        for (PDFAnnotation *annotation in [page annotations]) {
            if ([[annotation modificationDate] isEqualToDate:self.annotationDate]) {
                [pdfView scrollAnnotationToVisible:annotation];
                [pdfView setActiveAnnotation:annotation];
                return YES;
            }
        }
        return NO;
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.pdfFilePath = [aDecoder decodeObjectForKey:@"pdfFilePath"];
    self.pageIndex = [aDecoder decodeIntegerForKey:@"pageIndex"];
    self.annotationDate = [aDecoder decodeObjectForKey:@"annotationDate"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.pdfFilePath forKey:@"pdfFilePath"];
    [aCoder encodeInteger:self.pageIndex forKey:@"pageIndex"];
    [aCoder encodeObject:self.annotationDate forKey:@"annotationDate"];
}

@end
