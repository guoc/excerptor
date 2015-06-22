//
//  Preferences.swift
//  Excerptor
//
//  Created by Chen Guo on 23/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Foundation

private let sharedInstance = Preferences()

class Preferences: NSObject, PrefsPaneDelegate {
    
    private var userDefaults: NSUserDefaults = {
        var userDefaults = NSUserDefaults(suiteName: "name.guoc.excerptor")!
        let defaultValuesFilePath = NSBundle.mainBundle().pathForResource("PreferencesDefaultValues", ofType: "plist")!
        let defaultValues = NSDictionary(contentsOfFile: defaultValuesFilePath)! as [NSObject : AnyObject]
        userDefaults.registerDefaults(defaultValues)
        if Preferences.dntpIsInstalled() {
            let defaultValuesForDNtpFilePath = NSBundle.mainBundle().pathForResource("PreferencesDefaultValues(DNtp)", ofType: "plist")!
            let defaultValuesForDNtp = NSDictionary(contentsOfFile: defaultValuesForDNtpFilePath)! as [NSObject : AnyObject]
            userDefaults.registerDefaults(defaultValuesForDNtp)
        }
        return userDefaults
    }()
    
    class var sharedPreferences : Preferences {
        return sharedInstance
    }
    
    static func dntpIsInstalled() -> Bool {
        return (LSCopyApplicationURLsForBundleIdentifier("com.devon-technologies.thinkpro2", nil) != nil)
    }
    
    let boolForSelectionLinkIncludesBoundsInfo = false
    
    // MARK: PrefsPaneDelegate
    
    private struct Constants {
        static let AppForOpenPDF = "AppForOpenPDF"

        static let SelectionLinkPlainText = "SelectionLinkPlainText"
        static let SelectionLinkRichTextSameAsPlainText = "SelectionLinkRichTextSameAsPlainText"
        static let SelectionLinkRichText = "SelectionLinkRichText"
        static let ShowNotificationWhenFileNotFoundInDNtpForSelectionLink = "ShowNotificationWhenFileNotFoundInDNtpForSelectionLink"

        static let SelectionFilesLocation = "SelectionFilesLocation"
        static let SelectionFileName = "SelectionFileName"
        static let SelectionFileExtension = "SelectionFileExtension"
        static let SelectionFileTags = "SelectionFileTags"
        static let SelectionFileContent = "SelectionFileContent"
        static let ShowNotificationWhenFileNotFoundInDNtpForSelectionFile = "ShowNotificationWhenFileNotFoundInDNtpForSelectionFile"
        
        static let AnnotationFilesLocation = "AnnotationFilesLocation"
        static let AnnotationFileName = "AnnotationFileName"
        static let AnnotationFileExtension = "AnnotationFileExtension"
        static let AnnotationFileTags = "AnnotationFileTags"
        static let AnnotationFileContent = "AnnotationFileContent"
        static let ShowNotificationWhenFileNotFoundInDNtpForAnnotationFile = "ShowNotificationWhenFileNotFoundInDNtpForAnnotationFile"
    }
    
    struct CommonPlaceholders {
        static let PDFFileLink_DEVONthinkUUIDType = "{{PDFFileLink_DEVONthinkUUID}}"
        static let PDFFileLink_FilePathType = "{{PDFFileLink_FilePath}}"
        static let PDFFilePath = "{{PDFFilePath}}"
        static let PDFFileName = "{{PDFFileName}}"
        static let PDFFileName_NoExtension = "{{PDFFileName_NoExtension}}"
        static let PDFFileDEVONthinkUUID = "{{PDFFileDEVONthinkUUID}}"
        static let Page = "{{Page}}"
    }
    
    struct SelectionPlaceholders {
        static let SelectionText = "{{SelectionText}}"
        static let UserName = "{{UserName}}"
        static let CreationDate = "{{CreationDate}}"
        static let SelectionLink_DEVONthinkUUIDType = "{{SelectionLink_DEVONthinkUUID}}"
        static let SelectionLink_FilePathType = "{{SelectionLink_FilePath}}"
    }
    
    struct AnnotationPlaceholders {
        static let AnnotationText = "{{AnnotationText}}"
        static let NoteText = "{{NoteText}}"
        static let Type = "{{Type}}"
        static let Color = "{{Color}}"
        static let Author = "{{Author}}"
        static let AnnotationDate = "{{AnnotationDate}}"
        static let ExportDate = "{{ExportDate}}"
        static let AnnotationLink_DEVONthinkUUIDType = "{{AnnotationLink_DEVONthinkUUID}}"
        static let AnnotationLink_FilePathType = "{{AnnotationLink_FilePath}}"
    }
    
    static let availablePlaceholders: [String] = { () -> [String] in
        let selectionPlaceholders = Set(Preferences.availableSelectionPlaceholders)
        let annotationPlaceholders = Set(Preferences.availableAnnotationPlaceholders)
        return Array<String>(selectionPlaceholders.union(annotationPlaceholders))
    }()
    
    static let availableSelectionPlaceholders = [
        Preferences.CommonPlaceholders.PDFFileLink_DEVONthinkUUIDType,
        Preferences.CommonPlaceholders.PDFFileLink_FilePathType,
        Preferences.CommonPlaceholders.PDFFilePath,
        Preferences.CommonPlaceholders.PDFFileName,
        Preferences.CommonPlaceholders.PDFFileName_NoExtension,
        Preferences.CommonPlaceholders.PDFFileDEVONthinkUUID,
        Preferences.CommonPlaceholders.Page,
        Preferences.SelectionPlaceholders.SelectionText,
        Preferences.SelectionPlaceholders.UserName,
        Preferences.SelectionPlaceholders.CreationDate,
        Preferences.SelectionPlaceholders.SelectionLink_DEVONthinkUUIDType,
        Preferences.SelectionPlaceholders.SelectionLink_FilePathType
    ]
    
    static let availableAnnotationPlaceholders = [
        Preferences.CommonPlaceholders.PDFFileLink_DEVONthinkUUIDType,
        Preferences.CommonPlaceholders.PDFFileLink_FilePathType,
        Preferences.CommonPlaceholders.PDFFilePath,
        Preferences.CommonPlaceholders.PDFFileName,
        Preferences.CommonPlaceholders.PDFFileName_NoExtension,
        Preferences.CommonPlaceholders.PDFFileDEVONthinkUUID,
        Preferences.CommonPlaceholders.Page,
        Preferences.AnnotationPlaceholders.AnnotationText,
        Preferences.AnnotationPlaceholders.NoteText,
        Preferences.AnnotationPlaceholders.Type,
        Preferences.AnnotationPlaceholders.Color,
        Preferences.AnnotationPlaceholders.Author,
        Preferences.AnnotationPlaceholders.AnnotationDate,
        Preferences.AnnotationPlaceholders.ExportDate,
        Preferences.AnnotationPlaceholders.AnnotationLink_DEVONthinkUUIDType,
        Preferences.AnnotationPlaceholders.AnnotationLink_FilePathType
    ]
    
    var availablePlaceholders: [AnyObject] {
        get {
            return Preferences.availablePlaceholders
        }
    }

    var availableSelectionPlaceholders: [AnyObject] {
        get {
            return Preferences.availableSelectionPlaceholders
        }
    }
    
    var availableAnnotationPlaceholders: [AnyObject] {
        get {
            return Preferences.availableAnnotationPlaceholders
        }
    }
    
    var appForOpenPDF: PDFReaderApp {
        get {
            self.userDefaults.synchronize()
            return PDFReaderApp(rawValue: self.userDefaults.integerForKey(Constants.AppForOpenPDF))!
        }
        
        set {
            self.userDefaults.setInteger(newValue.rawValue, forKey: Constants.AppForOpenPDF)
            self.userDefaults.synchronize()
        }
    }
    
    var stringForSelectionLinkPlainText: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.stringForKey(Constants.SelectionLinkPlainText)!
        }
        
        set {
            self.userDefaults.setObject(newValue, forKey: Constants.SelectionLinkPlainText)
            self.userDefaults.synchronize()
        }
    }
    
    var boolForSelectionLinkRichTextSameAsPlainText: Bool {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.boolForKey(Constants.SelectionLinkRichTextSameAsPlainText)
        }
        set {
            self.userDefaults.setBool(newValue, forKey: Constants.SelectionLinkRichTextSameAsPlainText)
            self.userDefaults.synchronize()
        }
    }
    
    var stringForSelectionLinkRichText: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.stringForKey(Constants.SelectionLinkRichText)!
        }
        
        set {
            self.userDefaults.setObject(newValue, forKey: Constants.SelectionLinkRichText)
            self.userDefaults.synchronize()
        }
    }
    
    var boolForShowNotificationWhenFileNotFoundInDNtpForSelectionLink: Bool {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.boolForKey(Constants.ShowNotificationWhenFileNotFoundInDNtpForSelectionLink)
        }
        
        set {
            self.userDefaults.setBool(newValue, forKey: Constants.ShowNotificationWhenFileNotFoundInDNtpForSelectionLink)
            self.userDefaults.synchronize()
        }
    }
    
    var stringForSelectionFilesLocation: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.stringForKey(Constants.SelectionFilesLocation)!
        }
        
        set {
            self.userDefaults.setObject(newValue, forKey: Constants.SelectionFilesLocation)
            self.userDefaults.synchronize()
        }
    }
    
    var stringForSelectionFileName: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.stringForKey(Constants.SelectionFileName)!
        }
        
        set {
            self.userDefaults.setObject(newValue, forKey: Constants.SelectionFileName)
            self.userDefaults.synchronize()
        }
    }
    
    var stringForSelectionFileExtension: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.stringForKey(Constants.SelectionFileExtension)!
        }
        
        set {
            self.userDefaults.setObject(newValue, forKey: Constants.SelectionFileExtension)
            self.userDefaults.synchronize()
        }
    }
    
    var stringForSelectionFileTags: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.stringForKey(Constants.SelectionFileTags)!
        }
        
        set {
            self.userDefaults.setObject(newValue, forKey: Constants.SelectionFileTags)
            self.userDefaults.synchronize()
        }
    }
    
    var stringForSelectionFileContent: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.stringForKey(Constants.SelectionFileContent)!
        }
        
        set {
            self.userDefaults.setObject(newValue, forKey: Constants.SelectionFileContent)
            self.userDefaults.synchronize()
        }
    }
    
    var boolForShowNotificationWhenFileNotFoundInDNtpForSelectionFile: Bool {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.boolForKey(Constants.ShowNotificationWhenFileNotFoundInDNtpForSelectionFile)
        }
        
        set {
            self.userDefaults.setBool(newValue, forKey: Constants.ShowNotificationWhenFileNotFoundInDNtpForSelectionFile)
            self.userDefaults.synchronize()
        }
    }
    
    var stringForAnnotationFilesLocation: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.stringForKey(Constants.AnnotationFilesLocation)!
        }
        
        set {
            self.userDefaults.setObject(newValue, forKey: Constants.AnnotationFilesLocation)
            self.userDefaults.synchronize()
        }
    }
    
    var stringForAnnotationFileName: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.stringForKey(Constants.AnnotationFileName)!
        }
        
        set {
            self.userDefaults.setObject(newValue, forKey: Constants.AnnotationFileName)
            self.userDefaults.synchronize()
        }
    }
    
    var stringForAnnotationFileExtension: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.stringForKey(Constants.AnnotationFileExtension)!
        }
        
        set {
            self.userDefaults.setObject(newValue, forKey: Constants.AnnotationFileExtension)
            self.userDefaults.synchronize()
        }
    }
    
    var stringForAnnotationFileTags: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.stringForKey(Constants.AnnotationFileTags)!
        }
        
        set {
            self.userDefaults.setObject(newValue, forKey: Constants.AnnotationFileTags)
            self.userDefaults.synchronize()
        }
    }
    
    var stringForAnnotationFileContent: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.stringForKey(Constants.AnnotationFileContent)!
        }
        
        set {
            self.userDefaults.setObject(newValue, forKey: Constants.AnnotationFileContent)
            self.userDefaults.synchronize()
        }
    }
    
    var boolForShowNotificationWhenFileNotFoundInDNtpForAnnotationFile: Bool {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.boolForKey(Constants.ShowNotificationWhenFileNotFoundInDNtpForAnnotationFile)
        }
        
        set {
            self.userDefaults.setBool(newValue, forKey: Constants.ShowNotificationWhenFileNotFoundInDNtpForAnnotationFile)
            self.userDefaults.synchronize()
        }
    }
    
    func resetSelectionLinkPreferences() {
        self.userDefaults.removeObjectForKey(Constants.SelectionLinkPlainText)
        self.userDefaults.removeObjectForKey(Constants.SelectionLinkRichTextSameAsPlainText)
        self.userDefaults.removeObjectForKey(Constants.SelectionLinkRichText)
        self.userDefaults.removeObjectForKey(Constants.ShowNotificationWhenFileNotFoundInDNtpForSelectionLink)
    }
    
    func resetSelectionFilePreferences() {
        self.userDefaults.removeObjectForKey(Constants.SelectionFilesLocation)
        self.userDefaults.removeObjectForKey(Constants.SelectionFileName)
        self.userDefaults.removeObjectForKey(Constants.SelectionFileExtension)
        self.userDefaults.removeObjectForKey(Constants.SelectionFileTags)
        self.userDefaults.removeObjectForKey(Constants.SelectionFileContent)
        self.userDefaults.removeObjectForKey(Constants.ShowNotificationWhenFileNotFoundInDNtpForSelectionFile)
    }
    
    func resetAnnotationFilePreferences() {
        self.userDefaults.removeObjectForKey(Constants.AnnotationFilesLocation)
        self.userDefaults.removeObjectForKey(Constants.AnnotationFileName)
        self.userDefaults.removeObjectForKey(Constants.AnnotationFileExtension)
        self.userDefaults.removeObjectForKey(Constants.AnnotationFileTags)
        self.userDefaults.removeObjectForKey(Constants.AnnotationFileContent)
        self.userDefaults.removeObjectForKey(Constants.ShowNotificationWhenFileNotFoundInDNtpForAnnotationFile)
    }
    
}

