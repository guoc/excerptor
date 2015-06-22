//
//  PrefsPane.m
//  PrefsPane
//
//  Created by Chen Guo on 19/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import "PrefsPane.h"

@implementation PrefsPane

@synthesize helpWindowController = _helpWindowController;

- (void)mainViewDidLoad
{
    [self loadOpenPDFWithAppPreferences];
    [self loadSelectionLinkPreferences];
    [self loadSelectionFilePreferences];
    [self loadAnnotationFilePreferences];
}

- (IBAction)openPDFWithPopUpButtonEndSelecting:(NSPopUpButton *)sender {
    NSString *appName = [self.openPDFWithPopUpButton titleOfSelectedItem];
    PDFReaderApp app;
    if ([appName isEqualToString:@"Preview"]) {
        app = PDFReaderAppPreview;
    } else if ([appName isEqualToString:@"Skim"]) {
        app = PDFReaderAppSkim;
    } else {
        NSLog(@"Unexpected PDFReaderApp\n");
        exit(1);
    }
    [self.delegate setAppForOpenPDF:app];
}

- (IBAction)selectionLinkPlainTextTextFieldEndEditing:(NSTextFieldCell *)sender {
    NSString *selectionLinkPlainText = self.selectionLinkPlainTextTextField.stringValue;
    [self.delegate setStringForSelectionLinkPlainText:selectionLinkPlainText];
}

- (IBAction)selectionLinkRichTextSameAsPlainTextCheckBoxToggled:(NSButton *)sender {
    BOOL selectionLinkRichTextSameAsPlainText = self.selectionLinkRichTextSameAsPlainTextCheckBox.state;
    [self.delegate setBoolForSelectionLinkRichTextSameAsPlainText:selectionLinkRichTextSameAsPlainText];
    
    // Disable rich text settings
    self.selectionLinkRichTextTextField.enabled = !selectionLinkRichTextSameAsPlainText;
}

- (IBAction)selectionLinkRichTextTextFieldEndEditing:(NSTextField *)sender {
    NSString *selectionLinkRichText = self.selectionLinkRichTextTextField.stringValue;
    [self.delegate setStringForSelectionLinkRichText:selectionLinkRichText];
}

- (IBAction)showNotificationWhenFileNotFoundInDNtpForSelectionLinkCheckBoxToggled:(NSButton *)sender {
    BOOL showNotificationWhenFileNotFoundInDNtpForSelectionLink = self.showNotificationWhenFileNotFoundInDNtpForSelectionLinkCheckBox.state;
    [self.delegate setBoolForShowNotificationWhenFileNotFoundInDNtpForSelectionLink:showNotificationWhenFileNotFoundInDNtpForSelectionLink];
}

- (IBAction)resetSelectionLinkPreferencesButtonPressed:(NSButton *)sender {
    [self.delegate resetSelectionLinkPreferences];
    [self loadSelectionLinkPreferences];
}

- (IBAction)selectionFilesLocationTextFieldEndEditing:(NSTextField *)sender {
    NSString *selectionFilesLocation = self.selectionFilesLocationTextField.stringValue;
    [self.delegate setStringForSelectionFilesLocation:selectionFilesLocation];
}

- (IBAction)chooseSelectionFilesLocationButtonPressed:(NSButton *)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:NO];
    [openPanel setCanChooseDirectories:YES];
    
    NSInteger clicked = [openPanel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        NSString *selectionFilesLocation = [[[openPanel URLs] firstObject] path];
        NSString *newSelectionFilesLocation = [self stringByReplacingPathComponentsExcludingPlaceholdersWithPathString:selectionFilesLocation inOriginalPathString:self.selectionFilesLocationTextField.stringValue];
        [self.selectionFilesLocationTextField setStringValue:newSelectionFilesLocation];
        [self.delegate setStringForSelectionFilesLocation:newSelectionFilesLocation];
    }
}

- (IBAction)selectionFileNameTextFieldEndEditing:(NSTextField *)sender {
    NSString *selectionFileName = self.selectionFileNameTextField.stringValue;
    [self.delegate setStringForSelectionFileName:selectionFileName];
}

- (IBAction)selectionFileExtensionTextFieldEndEditing:(NSTextField *)sender {
    NSString *selectionFileExtension = self.selectionFileExtensionTextField.stringValue;
    [self.delegate setStringForSelectionFileExtension:selectionFileExtension];
}

- (IBAction)selectionFileTagsTextFieldEndEditing:(NSTextField *)sender {
    NSString *selectionFileTags = self.selectionFileTagsTextField.stringValue;
    [self.delegate setStringForSelectionFileTags:selectionFileTags];
}

- (IBAction)selectionFileContentTextFieldEndEditing:(NSTextField *)sender {
    NSString *selectionFileContent = self.selectionFileContentTextField.stringValue;
    [self.delegate setStringForSelectionFileContent:selectionFileContent];
}

- (IBAction)resetSelectionFilePreferencesButtonPressed:(NSButton *)sender {
    [self.delegate resetSelectionFilePreferences];
    [self loadSelectionFilePreferences];
}

- (IBAction)showNotificationWhenFileNotFoundInDNtpForSelectionFileCheckBoxToggled:(NSButton *)sender {
    BOOL showNotificationWhenFileNotFoundInDNtpForSelectionFile = self.showNotificationWhenFileNotFoundInDNtpForSelectionFileCheckBox.state;
    [self.delegate setBoolForShowNotificationWhenFileNotFoundInDNtpForSelectionFile:showNotificationWhenFileNotFoundInDNtpForSelectionFile];
}

- (IBAction)annotationFilesLocationTextFieldEndEditing:(NSTextField *)sender {
    NSString *annotationFilesLocation = self.annotationFilesLocationTextField.stringValue;
    [self.delegate setStringForAnnotationFilesLocation:annotationFilesLocation];
}

- (IBAction)chooseAnnotationFilesLocationButtonPressed:(NSButton *)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:NO];
    [openPanel setCanChooseDirectories:YES];
    
    NSInteger clicked = [openPanel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        NSString *annotationFilesLocation = [[[openPanel URLs] firstObject] path];
        NSString *newAnnotationFilesLocation = [self stringByReplacingPathComponentsExcludingPlaceholdersWithPathString:annotationFilesLocation inOriginalPathString:self.annotationFilesLocationTextField.stringValue];
        [self.annotationFilesLocationTextField setStringValue:newAnnotationFilesLocation];
        [self.delegate setStringForAnnotationFilesLocation:newAnnotationFilesLocation];
    }
}

- (IBAction)annotationFileNameTextFieldEndEditing:(NSTextField *)sender {
    NSString *annotationFileName = self.annotationFileNameTextField.stringValue;
    [self.delegate setStringForAnnotationFileName:annotationFileName];
}

- (IBAction)annotationFileExtensionTextFieldEndEditing:(NSTextField *)sender {
    NSString *annotationFileExtension = self.annotationFileExtensionTextField.stringValue;
    [self.delegate setStringForAnnotationFileExtension:annotationFileExtension];
}

- (IBAction)annotationFileTagsTextFieldEndEditing:(NSTextField *)sender {
    NSString *annotationFileTags = self.annotationFileTagsTextField.stringValue;
    [self.delegate setStringForAnnotationFileTags:annotationFileTags];
}

- (IBAction)annotationFileContentTextFieldEndEditing:(NSTextField *)sender {
    NSString *annotationFileContent = self.annotationFileContentTextField.stringValue;
    [self.delegate setStringForAnnotationFileContent:annotationFileContent];
}

- (IBAction)resetAnnotationFilePreferencesButtonPressed:(NSButton *)sender {
    [self.delegate resetAnnotationFilePreferences];
    [self loadAnnotationFilePreferences];
}

- (IBAction)showNotificationWhenFileNotFoundInDNtpForAnnotationFileCheckBoxToggled:(NSButton *)sender {
    BOOL showNotificationWhenFileNotFoundInDNtpForAnnotationFile = self.showNotificationWhenFileNotFoundInDNtpForAnnotationFileCheckBox.state;
    [self.delegate setBoolForShowNotificationWhenFileNotFoundInDNtpForAnnotationFile:showNotificationWhenFileNotFoundInDNtpForAnnotationFile];
}

- (IBAction)helpButtonPressed:(NSButton *)sender {
    [self showHelpWindow];
}

- (void)showHelpWindow {
    if (!self.helpWindowController) {
        self.helpWindowController = [[HelpWindowController alloc] init];
    }
    [self setupHelpWindow];
    [self.helpWindowController showWindow:self];
}

- (void)setupHelpWindow {
    NSInteger index = [self.tabView indexOfTabViewItem: self.tabView.selectedTabViewItem];
    switch (index) {
        case 0:
            self.helpWindowController.placeholdersToShow = self.delegate.availableSelectionPlaceholders;
            break;
        case 1:
            self.helpWindowController.placeholdersToShow = self.delegate.availableSelectionPlaceholders;
            break;
        case 2:
            self.helpWindowController.placeholdersToShow = self.delegate.availableAnnotationPlaceholders;
            break;
        default:
            break;
    }
}

- (void)loadOpenPDFWithAppPreferences {
    PDFReaderApp app = [self.delegate appForOpenPDF];
    NSString *appName;
    switch (app) {
        case PDFReaderAppPreview:
            appName = @"Preview";
            break;
        case PDFReaderAppSkim:
            appName = @"Skim";
            break;
    }
    [self.openPDFWithPopUpButton selectItemWithTitle:appName];
}

- (void)loadSelectionLinkPreferences {
    NSString *selectionLinkPlainText = [self.delegate stringForSelectionLinkPlainText];
    [self.selectionLinkPlainTextTextField setStringValue:selectionLinkPlainText];
    
    BOOL selectionLinkRichTextSameAsPlainText = [self.delegate boolForSelectionLinkRichTextSameAsPlainText];
    [self.selectionLinkRichTextSameAsPlainTextCheckBox setState:selectionLinkRichTextSameAsPlainText];
    
    NSString *selectionLinkRichText = [self.delegate stringForSelectionLinkRichText];
    [self.selectionLinkRichTextTextField setStringValue:selectionLinkRichText];
    
    [self.selectionLinkRichTextTextField setEnabled:!selectionLinkRichTextSameAsPlainText];
    
    BOOL showNotificationWhenFileNotFoundInDNtpForSelectionLink = [self.delegate boolForShowNotificationWhenFileNotFoundInDNtpForSelectionLink];
    [self.showNotificationWhenFileNotFoundInDNtpForSelectionLinkCheckBox setState:showNotificationWhenFileNotFoundInDNtpForSelectionLink];
}

- (void)loadSelectionFilePreferences {
    NSString *selectionFilesLocation = [[self.delegate stringForSelectionFilesLocation] stringByExpandingTildeInPath];
    [self.selectionFilesLocationTextField setStringValue:selectionFilesLocation];
    
    NSString *selectionFileName = [self.delegate stringForSelectionFileName];
    [self.selectionFileNameTextField setStringValue:selectionFileName];
    
    NSString *selectionFileExtension = [self.delegate stringForSelectionFileExtension];
    [self.selectionFileExtensionTextField setStringValue:selectionFileExtension];
    
    NSString *selectionFileTags = [self.delegate stringForSelectionFileTags];
    [self.selectionFileTagsTextField setStringValue:selectionFileTags];
    
    NSString *selectionFileContent = [self.delegate stringForSelectionFileContent];
    [self.selectionFileContentTextField setStringValue:selectionFileContent];
    
    BOOL showNotificationWhenFileNotFoundInDNtpForSelectionFile = [self.delegate boolForShowNotificationWhenFileNotFoundInDNtpForSelectionFile];
    [self.showNotificationWhenFileNotFoundInDNtpForSelectionFileCheckBox setState:showNotificationWhenFileNotFoundInDNtpForSelectionFile];
}

- (void)loadAnnotationFilePreferences {
    NSString *annotationFilesLocation = [[self.delegate stringForAnnotationFilesLocation] stringByExpandingTildeInPath];
    [self.annotationFilesLocationTextField setStringValue:annotationFilesLocation];
    
    NSString *annotationFileName = [self.delegate stringForAnnotationFileName];
    [self.annotationFileNameTextField setStringValue:annotationFileName];
    
    NSString *annotationFileExtension = [self.delegate stringForAnnotationFileExtension];
    [self.annotationFileExtensionTextField setStringValue:annotationFileExtension];
    
    NSString *annotationFileTags = [self.delegate stringForAnnotationFileTags];
    [self.annotationFileTagsTextField setStringValue:annotationFileTags];
    
    NSString *annotationFileContent = [self.delegate stringForAnnotationFileContent];
    [self.annotationFileContentTextField setStringValue:annotationFileContent];
    
    BOOL showNotificationWhenFileNotFoundInDNtpForAnnotationFile = [self.delegate boolForShowNotificationWhenFileNotFoundInDNtpForAnnotationFile];
    [self.showNotificationWhenFileNotFoundInDNtpForAnnotationFileCheckBox setState:showNotificationWhenFileNotFoundInDNtpForAnnotationFile];
}

- (BOOL)dntpInstalled {
    CFArrayRef result = LSCopyApplicationURLsForBundleIdentifier(CFSTR("com.devon-technologies.thinkpro2"), nil);
    if (result) {
        CFRelease(result);
        return YES;
    } else {
        return NO;
    }

}

- (NSString *)stringByReplacingPathComponentsExcludingPlaceholdersWithPathString: (NSString *)pathString inOriginalPathString: (NSString *)originalPathString {
    NSArray *pathComponents = originalPathString.pathComponents;
    NSUInteger firstComponentIncludingPlaceholderIndex = [self indexOfFirstPathComponentIncludingPlaceholdersInPathComponents:pathComponents];
    if (firstComponentIncludingPlaceholderIndex != NSNotFound) {
        NSArray *pathComponentsIncludingPlaceholder = [pathComponents subarrayWithRange:NSMakeRange(firstComponentIncludingPlaceholderIndex, pathComponents.count - firstComponentIncludingPlaceholderIndex)];
        return [NSString pathWithComponents:[pathString.pathComponents arrayByAddingObjectsFromArray:pathComponentsIncludingPlaceholder]];
    } else {
        return originalPathString;
    }
}

- (NSUInteger)indexOfFirstPathComponentIncludingPlaceholdersInPathComponents: (NSArray *)pathComponents {
    NSUInteger firstComponentIncludingPlaceholderIndex = NSNotFound;
    UInt index;
    for (index = 0; index < pathComponents.count; index++) {
        for (NSString *placeholder in self.delegate.availablePlaceholders) {
            if ([pathComponents[index] rangeOfString:placeholder].location != NSNotFound) {
                firstComponentIncludingPlaceholderIndex = index;
                break;
            }
        }
        if (firstComponentIncludingPlaceholderIndex != NSNotFound) {
            break;
        }
    }
    return firstComponentIncludingPlaceholderIndex;
}

// MARK: - NSTabViewDelegate

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    [self setupHelpWindow];
}

@end

