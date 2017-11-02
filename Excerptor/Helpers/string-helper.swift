//
//  string-helper.swift
//  excerptor
//
//  Created by Chen Guo on 17/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

let URIUnreservedCharacterSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~")
// swiftlint:enable variable_name

extension String {
    func stringByRemovingPrefix(_ prefix: String) -> String {
        if let r = prefix.range(of: prefix, options: .anchored, range: nil, locale: nil) {
            return String(self[r.upperBound...])
        }
        return self
    }

    func stringByReplacingWithDictionary(_ stringGettersByPlaceholder: [String: () -> String]) -> String {

        var string = self
        for (placeholder, stringGetter) in stringGettersByPlaceholder {
            if string.range(of: placeholder, options: [], range: nil, locale: nil) == nil {
                continue
            } else {
                string = string.replacingOccurrences(of: placeholder, with: stringGetter(), options: [], range: nil)
            }
        }
        return string
    }

    var isDNtpUUID: Bool {
        let regex = try! NSRegularExpression(pattern: "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", options: [.caseInsensitive]) // swiftlint:disable:this force_try
        let range = NSRange(location: 0, length: count)
        guard let firstMatch = regex.firstMatch(in: self, options: [.anchored], range: range)?.range else {
            return false
        }
        return NSEqualRanges(firstMatch, range)
    }
}
