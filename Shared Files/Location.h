//
//  Location.h
//  GoToPDFDestination
//
//  Created by Chen Guo on 9/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Preview.h"

@interface Location : NSObject

@property (nonatomic) NSString *pdfFilePath;
- (BOOL)locateByWindowController: (NSWindowController *)windowController;

@end
