//
//  PrefsPaneDelegate.h
//  Excerptor
//
//  Created by Chen Guo on 23/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PDFReaderApp) {
    PDFReaderAppPreview,
    PDFReaderAppSkim
};

@protocol PrefsPaneDelegate <NSObject>

@property (readonly) NSArray *availablePlaceholders;
@property (readonly) NSArray *availableSelectionPlaceholders;
@property (readonly) NSArray *availableAnnotationPlaceholders;

@property (readwrite) NSString *stringForSelectionLinkPlainText;
@property (readwrite) BOOL boolForSelectionLinkRichTextSameAsPlainText;
@property (readwrite) NSString *stringForSelectionLinkRichText;
@property (readwrite) BOOL boolForShowNotificationWhenFileNotFoundInDNtpForSelectionLink;

@property (readwrite) PDFReaderApp appForOpenPDF;

@property (readwrite) NSString *stringForSelectionFilesLocation;
@property (readwrite) NSString *stringForSelectionFileName;
@property (readwrite) NSString *stringForSelectionFileExtension;
@property (readwrite) NSString *stringForSelectionFileTags;
@property (readwrite) NSString *stringForSelectionFileContent;
@property (readwrite) BOOL boolForShowNotificationWhenFileNotFoundInDNtpForSelectionFile;

@property (readwrite) NSString *stringForAnnotationFilesLocation;
@property (readwrite) NSString *stringForAnnotationFileName;
@property (readwrite) NSString *stringForAnnotationFileExtension;
@property (readwrite) NSString *stringForAnnotationFileTags;
@property (readwrite) NSString *stringForAnnotationFileContent;
@property (readwrite) BOOL boolForShowNotificationWhenFileNotFoundInDNtpForAnnotationFile;

- (void)resetSelectionLinkPreferences;
- (void)resetSelectionFilePreferences;
- (void)resetAnnotationFilePreferences;

@end
