//
//  SelectionLineLocation.h
//  GoToPDFDestination
//
//  Created by Chen Guo on 7/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectionLineLocation : NSObject<NSCoding>

@property (nonatomic) NSString *string;
@property (nonatomic) NSUInteger pageIndex;
@property (nonatomic) NSRect bound;
@property (nonatomic) NSRange range;

- (instancetype)initWithString:(NSString *)string pageIndex:(NSUInteger)pageIndex range:(NSRange)range bound:(NSRect)bound;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
