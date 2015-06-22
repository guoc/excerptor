//
//  Link.swift
//  Excerptor
//
//  Created by Chen Guo on 9/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Foundation

class Link {
    static let head = "excerptor://"
    let fileID: FileID!
    
    init!() {
        fileID = nil
        return nil
    }
    
    init(fileID: FileID) {
        self.fileID = fileID
    }
    
    convenience init(filePath: String) {
        self.init(fileID: FileID.FilePath(filePath))
    }
    
    convenience init(dntpUuid: String) {
        self.init(fileID: FileID.DNtpUuid(dntpUuid))
    }
    
    convenience init(filePathOrDNtpUuid: String) {
        self.init(fileID: FileID(filePathOrDNtpUuid: filePathOrDNtpUuid))
    }
    
    required init?(location: Location, text: String?) {
        self.fileID = nil
        return nil
    }
    
    required init?(linkString: String) {
        if linkString.hasPrefix(Link.head) {
            let linkStringWithoutHead = linkString.stringByRemovingPrefix(Link.head)
            fileID = FileID(filePathOrDNtpUuid: linkStringWithoutHead)
            return
        } else {
            exitWithError("Incorrect link format")
        }
    }
    
    var string: String {
        get {
            return "\(Link.head)\(fileID.string)"
        }
    }
    
    var isFilePathLinkType: Bool {
        get {
            return fileID.isFilePath
        }
    }
    
    var isDNtpUuidLinkType: Bool {
        get {
            return !(fileID.isFilePath)
        }
    }
    
    var filePathOrDNtpUuid: String {
        return isFilePathLinkType ? "file://\(getFilePath())" : "x-devonthink-item://\(getDNtpUuid())"
    }
    
    func getFilePath() -> String {
        return fileID.getFilePath()
    }
    
    func getDNtpUuid() -> String? {
        return fileID.getDNtpUuid()
    }
    
    var location: Location {
        get {
            fatalError("Property location in subclass of Link must be overridden")
        }
    }
    
    func getDNtpUuidTypeLink() -> Link? {
        fatalError("getDNtpUuidTypeLink in subclass of Link must be overridden")
    }
    
    func getFilePathTypeLink() -> Link? {
        fatalError("getFilePathTypeLink in subclass of Link must be overridden")
    }
}
