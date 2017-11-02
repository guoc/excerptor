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

    fileprivate var userDefaults: UserDefaults = {
        var userDefaults = UserDefaults(suiteName: "name.guoc.excerptor")!
        let defaultValuesFilePath = Bundle.main.path(forResource: "PreferencesDefaultValues", ofType: "plist")!
        guard let defaultValues = NSDictionary(contentsOfFile: defaultValuesFilePath)! as? [String: AnyObject] else {
            exitWithError("Fail to read preferences default values: \(NSDictionary(contentsOfFile: defaultValuesFilePath)!)")
        }
        userDefaults.register(defaults: defaultValues)
        if Preferences.dntpIsInstalled() {
            let defaultValuesForDNtpFilePath = Bundle.main.path(forResource: "PreferencesDefaultValues(DNtp)", ofType: "plist")!
            guard let defaultValuesForDNtp = NSDictionary(contentsOfFile: defaultValuesForDNtpFilePath)! as? [String: AnyObject] else {
                exitWithError("Fail to read preferences default values for DNtp: \(NSDictionary(contentsOfFile: defaultValuesForDNtpFilePath)!)")
            }
            userDefaults.register(defaults: defaultValuesForDNtp)
        }
        return userDefaults
    }()

    class var sharedPreferences: Preferences {
        return sharedInstance
    }

    static func dntpIsInstalled() -> Bool {
        return (LSCopyApplicationURLsForBundleIdentifier("com.devon-technologies.thinkpro2" as CFString, nil) != nil)
    }

    let boolForSelectionLinkIncludesBoundsInfo = false

    // MARK: PrefsPaneDelegate

    fileprivate struct Constants {

        static let AppForOpenPDF = "AppForOpenPDF"

        static let SelectionLinkPlainText = "SelectionLinkPlainText"
        static let SelectionLinkRichTextSameAsPlainText = "SelectionLinkRichTextSameAsPlainText"
        static let SelectionLinkRichText = "SelectionLinkRichText"
        static let ShowNotificationWhenFileNotFoundInDNtpForSelectionLink = "ShowNotificationWhenFileNotFoundInDNtpForSelectionLink" // swiftlint:disable:this identifier_name

        static let SelectionFilesLocation = "SelectionFilesLocation"
        static let SelectionFileName = "SelectionFileName"
        static let SelectionFileExtension = "SelectionFileExtension"
        static let SelectionFileTags = "SelectionFileTags"
        static let SelectionFileContent = "SelectionFileContent"
        static let ShowNotificationWhenFileNotFoundInDNtpForSelectionFile = "ShowNotificationWhenFileNotFoundInDNtpForSelectionFile" // swiftlint:disable:this identifier_name

        static let AnnotationFilesLocation = "AnnotationFilesLocation"
        static let AnnotationFileName = "AnnotationFileName"
        static let AnnotationFileExtension = "AnnotationFileExtension"
        static let AnnotationFileTags = "AnnotationFileTags"
        static let AnnotationFileContent = "AnnotationFileContent"
        static let ShowNotificationWhenFileNotFoundInDNtpForAnnotationFile = "ShowNotificationWhenFileNotFoundInDNtpForAnnotationFile" // swiftlint:disable:this identifier_name

        // Hidden preferences
        static let PathVariables = "PathVariables"
        static let PathSubstitutes = "PathSubstitutes"
    }

    // swiftlint:disable variable_name

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
        static let annotationType = "{{Type}}"
        static let Color = "{{Color}}"
        static let Author = "{{Author}}"
        static let AnnotationDate = "{{AnnotationDate}}"
        static let ExportDate = "{{ExportDate}}"
        static let AnnotationLink_DEVONthinkUUIDType = "{{AnnotationLink_DEVONthinkUUID}}"
        static let AnnotationLink_FilePathType = "{{AnnotationLink_FilePath}}"
    }

    // swiftlint:enable variable_name

    static let availablePlaceholders: [String] = { () -> [String] in
        let selectionPlaceholders = Set(Preferences.availableSelectionPlaceholders)
        let annotationPlaceholders = Set(Preferences.availableAnnotationPlaceholders)
        return [String](selectionPlaceholders.union(annotationPlaceholders))
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
        Preferences.AnnotationPlaceholders.annotationType,
        Preferences.AnnotationPlaceholders.Color,
        Preferences.AnnotationPlaceholders.Author,
        Preferences.AnnotationPlaceholders.AnnotationDate,
        Preferences.AnnotationPlaceholders.ExportDate,
        Preferences.AnnotationPlaceholders.AnnotationLink_DEVONthinkUUIDType,
        Preferences.AnnotationPlaceholders.AnnotationLink_FilePathType
    ]

    var availablePlaceholders: [Any] {
        return Preferences.availablePlaceholders as [AnyObject]
    }

    var availableSelectionPlaceholders: [Any] {
        return Preferences.availableSelectionPlaceholders as [AnyObject]
    }

    var availableAnnotationPlaceholders: [Any] {
        return Preferences.availableAnnotationPlaceholders as [AnyObject]
    }

    var appForOpenPDF: PDFReaderApp {
        get {
            self.userDefaults.synchronize()
            return PDFReaderApp(rawValue: self.userDefaults.integer(forKey: Constants.AppForOpenPDF))!
        }

        set {
            self.userDefaults.set(newValue.rawValue, forKey: Constants.AppForOpenPDF)
            self.userDefaults.synchronize()
        }
    }

    var stringForSelectionLinkPlainText: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.string(forKey: Constants.SelectionLinkPlainText)!
        }

        set {
            self.userDefaults.set(newValue, forKey: Constants.SelectionLinkPlainText)
            self.userDefaults.synchronize()
        }
    }

    var boolForSelectionLinkRichTextSameAsPlainText: Bool { // swiftlint:disable:this identifier_name
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.bool(forKey: Constants.SelectionLinkRichTextSameAsPlainText)
        }
        set {
            self.userDefaults.set(newValue, forKey: Constants.SelectionLinkRichTextSameAsPlainText)
            self.userDefaults.synchronize()
        }
    }

    var stringForSelectionLinkRichText: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.string(forKey: Constants.SelectionLinkRichText)!
        }

        set {
            self.userDefaults.set(newValue, forKey: Constants.SelectionLinkRichText)
            self.userDefaults.synchronize()
        }
    }

    // swiftlint:disable identifier_name
    var boolForShowNotificationWhenFileNotFoundInDNtpForSelectionLink: Bool {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.bool(forKey: Constants.ShowNotificationWhenFileNotFoundInDNtpForSelectionLink)
        }

        set {
            self.userDefaults.set(newValue, forKey: Constants.ShowNotificationWhenFileNotFoundInDNtpForSelectionLink)
            self.userDefaults.synchronize()
        }
    }

    var stringForSelectionFilesLocation: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.string(forKey: Constants.SelectionFilesLocation)!
        }

        set {
            self.userDefaults.set(newValue, forKey: Constants.SelectionFilesLocation)
            self.userDefaults.synchronize()
        }
    }

    var stringForSelectionFileName: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.string(forKey: Constants.SelectionFileName)!
        }

        set {
            self.userDefaults.set(newValue, forKey: Constants.SelectionFileName)
            self.userDefaults.synchronize()
        }
    }

    var stringForSelectionFileExtension: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.string(forKey: Constants.SelectionFileExtension)!
        }

        set {
            self.userDefaults.set(newValue, forKey: Constants.SelectionFileExtension)
            self.userDefaults.synchronize()
        }
    }

    var stringForSelectionFileTags: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.string(forKey: Constants.SelectionFileTags)!
        }

        set {
            self.userDefaults.set(newValue, forKey: Constants.SelectionFileTags)
            self.userDefaults.synchronize()
        }
    }

    var stringForSelectionFileContent: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.string(forKey: Constants.SelectionFileContent)!
        }

        set {
            self.userDefaults.set(newValue, forKey: Constants.SelectionFileContent)
            self.userDefaults.synchronize()
        }
    }

    var boolForShowNotificationWhenFileNotFoundInDNtpForSelectionFile: Bool {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.bool(forKey: Constants.ShowNotificationWhenFileNotFoundInDNtpForSelectionFile)
        }

        set {
            self.userDefaults.set(newValue, forKey: Constants.ShowNotificationWhenFileNotFoundInDNtpForSelectionFile)
            self.userDefaults.synchronize()
        }
    }

    var stringForAnnotationFilesLocation: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.string(forKey: Constants.AnnotationFilesLocation)!
        }

        set {
            self.userDefaults.set(newValue, forKey: Constants.AnnotationFilesLocation)
            self.userDefaults.synchronize()
        }
    }

    var stringForAnnotationFileName: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.string(forKey: Constants.AnnotationFileName)!
        }

        set {
            self.userDefaults.set(newValue, forKey: Constants.AnnotationFileName)
            self.userDefaults.synchronize()
        }
    }

    var stringForAnnotationFileExtension: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.string(forKey: Constants.AnnotationFileExtension)!
        }

        set {
            self.userDefaults.set(newValue, forKey: Constants.AnnotationFileExtension)
            self.userDefaults.synchronize()
        }
    }

    var stringForAnnotationFileTags: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.string(forKey: Constants.AnnotationFileTags)!
        }

        set {
            self.userDefaults.set(newValue, forKey: Constants.AnnotationFileTags)
            self.userDefaults.synchronize()
        }
    }

    var stringForAnnotationFileContent: String {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.string(forKey: Constants.AnnotationFileContent)!
        }

        set {
            self.userDefaults.set(newValue, forKey: Constants.AnnotationFileContent)
            self.userDefaults.synchronize()
        }
    }

    var boolForShowNotificationWhenFileNotFoundInDNtpForAnnotationFile: Bool {
        get {
            self.userDefaults.synchronize()
            return self.userDefaults.bool(forKey: Constants.ShowNotificationWhenFileNotFoundInDNtpForAnnotationFile)
        }

        set {
            self.userDefaults.set(newValue, forKey: Constants.ShowNotificationWhenFileNotFoundInDNtpForAnnotationFile)
            self.userDefaults.synchronize()
        }
    }

    // Hidden preferences

    var dictionaryForPathVariables: [String: String] {
        self.userDefaults.synchronize()
        guard let dict = self.userDefaults.dictionary(forKey: Constants.PathVariables) as? [String: String] else {
            return [String: String]()
        }
        return dict
    }

    var dictionaryForPathSubstitutes: [String: String] {
        self.userDefaults.synchronize()
        guard let dict = self.userDefaults.dictionary(forKey: Constants.PathSubstitutes) as? [String: String] else {
            return [String: String]()
        }
        return dict
    }

    func resetSelectionLinkPreferences() {
        self.userDefaults.removeObject(forKey: Constants.SelectionLinkPlainText)
        self.userDefaults.removeObject(forKey: Constants.SelectionLinkRichTextSameAsPlainText)
        self.userDefaults.removeObject(forKey: Constants.SelectionLinkRichText)
        self.userDefaults.removeObject(forKey: Constants.ShowNotificationWhenFileNotFoundInDNtpForSelectionLink)
    }

    func resetSelectionFilePreferences() {
        self.userDefaults.removeObject(forKey: Constants.SelectionFilesLocation)
        self.userDefaults.removeObject(forKey: Constants.SelectionFileName)
        self.userDefaults.removeObject(forKey: Constants.SelectionFileExtension)
        self.userDefaults.removeObject(forKey: Constants.SelectionFileTags)
        self.userDefaults.removeObject(forKey: Constants.SelectionFileContent)
        self.userDefaults.removeObject(forKey: Constants.ShowNotificationWhenFileNotFoundInDNtpForSelectionFile)
    }

    func resetAnnotationFilePreferences() {
        self.userDefaults.removeObject(forKey: Constants.AnnotationFilesLocation)
        self.userDefaults.removeObject(forKey: Constants.AnnotationFileName)
        self.userDefaults.removeObject(forKey: Constants.AnnotationFileExtension)
        self.userDefaults.removeObject(forKey: Constants.AnnotationFileTags)
        self.userDefaults.removeObject(forKey: Constants.AnnotationFileContent)
        self.userDefaults.removeObject(forKey: Constants.ShowNotificationWhenFileNotFoundInDNtpForAnnotationFile)
    }

}
