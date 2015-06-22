//
//  HelpWindowController.m
//  Excerptor
//
//  Created by Chen Guo on 21/06/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import "HelpWindowController.h"

@interface HelpWindowController ()

@end

@implementation HelpWindowController

@synthesize placeholdersToShow = _placeholdersToShow;

- (void)setPlaceholdersToShow:(NSArray *)placeholdersToShow {
    _placeholdersToShow = placeholdersToShow;
    [self.tableView reloadData];
}

- (NSString *)windowNibName {
    return @"HelpWindowController";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.placeholdersToShow.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return self.placeholdersToShow[row];
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    NSString *string = self.placeholdersToShow[rowIndexes.lastIndex];
    [pboard declareTypes:@[NSPasteboardTypeString] owner:self];
    [pboard setString:string forType:NSPasteboardTypeString];
    return true;
}

@end
