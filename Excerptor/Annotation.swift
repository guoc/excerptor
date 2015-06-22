//
//  Annotation.swift
//  Excerptor
//
//  Created by Chen Guo on 6/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Foundation
import AppKit

class Annotation {

    enum AnnotationType {
        case Highlight
        case Strikeout
        case Underline
        case Note
        case Text
        case FreeText
        case Unrecognized
        
        init(string: String) {
            switch string {
            case "Highlight", SKNHighlightString, SKNMarkUpString:
                self = .Highlight
            case "Strikeout", SKNStrikeOutString:
                self = .Strikeout
            case "Underline", SKNUnderlineString:
                self = .Underline
            case "Note", SKNNoteString:
                self = .Note
            case "Text", SKNTextString:
                self = .Text
            case "FreeText", SKNFreeTextString:
                self = .FreeText
            default:
                self = .Unrecognized
            }
        }
        
        func string() -> String {
            switch self {
            case .Highlight: return "Highlight"
            case .Strikeout: return "Strikeout"
            case .Underline: return "Underline"
            case .Note: return "Note"
            case .Text: return "Text"
            case .FreeText: return "FreeText"
            case .Unrecognized: return "Unrecognized"
            }
        }
    }
    
    let annotationText: String?
    let noteText: String?
    var annotationOrNoteText: String { get { return annotationText ?? noteText! } }
    let annotationType: AnnotationType
    let markupColor: NSColor?
    let author: String?
    let date: NSDate?
    let pageIndex: Int
    let pdfFileID: FileID
    let pdfFileName: String
    
    init(annotationText: String?, noteText: String?, annotationType: AnnotationType, markupColor: NSColor?, author: String?, date: NSDate?, pageIndex: Int, pdfFileID: FileID, pdfFileName: String) {
        self.annotationText = annotationText
        self.noteText = noteText
        self.annotationType = annotationType
        self.markupColor = markupColor
        self.author = author
        self.date = date
        self.pageIndex = pageIndex
        self.pdfFileID = pdfFileID
        self.pdfFileName = pdfFileName
    }
    
    func writeToFileWith(annotationFileTemplate: FileTemplate) -> Bool {
        let annotationDNtpUuidLinkGetter = { () -> String in
            if let annotationDNtpUuidTypeLink = AnnotationLink(annotation: self)?.getDNtpUuidTypeLink()?.string {
                return annotationDNtpUuidTypeLink
            } else {
                if let annotationiFilePathTypeLink = AnnotationLink(annotation: self)?.getFilePathTypeLink()?.string {
                    notifyPDFFileNotFoundInDNtpWith(self.pdfFileID.getFilePath(), replacingPlaceholder: Preferences.AnnotationPlaceholders.AnnotationLink_FilePathType)
                    return annotationiFilePathTypeLink
                } else {
                    exitWithError("Fail to get annotation link")
                }
            }
        }
        let annotationFilePathLinkGetter = { () -> String in
            if let annotationFilePathTypeLink = AnnotationLink(annotation: self)?.getFilePathTypeLink()?.string {
                return annotationFilePathTypeLink
            } else {
                exitWithError("Fail to get annotation file path link")
            }
        }
        
        let propertyGettersByPlaceholder: [String: () -> String] = [
            Preferences.AnnotationPlaceholders.AnnotationText: { self.annotationText ?? "" },
            Preferences.AnnotationPlaceholders.NoteText: { self.noteText ?? "" },
            Preferences.AnnotationPlaceholders.Type: { self.annotationType.string() },
            Preferences.AnnotationPlaceholders.Color: { self.markupColor?.hexDescription ?? "NO COLOR" },
            Preferences.AnnotationPlaceholders.Author: { self.author ?? "NO AUTHOR" },
            Preferences.AnnotationPlaceholders.AnnotationDate: { (self.date ?? NSDate()).ISO8601String() },
            Preferences.AnnotationPlaceholders.ExportDate: { NSDate().ISO8601String() },
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
            Preferences.AnnotationPlaceholders.AnnotationLink_DEVONthinkUUIDType: annotationDNtpUuidLinkGetter,
            Preferences.AnnotationPlaceholders.AnnotationLink_FilePathType: annotationFilePathLinkGetter,
            Preferences.CommonPlaceholders.PDFFileDEVONthinkUUID: { self.pdfFileID.getDNtpUuid() ?? "NOT FOUND" }
        ]
        
        return annotationFileTemplate.writeToFileWithPropertyGettersDictionary(propertyGettersByPlaceholder)
    }


}

