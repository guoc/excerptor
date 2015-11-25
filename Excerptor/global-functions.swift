//
//  global-functions.swift
//  Excerptor
//
//  Created by Chen Guo on 22/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Foundation

enum OutputFormat {
    case JSON
    case Text
}

let annotationFilter = { (annotation: PDFAnnotation) -> Bool in
    return annotation.shouldPrint()
        && annotation.typeName != "Caret"
        && annotation.typeName != SKNCircleString
        && annotation.typeName != SKNSquareString
        && annotation.typeName != SKNLineString
        && annotation.typeName != SKNInkString
}

func printAnnotationsFrom(pdfFileUrl: NSURL, withFormat outputFormat: OutputFormat) {
    var skimNotes = NSArray()
    let document = PDFDocument(URL: pdfFileUrl, readSkimNotes: AutoreleasingUnsafeMutablePointer<NSArray?>(&skimNotes))
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
        allAnnotations = document.annotations
    }
    let validAnnotations = allAnnotations.filter(annotationFilter)
    switch outputFormat {
    case .JSON:
        let JSONText = JSONTextFromAnnotations(validAnnotations)
        print(JSONText)
    case .Text:
        let text = textFromAnnotations(validAnnotations)
        print(text)
    }
}

func writePDFAnnotationsFromFilesIn(folderUrl: NSURL) {
    let dirEnumerator = NSFileManager.defaultManager().enumeratorAtURL(folderUrl.URLByStandardizingPath!, includingPropertiesForKeys: [NSURLIsDirectoryKey], options: [], errorHandler: nil)
    while let theURL: NSURL = dirEnumerator?.nextObject() as? NSURL {
        var isDirectory: AnyObject?
        do {
            try theURL.getResourceValue(&isDirectory, forKey: NSURLIsDirectoryKey)
        } catch {
            exitWithError("Could not test whether the url is a directory or not: " + theURL.description)
        }
        if let isDirectory = (isDirectory as? NSNumber)?.boolValue where !isDirectory {
            writePDFAnnotationsIfNecessaryFrom(theURL)
        }
    }
}

func writePDFAnnotationsIfNecessaryFrom(fileUrl: NSURL) {
    if let pathExtension = fileUrl.pathExtension where pathExtension.lowercaseString == "pdf" {
        writePDFAnnotationsFrom(fileUrl)
    }
}

func writePDFAnnotationsFrom(pdfFileUrl: NSURL) {
    var skimNotes = NSArray()
    let document = PDFDocument(URL: pdfFileUrl, readSkimNotes: AutoreleasingUnsafeMutablePointer<NSArray?>(&skimNotes))
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
        allAnnotations = document.annotations
    }
    let validAnnotations = allAnnotations.filter(annotationFilter)

    let fileName = Preferences.sharedPreferences.stringForAnnotationFileName
    let fileExtension = Preferences.sharedPreferences.stringForAnnotationFileExtension
    let folderPath = Preferences.sharedPreferences.stringForAnnotationFilesLocation
    let tags = Preferences.sharedPreferences.stringForAnnotationFileTags.componentsSeparatedByString(",").map { $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) }.filter { !$0.isEmpty }
    let content = Preferences.sharedPreferences.stringForAnnotationFileContent
    let fileTemplate = FileTemplate(folderPath: folderPath, fileName: fileName, fileExtension: fileExtension, tags: tags, content: content, creationDate: Preferences.AnnotationPlaceholders.AnnotationDate, modificationDate: Preferences.AnnotationPlaceholders.ExportDate)

    for annotation in validAnnotations {
        Annotation(pdfAnnotation: annotation).writeToFileWith(fileTemplate)
    }
}

func JSONTextFromAnnotation(annotation: PDFAnnotation) -> String {
    return JSONTextFromJSONObject(annotation.JSONObjectPresentation)
}

func JSONTextFromAnnotations(annotations: [PDFAnnotation]) -> String {
    let JSONObjects = annotations.map { $0.JSONObjectPresentation }
    return JSONTextFromJSONObject(JSONObjects)
}

// swiftlint:disable variable_name
func JSONTextFromJSONObject(JSONObject: AnyObject) -> String {
    guard NSJSONSerialization.isValidJSONObject(JSONObject) else {
        exitWithError("\(JSONObject.description) is not valid JSON object")
    }

    let JSONData: NSData
    do {
        JSONData = try NSJSONSerialization.dataWithJSONObject(JSONObject, options: .PrettyPrinted)
    } catch let error as NSError {
        exitWithError("\(error.localizedDescription) OR \(JSONObject.description) is not valid JSON object")
    }

    guard let JSONString = String(data: JSONData, encoding: NSUTF8StringEncoding) else {
        exitWithError("Fail to get string from date: " + JSONData.description)
    }

    return JSONString
}
// swiftlint:enable variable_name

func textFromAnnotation(annotation: PDFAnnotation) -> String {
    return [annotation.annotationText, annotation.noteText, Annotation.AnnotationType(string: annotation.typeName).string(), annotation.color().hexDescription, annotation.author, "\(annotation.pageIndex + 1)", annotation.date.ISO8601String()].joinWithSeparator("\t")
}

func textFromAnnotations(annotations: [PDFAnnotation]) -> String {
    return annotations.map { textFromAnnotation($0) }.joinWithSeparator("\n")
}

extension Annotation {
    convenience init(pdfAnnotation: PDFAnnotation) {
        let annotationText = (pdfAnnotation as? PDFAnnotationMarkup)?.selectionText ?? ""
        let noteText = pdfAnnotation.contents()
        let annotationType = Annotation.AnnotationType(string: pdfAnnotation.typeName)
        let markupColor = pdfAnnotation.color()
        let author = pdfAnnotation.author
        let date = pdfAnnotation.modificationDate()
        let pageIndex = pdfAnnotation.page().pageIndex
        let pdfFilePath = pdfAnnotation.page().document().documentURL().path!
        let pdfFileID = FileID(filePathOrDNtpUuid: pdfFilePath)
        let pdfFileName = NSURL(fileURLWithPath: pdfFilePath, isDirectory: false).lastPathComponent
        self.init(annotationText: annotationText, noteText: noteText, annotationType: annotationType, markupColor: markupColor, author: author, date: date, pageIndex: pageIndex, pdfFileID: pdfFileID, pdfFileName: pdfFileName!)
    }
}

extension PDFAnnotation {
    // swiftlint:disable variable_name
    var JSONObjectPresentation: AnyObject {
        get {
            let color = self.color()
            let colorSpaceName = color.colorSpaceName
            let colorComponents = color.colorComponents

            let JSONObject = ["AnnotationText": annotationText, "NoteText": noteText, "TypeName": typeName, "Color": ["SpaceName": colorSpaceName, "Components": colorComponents], "Author": author, "PageIndex": pageIndex + 1, "Date": date.ISO8601String()]

            return JSONObject
        }
    }
    // swiftlint:enable variable_name
}
