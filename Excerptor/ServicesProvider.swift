//
//  ServicesProvider.swift
//  excerptor
//
//  Created by Chen Guo on 17/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

class ServicesProvider: NSObject {

    func getSelectionLink(pboard: NSPasteboard, userData: String, error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        PreferencesWindowController.needShowPreferences = false

        let selectionLink = generateFilePathTypeSelectionLink()
        let selection = Selection(selectionLink: selectionLink)
        selection.writeToPasteboardWithTemplateString(Preferences.sharedPreferences.stringForSelectionLinkRichText, plainTextTemplate: Preferences.sharedPreferences.stringForSelectionLinkPlainText)
    }

    func getSelectionFile(pboard: NSPasteboard?, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        PreferencesWindowController.needShowPreferences = false

        let selectionLink = generateFilePathTypeSelectionLink()
        let selection = Selection(selectionLink: selectionLink)

        let fileName = Preferences.sharedPreferences.stringForSelectionFileName
        let fileExtension = Preferences.sharedPreferences.stringForSelectionFileExtension
        let folderPath = String(NSString(string: Preferences.sharedPreferences.stringForSelectionFilesLocation).stringByExpandingTildeInPath)
        let tags = Preferences.sharedPreferences.stringForSelectionFileTags.componentsSeparatedByString(",").map { $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) }.filter { !$0.isEmpty }
        let content = Preferences.sharedPreferences.stringForSelectionFileContent
        let fileTemplate = FileTemplate(folderPath: folderPath, fileName: fileName, fileExtension: fileExtension, tags: tags, content: content, creationDate: Preferences.SelectionPlaceholders.CreationDate, modificationDate: Preferences.SelectionPlaceholders.CreationDate)
        selection.writeToFileWith(fileTemplate)
    }

    func getAnnotationFiles(pboard: NSPasteboard?, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        PreferencesWindowController.needShowPreferences = false
        if let pboard = pboard {
            guard let fileOrFolderNames = pboard.propertyListForType(NSFilenamesPboardType) as? [String] else {
                exitWithError("Could not get file names: \(pboard.propertyListForType(NSFilenamesPboardType))")
            }
            for fileOrFolderName: String in fileOrFolderNames {
                var isDirectory = ObjCBool(false)
                if NSFileManager.defaultManager().fileExistsAtPath(fileOrFolderName, isDirectory: &isDirectory) {
                    if isDirectory.boolValue {
                        writePDFAnnotationsFromFilesIn(NSURL(fileURLWithPath: fileOrFolderName))
                    } else {
                        writePDFAnnotationsIfNecessaryFrom(NSURL(fileURLWithPath: fileOrFolderName))
                    }
                }
            }
        }
    }

    func generateFilePathTypeSelectionLink() -> SelectionLink! {
        guard let selectionLocation = PasteboardHelper.readExcerptorPasteboard() as? SelectionLocation else {
            exitWithError("Invalid selection location: \(PasteboardHelper.readExcerptorPasteboard())")
        }
        return SelectionLink(selectionLocation: selectionLocation)
    }

    func generateDNtpUuidTypeSelectionLink() -> SelectionLink? {
        let selectionLink = generateFilePathTypeSelectionLink()
        return selectionLink.getDNtpUuidTypeLink() as? SelectionLink
    }


}


extension Selection {

    convenience init(selectionLink: SelectionLink) {
        let selectionText = selectionLink.selectionTextArrayInOneLine
        let author = NSUserName()
        let date = NSDate()
        let pageIndex = selectionLink.firstPageIndex
        let pdfFileID = selectionLink.fileID
        guard let pdfFileName = NSURL(fileURLWithPath: selectionLink.getFilePath(), isDirectory: false).lastPathComponent else {
            exitWithError("Could not get PDF file name " + selectionLink.getFilePath())
        }
        self.init(selectionText: selectionText, author: author, date: date, pageIndex: pageIndex, pdfFileID: pdfFileID, pdfFileName: pdfFileName)
        self.selectionLink = selectionLink
    }

}
