//
//  AnnotationLocation.h
//  GoToPDFDestination
//
//  Created by Chen Guo on 8/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface AnnotationLocation : Location<NSCoding>

@property (nonatomic) NSUInteger pageIndex;
@property (nonatomic) NSDate *annotationDate;

- (id)initWithPDFFilePath:(NSString *)pdfFilePath pageIndex:(NSUInteger)pageIndex annotationDate:(NSDate *)annotationDate;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

- (BOOL)locateByWindowController:(NSWindowController *)windowController;

@end
