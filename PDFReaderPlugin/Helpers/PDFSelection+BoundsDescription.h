//
//  PDFSelection+PDFSelection_Bounds.h
//  PDFReaderPlugin
//
//  Created by Chen Guo on 30/04/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import <Quartz/Quartz.h>

static NSString *const SelectionTextDelimiter = @"-";

@interface PDFSelection (BoundsDescription)

- (NSRange)range;

@end

