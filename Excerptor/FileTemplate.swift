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
    
    func writeToFileWithPropertyGettersDictionary(propertyGettersByPlaceholder: [String: () -> String]) -> Bool {
        let folderPath = self.folderPath.stringByReplacingWithDictionary(propertyGettersByPlaceholder)
        var fileName = self.fileName.stringByReplacingWithDictionary(propertyGettersByPlaceholder)
        let content = self.content.stringByReplacingWithDictionary(propertyGettersByPlaceholder)
        let fileExtension = self.fileExtension.stringByReplacingWithDictionary(propertyGettersByPlaceholder)
        let tags = self.tags.map { return $0.stringByReplacingWithDictionary(propertyGettersByPlaceholder) }
        let creationDateString = self.creationDate.stringByReplacingWithDictionary(propertyGettersByPlaceholder)
        let creationDate = NSDate.dateFromISO8601String(creationDateString)
        let modificationDateString = self.modificationDate.stringByReplacingWithDictionary(propertyGettersByPlaceholder)
        let modificationDate = NSDate.dateFromISO8601String(modificationDateString)

        if fileName.isEmpty {
            fileName = "Note " + String(String(content.hash).characters.suffix(4))    // Hope lucky.
        } else {
            fileName = fileName.stringByReplacingOccurrencesOfString("/", withString: "%2F", options: [], range: nil).stringByReplacingOccurrencesOfString(":", withString: "%3A", options: [], range: nil).stringByReplacingOccurrencesOfString("\n", withString: " ", options: [], range: nil)
            if fileName.characters.count > 192 {
                fileName = String(fileName.characters.prefix(192)) + "…"
            }
        }
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            exitWithError(error.localizedDescription)
        }
        
        let filePathWithoutExtension = NSURL(fileURLWithPath: folderPath).URLByAppendingPathComponent(fileName).path
        if let filePath = fileExtension.isEmpty ? filePathWithoutExtension : NSURL(fileURLWithPath: filePathWithoutExtension!).URLByAppendingPathExtension(fileExtension).path {
            
            if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
                NSLog("\(filePath) exists")
                return false
            }
            
            do {
                try content.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
            } catch let error as NSError {
                exitWithError("Could not write to file: \(filePath)\n" + error.localizedDescription)
            }
            
            do {
                try NSURL(fileURLWithPath: filePath).setResourceValue(tags, forKey: NSURLTagNamesKey)
            } catch let error as NSError {
                exitWithError("Could not set resource value \(tags.description) for key NSURLTagNamesKey to file: \(filePath)\n" + error.localizedDescription)
            }
            
            do {
                try NSFileManager.defaultManager().setAttributes([NSFileCreationDate: creationDate], ofItemAtPath: filePath)
            } catch let error as NSError {
                exitWithError("Could not set creation data: \(creationDate.description) of \(filePath)\n" + error.localizedDescription)
            }
            
            do {
                try NSFileManager.defaultManager().setAttributes([NSFileModificationDate: modificationDate], ofItemAtPath: filePath)
            } catch let error as NSError {
                exitWithError("Could not set modification date: \(modificationDate.description) of \(filePath)\n" + error.localizedDescription)
            }
            
            return true
            
        } else {
            return false
        }
    }
    
}
