//
//  FileTemplate.swift
//  Excerptor
//
//  Created by Chen Guo on 6/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Foundation

struct FileTemplate {

    // attribute templates
    let folderPath: String
    let fileName: String
    let fileExtension: String
    let tags: [String]
    let content: String
    let creationDate: String
    let modificationDate: String

// swiftlint:disable function_body_length
    func writeToFileWithPropertyGettersDictionary(_ propertyGettersByPlaceholder: [String: () -> String]) {
        let folderPath = self.folderPath.stringByReplacingWithDictionary(propertyGettersByPlaceholder)
        var fileName = self.fileName.stringByReplacingWithDictionary(propertyGettersByPlaceholder)
        let content = self.content.stringByReplacingWithDictionary(propertyGettersByPlaceholder)
        let fileExtension = self.fileExtension.stringByReplacingWithDictionary(propertyGettersByPlaceholder)
        let tags = self.tags.map { return $0.stringByReplacingWithDictionary(propertyGettersByPlaceholder) }
        let creationDateString = self.creationDate.stringByReplacingWithDictionary(propertyGettersByPlaceholder)
        let creationDate = Date.dateFromISO8601String(creationDateString)
        let modificationDateString = self.modificationDate.stringByReplacingWithDictionary(propertyGettersByPlaceholder)
        let modificationDate = Date.dateFromISO8601String(modificationDateString)

        if fileName.isEmpty {
            fileName = "Note " + String(String(content.hash).suffix(4))    // Hope lucky.
        } else {
            fileName = fileName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                               .replacingOccurrences(of: "/", with: "%2F", options: [], range: nil)
                               .replacingOccurrences(of: ":", with: "%3A", options: [], range: nil)
                               .replacingOccurrences(of: "\n", with: " ", options: [], range: nil)
            if fileName.count > 192 {
                fileName = String(fileName.prefix(192)) + "…"
            }
        }

        do {
            try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            exitWithError(error.localizedDescription)
        }

        let filePathWithoutExtension = URL(fileURLWithPath: folderPath).appendingPathComponent(fileName).path
        let expandedFilePathWithoutExtension = NSString(string: filePathWithoutExtension).expandingTildeInPath
        var filePath = fileExtension.isEmpty ? filePathWithoutExtension : URL(fileURLWithPath: expandedFilePathWithoutExtension).appendingPathExtension(fileExtension).path
        var serialNumber = 2 // if the filename exists, append serial number 2, 3, 4, ...
        while FileManager.default.fileExists(atPath: filePath) {
            filePath = fileExtension.isEmpty ? filePathWithoutExtension + " \(serialNumber)" : URL(fileURLWithPath: expandedFilePathWithoutExtension + " \(serialNumber)").appendingPathExtension(fileExtension).path
            serialNumber += 1
            if serialNumber > 10_000 {
                exitWithError("Too many duplicated file names: \(filePath)")
            }
        }

        do {
            try content.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            exitWithError("Could not write to file: \(filePath)\n" + error.localizedDescription)
        }

        do {
            try (URL(fileURLWithPath: filePath) as NSURL).setResourceValue(tags, forKey: URLResourceKey.tagNamesKey)
        } catch let error as NSError {
            exitWithError("Could not set resource value \(tags.description) for key NSURLTagNamesKey to file: \(filePath)\n" + error.localizedDescription)
        }

        do {
            try FileManager.default.setAttributes([FileAttributeKey.creationDate: creationDate as Any], ofItemAtPath: filePath)
        } catch let error as NSError {
            exitWithError("Could not set creation data: \(String(describing: creationDate?.description)) of \(filePath)\n" + error.localizedDescription)
        }

        do {
            try FileManager.default.setAttributes([FileAttributeKey.modificationDate: modificationDate as Any], ofItemAtPath: filePath)
        } catch let error as NSError {
            exitWithError("Could not set modification date: \(String(describing: modificationDate?.description)) of \(filePath)\n" + error.localizedDescription)
        }
    }
// swiftlint:enable function_body_length

}
