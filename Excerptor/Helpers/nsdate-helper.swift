//
//  nsdate-helper.swift
//  excerptor
//
//  Created by Chen Guo on 17/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

extension NSDate {
    class func dateFromISO8601String(ISO8601String: String) -> NSDate! {
        let ISO8601DateFormatter = NSDateFormatter()
        ISO8601DateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        ISO8601DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        if let date = ISO8601DateFormatter.dateFromString(ISO8601String) {
            return date
        } else {
            exitWithError("Could not parse date format")
        }
    }
    
    func ISO8601String() -> String {
        let ISO8601DateFormatter = NSDateFormatter()
        ISO8601DateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        ISO8601DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return ISO8601DateFormatter.stringFromDate(self)
    }
}

