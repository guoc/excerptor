//
//  string-helper.swift
//  excerptor
//
//  Created by Chen Guo on 17/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

// swiftlint:disable variable_name
let URIUnreservedCharacterSet = NSCharacterSet(charactersInString: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~")
// swiftlint:enable variable_name

extension String {
    func stringByRemovingPrefix(prefix: String) -> String {
        if let r = prefix.rangeOfString(prefix, options: .AnchoredSearch, range: nil, locale: nil) {
            return self.substringFromIndex(r.endIndex)
        }
        return self
    }

    func stringByReplacingWithDictionary(stringGettersByPlaceholder: [String: () -> String]) -> String {

        var string = self
        for (placeholder, stringGetter) in stringGettersByPlaceholder {
            if string.rangeOfString(placeholder, options: [], range: nil, locale: nil) == nil {
                continue
            } else {
                string = string.stringByReplacingOccurrencesOfString(placeholder, withString: stringGetter(), options: [], range: nil)
            }
        }
        return string
    }
    
    var isDNtpUUID: Bool {
        get {
            let regex = try! NSRegularExpression(pattern: "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", options: [.CaseInsensitive])
            let range = NSMakeRange(0, characters.count)
            guard let firstMatch = regex.firstMatchInString(self, options: [.Anchored], range: range)?.range else {
                return false
            }
            return NSEqualRanges(firstMatch, range)
        }
    }
}
