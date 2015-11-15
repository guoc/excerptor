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
        
/* Xcode think this is too complex ..., so I rewrite all keys and values as separate variables.
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
*/

        let pap_AnnotationText = Preferences.AnnotationPlaceholders.AnnotationText
        let pap_AnnotationText_Getter = { self.annotationText ?? "" }
        let pap_NoteText = Preferences.AnnotationPlaceholders.NoteText
        let pap_NoteText_Getter = { self.noteText ?? "" }
        let pap_Type = Preferences.AnnotationPlaceholders.Type
        let pap_Type_Getter = { self.annotationType.string() }
        let pap_Color = Preferences.AnnotationPlaceholders.Color
        let pap_Color_Getter = { self.markupColor?.hexDescription ?? "NO COLOR" }
        let pap_Author = Preferences.AnnotationPlaceholders.Author
        let pap_Author_Getter = { self.author ?? "NO AUTHOR" }
        let pap_AnnotationDate = Preferences.AnnotationPlaceholders.AnnotationDate
        let pap_AnnotationDate_Getter = { (self.date ?? NSDate()).ISO8601String() }
        let pap_ExportDate = Preferences.AnnotationPlaceholders.ExportDate
        let pap_ExportDate_Getter = { NSDate().ISO8601String() }
        let pap_Page = Preferences.CommonPlaceholders.Page
        let pap_Page_Getter = { "\(self.pageIndex + 1)" }
        let pap_PDFFileLink_DEVONthinkUUIDType = Preferences.CommonPlaceholders.PDFFileLink_DEVONthinkUUIDType
        let pap_PDFFileLink_DEVONthinkUUIDType_Getter = { () -> String in
            if let dntpUuidLink = self.pdfFileID.getDNtpUuidFileID()?.urlString {
                return dntpUuidLink
            } else {
                notifyPDFFileNotFoundInDNtpWith(self.pdfFileID.getFilePath(), replacingPlaceholder: Preferences.CommonPlaceholders.PDFFileLink_FilePathType)
                return self.pdfFileID.getFilePathFileID().urlString
            }
        }
        let pap_PDFFileLink_FilePathType = Preferences.CommonPlaceholders.PDFFileLink_FilePathType
        let pap_PDFFileLink_FilePathType_Getter : () -> String = { self.pdfFileID.getFilePathFileID().urlString }
        let pap_PDFFilePath = Preferences.CommonPlaceholders.PDFFilePath
        let pap_PDFFilePath_Getter : () -> String = { self.pdfFileID.getFilePath() }
        let pap_PDFFileName = Preferences.CommonPlaceholders.PDFFileName
        let pap_PDFFileName_Getter : () -> String = { self.pdfFileName }
        let pap_PDFFileName_NoExtension = Preferences.CommonPlaceholders.PDFFileName_NoExtension
        let pap_PDFFileName_NoExtension_Getter : () -> String = { NSURL(fileURLWithPath: self.pdfFileName).URLByDeletingPathExtension!.lastPathComponent! }
        let pap_AnnotationLink_DEVONthinkUUIDType = Preferences.AnnotationPlaceholders.AnnotationLink_DEVONthinkUUIDType
        let pap_AnnotationLink_DEVONthinkUUIDType_Getter : () -> String = annotationDNtpUuidLinkGetter
        let pap_AnnotationLink_FilePathType = Preferences.AnnotationPlaceholders.AnnotationLink_FilePathType
        let pap_AnnotationLink_FilePathType_Getter : () -> String = annotationFilePathLinkGetter
        let pap_PDFFileDEVONthinkUUID = Preferences.CommonPlaceholders.PDFFileDEVONthinkUUID
        let pap_PDFFileDEVONthinkUUID_Getter : () -> String = { self.pdfFileID.getDNtpUuid() ?? "NOT FOUND" }
        
        let propertyGettersByPlaceholder: [String: () -> String] = [
            pap_AnnotationText: pap_AnnotationText_Getter,
            pap_NoteText: pap_NoteText_Getter,
            pap_Type: pap_Type_Getter,
            pap_Color: pap_Color_Getter,
            pap_Author: pap_Author_Getter,
            pap_AnnotationDate: pap_AnnotationDate_Getter,
            pap_ExportDate: pap_ExportDate_Getter,
            pap_Page: pap_Page_Getter,
            pap_PDFFileLink_DEVONthinkUUIDType: pap_PDFFileLink_DEVONthinkUUIDType_Getter,
            pap_PDFFileLink_FilePathType: pap_PDFFileLink_FilePathType_Getter,
            pap_PDFFilePath: pap_PDFFilePath_Getter,
            pap_PDFFileName: pap_PDFFileName_Getter,
            pap_PDFFileName_NoExtension: pap_PDFFileName_NoExtension_Getter,
            pap_AnnotationLink_DEVONthinkUUIDType: pap_AnnotationLink_DEVONthinkUUIDType_Getter,
            pap_AnnotationLink_FilePathType: pap_AnnotationLink_FilePathType_Getter,
            pap_PDFFileDEVONthinkUUID: pap_PDFFileDEVONthinkUUID_Getter
        ]
        
        return annotationFileTemplate.writeToFileWithPropertyGettersDictionary(propertyGettersByPlaceholder)
    }


}

