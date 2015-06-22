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
        var err: NSError?
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
            fileName = "Note " + suffix(String(content.hash), 4)    // Hope lucky.
        } else {
            fileName = fileName.stringByReplacingOccurrencesOfString("/", withString: "%2F", options: nil, range: nil).stringByReplacingOccurrencesOfString(":", withString: "%3A", options: nil, range: nil).stringByReplacingOccurrencesOfString("\n", withString: " ", options: nil, range: nil)
            if count(fileName) > 192 {
                fileName = prefix(fileName, 192) + "…"
            }
        }
        
        NSFileManager.defaultManager().createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil, error: &err)
        if let err = err {
            exitWithError(err.localizedDescription)
        }
        
        let filePathWithoutExtension = folderPath.stringByAppendingPathComponent(fileName)
        if let filePath = fileExtension.isEmpty ? filePathWithoutExtension : filePathWithoutExtension.stringByAppendingPathExtension(fileExtension) {
            
            if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
                NSLog("\(filePath) exists")
                return false
            }
            
            content.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding, error: &err)
            if let err = err {
                exitWithError(err.localizedDescription)
            }
            
            NSURL(fileURLWithPath: filePath)?.setResourceValue(tags, forKey: NSURLTagNamesKey, error: &err)
            if let err = err {
                exitWithError(err.localizedDescription)
            }
            
            NSFileManager.defaultManager().setAttributes([NSFileCreationDate: creationDate], ofItemAtPath: filePath, error: &err)
            if let err = err {
                exitWithError(err.localizedDescription)
            }
            
            NSFileManager.defaultManager().setAttributes([NSFileModificationDate: modificationDate], ofItemAtPath: filePath, error: &err)
            if let err = err {
                exitWithError(err.localizedDescription)
            }
            
            return true
            
        } else {
            return false
        }
    }
    
}
