//
//  NSArray+Map.h
//  GoToPDFDestination
//
//  Created by Chen Guo on 6/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

@import Foundation;

// http://stackoverflow.com/a/7248251/3157231

@interface NSArray (Map)

- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block;

@end
