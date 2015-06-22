//
//  Selection.swift
//  AnnotLink
//
//  Created by Chen Guo on 14/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Foundation

class Selection {
    
    let selectionText: String
    let author: String
    let date: NSDate
    let pageIndex: Int
    let pdfFileID: FileID
    let pdfFileName: String
    
    var selectionLink: SelectionLink?
    
    lazy var propertyGettersByPlaceholder: [String: () -> String] = [
        Preferences.SelectionPlaceholders.SelectionText: { self.selectionText },
        Preferences.SelectionPlaceholders.UserName: { self.author },
        Preferences.SelectionPlaceholders.CreationDate: { NSDate().ISO8601String() },
        Preferences.CommonPlaceholders.Page: { "\(self.pageIndex + 1)" },
        Preferences.CommonPlaceholders.PDFFileLink_DEVONthinkUUIDType: { () -> String in
            if let dntpUuidLink = self.pdfFileID.getDNtpUuidFileID()?.urlString {
                return dntpUuidLink
            } else {
                notifyPDFFileNotFoundInDNtpWith(self.pdfFileID.getFilePath(), replacingPlaceholder: Preferences.CommonPlaceholders.PDFFileLink_FilePathType)
                return self.pdfFileID.getFilePathFileID().urlString
            }
        },
        Preferences.CommonPlaceholders.PDFFileLink_FilePathType: { self.pdfFileID.getFilePathFileID().urlString },
        Preferences.CommonPlaceholders.PDFFilePath: { self.pdfFileID.getFilePath() },
        Preferences.CommonPlaceholders.PDFFileName: { self.pdfFileName },
        Preferences.CommonPlaceholders.PDFFileName_NoExtension: { self.pdfFileName.stringByDeletingPathExtension },
        Preferences.CommonPlaceholders.PDFFileDEVONthinkUUID: { self.pdfFileID.getDNtpUuid() ?? "NOT FOUND" },
        Preferences.SelectionPlaceholders.SelectionLink_DEVONthinkUUIDType: {
            if let selectionLink = self.selectionLink {
                if let selectionDNtpUuidTypeLink = selectionLink.getDNtpUuidTypeLink()?.string {
                    return selectionDNtpUuidTypeLink
                } else {
                    if Preferences.sharedPreferences.boolForShowNotificationWhenFileNotFoundInDNtpForSelectionFile {
                        notifyPDFFileNotFoundInDNtpWith(selectionLink.getFilePath(), replacingPlaceholder: Preferences.SelectionPlaceholders.SelectionLink_FilePathType)
                    }
                    return selectionLink.getFilePathTypeLink()!.string
                }
            } else {
                fatalError("selectionLink in Selection is required but did not set")
            }
        },
        Preferences.SelectionPlaceholders.SelectionLink_FilePathType: {
            if let selectionLink = self.selectionLink {
                return selectionLink.getFilePathTypeLink()!.string
            } else {
                fatalError("selectionLink in Selection is required but did not set")
            }
        }
    ]
    
    init(selectionText: String, author: String, date: NSDate, pageIndex: Int, pdfFileID: FileID, pdfFileName: String) {
        self.selectionText = selectionText
        self.author = author
        self.date = date
        self.pageIndex = pageIndex
        self.pdfFileID = pdfFileID
        self.pdfFileName = pdfFileName
    }
    
    func writeToFileWith(fileTemplate: FileTemplate) -> Bool {
        
        return fileTemplate.writeToFileWithPropertyGettersDictionary(propertyGettersByPlaceholder)
    }
    
    func writeToPasteboardWithTemplateString(richTextTemplate: String, plainTextTemplate: String) -> Bool {
        let pasteboard = NSPasteboard.generalPasteboard()
        pasteboard.clearContents()
        
        let plainTextToWrite = plainTextTemplate.stringByReplacingWithDictionary(self.propertyGettersByPlaceholder)

        if Preferences.sharedPreferences.boolForSelectionLinkRichTextSameAsPlainText {
            return pasteboard.setString(plainTextToWrite, forType:NSPasteboardTypeString)
        } else {
            let pattern = "(?:\\[([^)]+)\\])(?:\\(([^)]+)\\))"
            let regex = NSRegularExpression(pattern: pattern, options: .allZeros, error: nil)
            let range = NSMakeRange(0, count(richTextTemplate))
            let matches = regex?.matchesInString(richTextTemplate, options: .allZeros, range: range) as! [NSTextCheckingResult]
            let richTextToWrite = matches.map { (match: NSTextCheckingResult) -> (rangeToReplace: NSRange, text: String, link: String) in
                func rangeFromNSRange(range: NSRange) -> Range<String.Index> {
                    let start = advance(richTextTemplate.startIndex, range.location)
                    let end = advance(start, range.length)
                    return start..<end
                }
                
                let rangeToReplace = match.range
                let text = richTextTemplate.substringWithRange(rangeFromNSRange(match.rangeAtIndex(1))).stringByReplacingWithDictionary(self.propertyGettersByPlaceholder)
                let link = richTextTemplate.substringWithRange(rangeFromNSRange(match.rangeAtIndex(2))).stringByReplacingWithDictionary(self.propertyGettersByPlaceholder)
                return (rangeToReplace: rangeToReplace, text: text, link: link)
            }.reverse().reduce(NSMutableAttributedString(string: richTextTemplate)) { (attributedString: NSMutableAttributedString, linkStringInfo: (rangeToReplace: NSRange, text: String, link: String)) -> NSMutableAttributedString in
                let linkAttributedString = NSAttributedString(string: linkStringInfo.text, attributes: [NSLinkAttributeName: linkStringInfo.link])
                attributedString.replaceCharactersInRange(linkStringInfo.rangeToReplace, withAttributedString: linkAttributedString)
                return attributedString
            }
            
            return pasteboard.writeObjects([richTextToWrite])
                && pasteboard.setString(plainTextToWrite, forType:NSPasteboardTypeString)
        }

    }


}