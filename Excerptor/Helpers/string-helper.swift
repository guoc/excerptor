//
//  string-helper.swift
//  excerptor
//
//  Created by Chen Guo on 17/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

let URIUnreservedCharacterSet = NSCharacterSet(charactersInString: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~")

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
            if string.rangeOfString(placeholder, options: nil, range: nil, locale: nil) == nil {
                continue
            } else {
                string = string.stringByReplacingOccurrencesOfString(placeholder, withString: stringGetter(), options: nil, range: nil)
            }
        }
        return string
    }
}

