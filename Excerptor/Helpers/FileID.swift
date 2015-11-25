//
//  FileID.swift
//  Excerptor
//
//  Created by Chen Guo on 6/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Foundation
import ScriptingBridge

enum FileID {

    case FilePath(String)
    case DNtpUuid(String)

    init(filePathOrDNtpUuid: String) {
        if filePathOrDNtpUuid.hasPrefix("/") {
            self = .FilePath(filePathOrDNtpUuid)
        } else {
            self = .DNtpUuid(filePathOrDNtpUuid)
        }
    }

    var string: String {
        get {
            switch self {
            case .DNtpUuid(let str):
                return str
            case .FilePath(let str):
                return str
            }
        }
    }

    var urlString: String {
        get {
            if isFilePath {
                return "file://\(string)"
            } else {
                return "x-devonthink-item://\(string)"
            }
        }
    }

    func getFilePath() -> String {
        if isFilePath {
            return string
        } else {
            return getFilePathWithDNtpUuid(string)
        }
    }

    func getDNtpUuid() -> String? {
        if isDNtpUuid {
            return string
        } else {
            return getDNtpUuidWithFilePath(string)
        }
    }

    func getFilePathFileID() -> FileID {
        return FileID(filePathOrDNtpUuid: getFilePath())
    }

    func getDNtpUuidFileID() -> FileID? {
        if let dntpUuid = getDNtpUuid() {
            return FileID(filePathOrDNtpUuid: dntpUuid)
        } else {
            return nil
        }
    }

    var isFilePath: Bool {
        get {
            switch self {
            case .FilePath(_):
                return true
            case .DNtpUuid(_):
                return false
            }
        }
    }

    var isDNtpUuid: Bool {
        get {
            return !isFilePath
        }
    }

    private func getDNtpUuidWithFilePath(filePath: String?) -> String? {
        if let dntp = SBApplication(bundleIdentifier: "com.devon-technologies.thinkpro2") as DEVONthinkProApplication? {
            guard var databases = (dntp.databases!() as NSArray) as? [DEVONthinkProDatabase] else {
                exitWithError("Could not read DNtp database")
            }
            if let currentDatabase = dntp.currentDatabase {
                // Reorder to make currentDatabase first
                let otherDatabases = databases.filter { !$0.isEqual(currentDatabase) }
                databases = [currentDatabase] + otherDatabases
            }

            // Trade-off: If a file appears in multiple databases, only use first one and ignore others.
            for database: DEVONthinkProDatabase in databases {
                if let records = dntp.lookupRecordsWithPath?(filePath, `in`: database) as? [DEVONthinkProRecord] {
                    if records.count == 0 {
                        continue
                    } else if records.count == 1 {
                        return records[0].uuid
                    } else {
                        // For replicants, only one record should be returned. For duplicates, they shouldn't share same path.
                        exitWithError("More than one record found in DEVONthink Pro databases: \(database.name!)")
                    }
                }
            }
            NSLog("File not found in DEVONthink Pro databases")
        } else {
            exitWithError("DEVONthink Pro does not exist")
        }
        return nil
    }

    private func getFilePathWithDNtpUuid(dntpUuid: String) -> String! {
        if let dntp = SBApplication(bundleIdentifier: "com.devon-technologies.thinkpro2") as DEVONthinkProApplication? {
            guard var databases = (dntp.databases!() as NSArray) as? [DEVONthinkProDatabase] else {
                exitWithError("Could not read DNtp database")
            }
            if let currentDatabase = dntp.currentDatabase {
                // Reorder to make currentDatabase first
                let otherDatabases = databases.filter { !$0.isEqual(currentDatabase) }
                databases = [currentDatabase] + otherDatabases
            }

            // Trade-off: If a file appears in multiple databases, only use first one and ignore others.
            for database: DEVONthinkProDatabase in databases {
                if let record = dntp.getRecordWithUuid?(dntpUuid, `in`: database) {
                    return record.path
                }
            }
            exitWithError("UUID not found in DEVONthink Pro databases")
        } else {
            exitWithError("DEVONthink Pro does not exist")
        }
    }

}
