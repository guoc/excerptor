//
//  PasteboardHelper.h
//  excerptor
//
//  Created by Chen Guo on 17/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import "Location.h"
#import "SelectionLocation.h"

@interface PasteboardHelper : NSObject

+ (Location *)readPasteboard;
+ (bool)writePasteboardWithSelectionLocation: (SelectionLocation *)selectionLocation;
+ (bool)writePasteboardWithErrorMessage: (NSString *)errorMessage;
+ (void)clearInputPasteboard;

@end
