//
//  PrefsPane.h
//  PrefsPane
//
//  Created by Chen Guo on 19/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>

#import "PrefsPaneDelegate.h"
#import "HelpWindowController.h"

@interface PrefsPane : NSPreferencePane <NSTabViewDelegate> {
    IBOutlet NSView *preferenceView;
}

@property (weak) NSObject<PrefsPaneDelegate> *delegate;

@property HelpWindowController *helpWindowController;

@property (weak) IBOutlet NSPopUpButton *openPDFWithPopUpButton;

@property (weak) IBOutlet NSTabView *tabView;

@property (weak) IBOutlet NSTextField *selectionLinkPlainTextTextField;
@property (weak) IBOutlet NSButton *selectionLinkRichTextSameAsPlainTextCheckBox;
@property (weak) IBOutlet NSTextField *selectionLinkRichTextTextField;
@property (weak) IBOutlet NSButton *showNotificationWhenFileNotFoundInDNtpForSelectionLinkCheckBox;

@property (weak) IBOutlet NSTextField *selectionFilesLocationTextField;
@property (weak) IBOutlet NSTextField *selectionFileNameTextField;
@property (weak) IBOutlet NSTextField *selectionFileExtensionTextField;
@property (weak) IBOutlet NSTextField *selectionFileTagsTextField;
@property (weak) IBOutlet NSTextField *selectionFileContentTextField;
@property (unsafe_unretained) IBOutlet NSButton *showNotificationWhenFileNotFoundInDNtpForSelectionFileCheckBox;

@property (weak) IBOutlet NSTextField *annotationFilesLocationTextField;
@property (weak) IBOutlet NSTextField *annotationFileNameTextField;
@property (weak) IBOutlet NSTextField *annotationFileExtensionTextField;
@property (weak) IBOutlet NSTextField *annotationFileTagsTextField;
@property (weak) IBOutlet NSTextField *annotationFileContentTextField;
@property (unsafe_unretained) IBOutlet NSButton *showNotificationWhenFileNotFoundInDNtpForAnnotationFileCheckBox;

- (void)mainViewDidLoad;

- (IBAction)openPDFWithPopUpButtonEndSelecting:(NSPopUpButton *)sender;

- (IBAction)selectionLinkPlainTextTextFieldEndEditing:(NSTextFieldCell *)sender;
- (IBAction)selectionLinkRichTextSameAsPlainTextCheckBoxToggled:(NSButton *)sender;
- (IBAction)selectionLinkRichTextTextFieldEndEditing:(NSTextField *)sender;
- (IBAction)showNotificationWhenFileNotFoundInDNtpForSelectionLinkCheckBoxToggled:(NSButton *)sender;
- (IBAction)resetSelectionLinkPreferencesButtonPressed:(NSButton *)sender;

- (IBAction)selectionFilesLocationTextFieldEndEditing:(NSTextField *)sender;
- (IBAction)chooseSelectionFilesLocationButtonPressed:(NSButton *)sender;
- (IBAction)selectionFileNameTextFieldEndEditing:(NSTextField *)sender;
- (IBAction)selectionFileExtensionTextFieldEndEditing:(NSTextField *)sender;
- (IBAction)selectionFileTagsTextFieldEndEditing:(NSTextField *)sender;
- (IBAction)selectionFileContentTextFieldEndEditing:(NSTextField *)sender;
- (IBAction)resetSelectionFilePreferencesButtonPressed:(NSButton *)sender;
- (IBAction)showNotificationWhenFileNotFoundInDNtpForSelectionFileCheckBoxToggled:(NSButton *)sender;

- (IBAction)annotationFilesLocationTextFieldEndEditing:(NSTextField *)sender;
- (IBAction)chooseAnnotationFilesLocationButtonPressed:(NSButton *)sender;
- (IBAction)annotationFileNameTextFieldEndEditing:(NSTextField *)sender;
- (IBAction)annotationFileExtensionTextFieldEndEditing:(NSTextField *)sender;
- (IBAction)annotationFileTagsTextFieldEndEditing:(NSTextField *)sender;
- (IBAction)annotationFileContentTextFieldEndEditing:(NSTextField *)sender;
- (IBAction)resetAnnotationFilePreferencesButtonPressed:(NSButton *)sender;
- (IBAction)showNotificationWhenFileNotFoundInDNtpForAnnotationFileCheckBoxToggled:(NSButton *)sender;

- (IBAction)helpButtonPressed:(NSButton *)sender;

@end
