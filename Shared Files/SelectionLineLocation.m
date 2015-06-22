//
//  SelectionLineLocation.m
//  GoToPDFDestination
//
//  Created by Chen Guo on 7/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import "SelectionLineLocation.h"

@implementation SelectionLineLocation

@synthesize string = _string;
@synthesize pageIndex = _pageIndex;
@synthesize bound = _bound;
@synthesize range = _range;

- (instancetype)initWithString:(NSString *)string pageIndex:(NSUInteger)pageIndex range:(NSRange)range bound:(NSRect)bound {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.string = string;
    self.pageIndex = pageIndex;
    self.bound = bound;
    self.range = range;
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.string = [aDecoder decodeObjectForKey:@"string"];
    self.pageIndex = [aDecoder decodeIntegerForKey:@"pageIndex"];
    self.bound = [[aDecoder decodeObjectForKey:@"bound"] rectValue];
    self.range = [[aDecoder decodeObjectForKey:@"range"] rangeValue];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.string forKey:@"string"];
    [aCoder encodeInteger:self.pageIndex forKey:@"pageIndex"];
    [aCoder encodeObject:[NSValue valueWithRect:self.bound] forKey:@"bound"];
    [aCoder encodeObject:[NSValue valueWithRange:self.range] forKey:@"range"];
}

@end
