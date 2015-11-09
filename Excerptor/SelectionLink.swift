//
//  SelectionLink.swift
//  Excerptor
//
//  Created by Chen Guo on 5/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Foundation
import ScriptingBridge
import Quartz

class SelectionLink: Link {
    
    private let selectionLocation: SelectionLocation!
    
    init(fileID: FileID, selectionLocation: SelectionLocation) {
        self.selectionLocation = selectionLocation
        super.init(fileID: fileID)
    }
    
    required convenience init?(location: Location, text: String?) {
        if let location = location as? SelectionLocation {
            self.init(selectionLocation: location)
        } else {
            exitWithError("SelectionLink init failed")
        }
    }
    
    convenience init(filePath: String, selectionLocation: SelectionLocation) {
        self.init(fileID: FileID.FilePath(filePath), selectionLocation: selectionLocation)
    }
    
    convenience init(dntpUuid: String, selectionLocation: SelectionLocation) {
        self.init(fileID: FileID.DNtpUuid(dntpUuid), selectionLocation: selectionLocation)
    }
    
    convenience init(filePathOrDNtpUuid: String, selectionLocation: SelectionLocation) {
        self.init(fileID: FileID(filePathOrDNtpUuid: filePathOrDNtpUuid), selectionLocation: selectionLocation)
    }
    
    convenience init(selectionLocation: SelectionLocation) {
        self.init(fileID: FileID.FilePath(selectionLocation.pdfFilePath), selectionLocation: selectionLocation)
    }

    required convenience init?(linkString: String) {
        guard linkString.hasPrefix(SelectionLink.head) else {
            exitWithError("The link string has incorrect head: " + linkString)
        }
        
        let linkStringWithoutHead = linkString.stringByRemovingPrefix(SelectionLink.head)
        let arr = linkStringWithoutHead.componentsSeparatedByString(":")

        guard arr.count == 3 else {
            exitWithError("The link string has incorrect number of components: " + linkString)
        }
        
        guard let fileIDString = arr[0].stringByRemovingPercentEncoding else {
            exitWithError("The link string contains an invalid file ID: " + linkString)
        }
        
        let fileID = FileID(filePathOrDNtpUuid: fileIDString)
        
        guard let selectionLocation = SelectionLocation(string: linkStringWithoutHead) else {
            exitWithError("Could not parse the link string to selection location: " + linkString)
        }
        self.init(fileID: fileID, selectionLocation: selectionLocation)
    }
    
    override var string: String {
        get {
            let fileIDString = fileID.string.stringByAddingPercentEncodingWithAllowedCharacters(URIUnreservedCharacterSet)!
            return "\(SelectionLink.head)\(fileIDString):\(selectionLocation.stringWithoutPDFFilePath)"
        }
    }
    
    override var location: Location {
        get {
            return selectionLocation
        }
    }
    
    var pageIndices: [Int] {
        get {
            return selectionLocation.pageIndices
        }
    }
    
    var firstPageIndex: Int {
        get {
            return pageIndices.reduce(Int.max) { min($0, $1) }
        }
    }
    
    var selectionTextArrayInOneLine: String {
        get {
            return selectionLocation.selectionTextInOneLine
        }
    }
    
    private struct Constants {
        static let SelectionTextDelimiter = "-"
    }
    
    override func getDNtpUuidTypeLink() -> Link? {
        if isDNtpUuidLinkType {
            return self
        }
        if let dntpUuid = getDNtpUuid() {
            return SelectionLink(dntpUuid: dntpUuid, selectionLocation: selectionLocation)
        } else {
            return nil
        }
    }
    
    override func getFilePathTypeLink() -> Link? {
        if isFilePathLinkType {
            return self
        }
        let filePath = getFilePath()
        return SelectionLink(filePath: filePath, selectionLocation: selectionLocation)
    }


}


extension SelectionLocation {
    var stringWithoutPDFFilePath: String {
        get {
            let selectionString = selectionLineLocations.map { $0.string.stringByAddingPercentEncodingWithAllowedCharacters(URIUnreservedCharacterSet)! }.joinWithSeparator(SelectionLink.Constants.SelectionTextDelimiter)
            let locationStrings = (selectionLineLocations as! [SelectionLineLocation]).map { (lineLocation: SelectionLineLocation) -> String in
                var lineLocationString = "p\(lineLocation.pageIndex + 1)_\(lineLocation.range.location)_\(lineLocation.range.length)"
                if Preferences.sharedPreferences.boolForSelectionLinkIncludesBoundsInfo {
                    lineLocationString += "_\(lineLocation.bound.origin.x)_\(lineLocation.bound.origin.y)_\(lineLocation.bound.size.width)_\(lineLocation.bound.size.height)"
                }
                return lineLocationString
            }
            return selectionString + ":" + locationStrings.joinWithSeparator("-")
        }
    }
    
    var pageIndices: [Int] {
        get {
            return (selectionLineLocations as! [SelectionLineLocation]).map { Int($0.pageIndex) }
        }
    }
    
    var selectionTextInOneLine: String {
        get {
            return selectionLineLocations.map { $0.string }.joinWithSeparator(" ")
        }
    }
    
    convenience init?(string: String) {
        let arr = string.componentsSeparatedByString(":")
        if arr.count != 3 {
            exitWithError("Incorrect selection link format")
        }
        let pdfFilePath = FileID(filePathOrDNtpUuid: arr[0].stringByRemovingPercentEncoding!).getFilePath()
        let stringArray = arr[1].componentsSeparatedByString(SelectionLink.Constants.SelectionTextDelimiter)
        let selectionArray = arr[2].componentsSeparatedByString("-")
        let zippedArray = Array(zip(stringArray, selectionArray))
        let selectionLineLocations = zippedArray.map { (stringAndSelection: (annotationString: String, selection: String)) -> SelectionLineLocation in
            let annotationString = stringAndSelection.annotationString.stringByRemovingPercentEncoding!
            let selectionString = stringAndSelection.selection
            if selectionString.hasPrefix("p") {
                let arr = String(selectionString.characters.dropFirst()).componentsSeparatedByString("_")
                if arr.count == 3 || arr.count == 7 {
                    if let pageNumber = Int(arr[0]),
                             location = Int(arr[1]),
                               length = Int(arr[2])
                    {
                        let pageIndex = UInt(pageNumber - 1)
                        let range = NSMakeRange(location, length)
                        var bound: NSRect = CGRectZero
                        if Preferences.sharedPreferences.boolForSelectionLinkIncludesBoundsInfo && arr.count == 7 {
                            if let x = NSNumberFormatter().numberFromString(arr[3])?.floatValue,
                                   y = NSNumberFormatter().numberFromString(arr[4])?.floatValue,
                               width = NSNumberFormatter().numberFromString(arr[5])?.floatValue,
                              height = NSNumberFormatter().numberFromString(arr[6])?.floatValue
                            {
                                bound = NSRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
                            }
                            else
                            {
                                exitWithError("Incorrect selection link format")
                            }
                        }
                        return SelectionLineLocation(string: annotationString, pageIndex: pageIndex, range: range, bound: bound)
                    }
                }
            }
            exitWithError("Incorrect selection link format")
        }
        self.init(PDFFilePath: pdfFilePath, selectionLineLocations: selectionLineLocations)
    }
}


