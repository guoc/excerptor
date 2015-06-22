//
//  global-functions.swift
//  Excerptor
//
//  Created by Chen Guo on 22/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Foundation

import SwiftyJSON

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
        println("File not recognized")
        exit(1)
    }
    // Calling of page() on PDFAnnotation should in current scope, rather than it will fail because its property page(PDFPage) will be released caused by the release of document(PDFDocument)
    let allAnnotations = skimNotes.count > 0 ? skimNotes as! [PDFAnnotation] : document.annotations
    let validAnnotations = allAnnotations.filter(annotationFilter)
    switch outputFormat {
    case .JSON:
        let json = jsonFromAnnotations(validAnnotations)
        println(json.rawString()!)
    case .Text:
        let text = textFromAnnotations(validAnnotations)
        println(text)
    }
}

func writePDFAnnotationsFromFilesIn(folderUrl: NSURL) {
    let dirEnumerator = NSFileManager.defaultManager().enumeratorAtURL(folderUrl.URLByStandardizingPath!, includingPropertiesForKeys: [NSURLIsDirectoryKey], options: nil, errorHandler: nil)
    while let theURL:NSURL = dirEnumerator?.nextObject() as? NSURL {
        var isDirectory: AnyObject?
        theURL.getResourceValue(&isDirectory, forKey: NSURLIsDirectoryKey, error: nil)
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
    writePDFAnnotationsFrom(pdfFileUrl, toTargetFolder: NSURL(fileURLWithPath: Preferences.sharedPreferences.stringForAnnotationFilesLocation.stringByStandardizingPath, isDirectory: true)!)
}

func writePDFAnnotationsFrom(pdfFileUrl: NSURL, toTargetFolder targetFolderUrl: NSURL) {
    var skimNotes = NSArray()
    let document = PDFDocument(URL: pdfFileUrl, readSkimNotes: AutoreleasingUnsafeMutablePointer<NSArray?>(&skimNotes))
    if document == nil {
        exitWithError("File not recognized")
    }
    // Calling of page() on PDFAnnotation should in current scope, rather than it will fail because its property page(PDFPage) will be released caused by the release of document(PDFDocument)
    let allAnnotations = skimNotes.count > 0 ? skimNotes as! [PDFAnnotation] : document.annotations
    let validAnnotations = allAnnotations.filter(annotationFilter)
    
    let fileName = Preferences.sharedPreferences.stringForAnnotationFileName
    let fileExtension = Preferences.sharedPreferences.stringForAnnotationFileExtension
    let folderPath = Preferences.sharedPreferences.stringForAnnotationFilesLocation.stringByExpandingTildeInPath
    let tags = Preferences.sharedPreferences.stringForAnnotationFileTags.componentsSeparatedByString(",").map { $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) }.filter { !$0.isEmpty }
    let content = Preferences.sharedPreferences.stringForAnnotationFileContent
    let fileTemplate = FileTemplate(folderPath: folderPath, fileName: fileName, fileExtension: fileExtension, tags: tags, content: content, creationDate: Preferences.AnnotationPlaceholders.AnnotationDate, modificationDate: Preferences.AnnotationPlaceholders.ExportDate)
    
    for annotation in validAnnotations {
        Annotation(pdfAnnotation: annotation).writeToFileWith(fileTemplate)
    }
}

func jsonFromAnnotation(annotation: PDFAnnotation) -> JSON {
    let color = annotation.color()
    let colorSpaceName = color.colorSpaceName
    let colorComponents = color.colorComponents
    
    let annotationJSON: JSON = ["AnnotationText": annotation.annotationText, "NoteText": annotation.noteText, "TypeName": annotation.typeName, "Color": ["SpaceName": colorSpaceName, "Components": colorComponents], "Author": annotation.author, "PageIndex": annotation.pageIndex + 1, "Date": annotation.date.ISO8601String()]
    
    return annotationJSON
}

func jsonFromAnnotations(annotations: [PDFAnnotation]) -> JSON {
    let jsons = annotations.map { jsonFromAnnotation($0) }
    return JSON(jsons)
}

func textFromAnnotation(annotation: PDFAnnotation) -> String {
    return "\t".join([annotation.annotationText, annotation.noteText, Annotation.AnnotationType(string: annotation.typeName).string(), annotation.color().hexDescription, annotation.author, "\(annotation.pageIndex + 1)", annotation.date.ISO8601String()])
}

func textFromAnnotations(annotations: [PDFAnnotation]) -> String {
    return "\n".join(annotations.map { textFromAnnotation($0) })
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
        let pdfFileName = pdfFilePath.lastPathComponent
        self.init(annotationText: annotationText, noteText: noteText, annotationType: annotationType, markupColor: markupColor, author: author, date: date, pageIndex: pageIndex, pdfFileID: pdfFileID, pdfFileName: pdfFileName)
    }
}

