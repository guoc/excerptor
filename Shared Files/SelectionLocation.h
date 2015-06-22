//
//  SelectionLocation.h
//  GoToPDFDestination
//
//  Created by Chen Guo on 7/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface SelectionLocation : Location<NSCoding>

@property (nonatomic) NSArray *selectionLineLocations;

- (instancetype)initWithPDFFilePath:(NSString *)filePath selectionLineLocations:(NSArray *)selectionLineLocations;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

- (BOOL)locateByWindowController: (NSWindowController *)windowController;

@end
