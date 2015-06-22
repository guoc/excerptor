//
//  HelpWindowController.h
//  Excerptor
//
//  Created by Chen Guo on 21/06/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HelpWindowController : NSWindowController <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;

@property (nonatomic) NSArray *placeholdersToShow;

@end
