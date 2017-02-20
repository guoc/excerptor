//
//  nsdate-helper.swift
//  excerptor
//
//  Created by Chen Guo on 17/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

extension Date {
    // swiftlint:disable variable_name
    static func dateFromISO8601String(_ ISO8601String: String) -> Date! {
        let ISO8601DateFormatter = DateFormatter()
        ISO8601DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        ISO8601DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        if let date = ISO8601DateFormatter.date(from: ISO8601String) {
            return date
        } else {
            exitWithError("Could not parse date format")
        }
    }
    // swiftlint:enable variable_name

    func ISO8601String() -> String {
        let ISO8601DateFormatter = DateFormatter()
        ISO8601DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        ISO8601DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return ISO8601DateFormatter.string(from: self)
    }
}
