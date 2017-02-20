//
//  global-functions.swift
//  Excerptor
//
//  Created by Chen Guo on 22/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Foundation

enum OutputFormat {
    case json
    case text
}

let annotationFilter = { (annotation: PDFAnnotation) -> Bool in
    return annotation.shouldPrint
        && annotation.typeName != "Caret"
        && annotation.typeName != SKNCircleString
        && annotation.typeName != SKNSquareString
        && annotation.typeName != SKNLineString
        && annotation.typeName != SKNInkString
}

func printAnnotationsFrom(_ pdfFileUrl: URL, withFormat outputFormat: OutputFormat) {
    var skimNotes = NSArray()
    let document = PDFDocument(url: pdfFileUrl, readSkimNotes: AutoreleasingUnsafeMutablePointer<NSArray?>(&skimNotes))
    if document == nil {
        print("File not recognized")
        exit(1)
    }
    // Calling of page() on PDFAnnotation should in current scope, rather than it will fail because its property page(PDFPage) will be released caused by the release of document(PDFDocument)
    let allAnnotations: [PDFAnnotation]
    if skimNotes.count > 0 {
        guard let unwrappedSkimNotes = skimNotes as? [PDFAnnotation] else {
            exitWithError("Invalid Skim notes: \(skimNotes)")
        }
        allAnnotations = unwrappedSkimNotes
    } else {
        allAnnotations = (document?.annotations)!
    }
    let validAnnotations = allAnnotations.filter(annotationFilter)
    switch outputFormat {
    case .json:
        let JSONText = JSONTextFromAnnotations(validAnnotations)
        print(JSONText)
    case .text:
        let text = textFromAnnotations(validAnnotations)
        print(text)
    }
}

func writePDFAnnotationsFromFilesIn(_ folderUrl: URL) {
    let dirEnumerator = FileManager.default.enumerator(at: folderUrl.standardizedFileURL, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey], options: [], errorHandler: nil)
    while let theURL: URL = dirEnumerator?.nextObject() as? URL {
        var isDirectory: AnyObject?
        do {
            try (theURL as NSURL).getResourceValue(&isDirectory, forKey: URLResourceKey.isDirectoryKey)
        } catch {
            exitWithError("Could not test whether the url is a directory or not: " + theURL.description)
        }
        if let isDirectory = (isDirectory as? NSNumber)?.boolValue, !isDirectory {
            writePDFAnnotationsIfNecessaryFrom(theURL)
        }
    }
}

func writePDFAnnotationsIfNecessaryFrom(_ fileUrl: URL) {
    if let pathExtension = fileUrl.pathExtension, pathExtension.lowercased() == "pdf" {
        writePDFAnnotationsFrom(fileUrl)
    }
}

func writePDFAnnotationsFrom(_ pdfFileUrl: URL) {
    var skimNotes = NSArray()
    let document = PDFDocument(url: pdfFileUrl, readSkimNotes: AutoreleasingUnsafeMutablePointer<NSArray?>(&skimNotes))
    if document == nil {
        exitWithError("File not recognized")
    }
    // Calling of page() on PDFAnnotation should in current scope, rather than it will fail because its property page(PDFPage) will be released caused by the release of document(PDFDocument)
    let allAnnotations: [PDFAnnotation]
    if skimNotes.count > 0 {
        guard let unwrappedSkimNotes = skimNotes as? [PDFAnnotation] else {
            exitWithError("Invalid Skim notes: \(skimNotes)")
        }
        allAnnotations = unwrappedSkimNotes
    } else {
        allAnnotations = (document?.annotations)!
    }
    let validAnnotations = allAnnotations.filter(annotationFilter)

    let fileName = Preferences.sharedPreferences.stringForAnnotationFileName
    let fileExtension = Preferences.sharedPreferences.stringForAnnotationFileExtension
    let folderPath = Preferences.sharedPreferences.stringForAnnotationFilesLocation
    let tags = Preferences.sharedPreferences.stringForAnnotationFileTags.components(separatedBy: ",").map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }.filter { !$0.isEmpty }
    let content = Preferences.sharedPreferences.stringForAnnotationFileContent
    let fileTemplate = FileTemplate(folderPath: folderPath, fileName: fileName, fileExtension: fileExtension, tags: tags, content: content, creationDate: Preferences.AnnotationPlaceholders.AnnotationDate, modificationDate: Preferences.AnnotationPlaceholders.ExportDate)

    for annotation in validAnnotations {
        Annotation(pdfAnnotation: annotation).writeToFileWith(fileTemplate)
    }
}

func JSONTextFromAnnotation(_ annotation: PDFAnnotation) -> String {
    return JSONTextFromJSONObject(annotation.JSONObjectPresentation)
}

func JSONTextFromAnnotations(_ annotations: [PDFAnnotation]) -> String {
    let JSONObjects = annotations.map { $0.JSONObjectPresentation }
    return JSONTextFromJSONObject(JSONObjects as AnyObject)
}

// swiftlint:disable variable_name
func JSONTextFromJSONObject(_ JSONObject: AnyObject) -> String {
    guard JSONSerialization.isValidJSONObject(JSONObject) else {
        exitWithError("\(JSONObject.description) is not valid JSON object")
    }

    let JSONData: Data
    do {
        JSONData = try JSONSerialization.data(withJSONObject: JSONObject, options: .prettyPrinted)
    } catch let error as NSError {
        exitWithError("\(error.localizedDescription) OR \(JSONObject.description) is not valid JSON object")
    }

    guard let JSONString = String(data: JSONData, encoding: String.Encoding.utf8) else {
        exitWithError("Fail to get string from date: " + JSONData.description)
    }

    return JSONString
}
// swiftlint:enable variable_name

func textFromAnnotation(_ annotation: PDFAnnotation) -> String {
    return [annotation.annotationText, annotation.noteText, Annotation.AnnotationType(string: annotation.typeName).string(), annotation.color.hexDescription, annotation.author, "\(annotation.pageIndex + 1)", annotation.date.ISO8601String()].joined(separator: "\t")
}

func textFromAnnotations(_ annotations: [PDFAnnotation]) -> String {
    return annotations.map { textFromAnnotation($0) }.joined(separator: "\n")
}

extension Annotation {
    convenience init(pdfAnnotation: PDFAnnotation) {
        let annotationText = (pdfAnnotation as? PDFAnnotationMarkup)?.selectionText ?? ""
        let noteText = pdfAnnotation.contents
        let annotationType = Annotation.AnnotationType(string: pdfAnnotation.typeName)
        let markupColor = pdfAnnotation.color
        let author = pdfAnnotation.author
        let date = pdfAnnotation.modificationDate
        let pageIndex = pdfAnnotation.page?.pageIndex
        let pdfFilePath = pdfAnnotation.page?.document?.documentURL?.path
        let pdfFileID = FileID(filePathOrDNtpUuid: pdfFilePath!)
        let pdfFileName = URL(fileURLWithPath: pdfFilePath!, isDirectory: false).lastPathComponent
        self.init(annotationText: annotationText, noteText: noteText, annotationType: annotationType, markupColor: markupColor, author: author, date: date, pageIndex: pageIndex, pdfFileID: pdfFileID, pdfFileName: pdfFileName!)
    }
}

extension PDFAnnotation {
    // swiftlint:disable variable_name
    var JSONObjectPresentation: AnyObject {
        get {
            let color = self.color
            let colorSpaceName = color.colorSpaceName
            let colorComponents = color.colorComponents

            let JSONObject = ["AnnotationText": annotationText, "NoteText": noteText, "TypeName": typeName, "Color": ["SpaceName": colorSpaceName, "Components": colorComponents], "Author": author, "PageIndex": pageIndex + 1, "Date": date.ISO8601String()] as [String : Any]

            return JSONObject as AnyObject
        }
    }
    // swiftlint:enable variable_name
}
