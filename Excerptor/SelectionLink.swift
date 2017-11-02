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

    fileprivate let selectionLocation: SelectionLocation!

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
        self.init(fileID: FileID.filePath(filePath), selectionLocation: selectionLocation)
    }

    convenience init(dntpUuid: String, selectionLocation: SelectionLocation) {
        self.init(fileID: FileID.dNtpUuid(dntpUuid), selectionLocation: selectionLocation)
    }

    convenience init(filePathOrDNtpUuid: String, selectionLocation: SelectionLocation) {
        self.init(fileID: FileID(filePathOrDNtpUuid: filePathOrDNtpUuid), selectionLocation: selectionLocation)
    }

    convenience init(selectionLocation: SelectionLocation) {
        self.init(fileID: FileID.filePath(selectionLocation.pdfFilePath), selectionLocation: selectionLocation)
    }

    required convenience init?(linkString: String) {
        guard linkString.hasPrefix(SelectionLink.head) else {
            exitWithError("The link string has incorrect head: " + linkString)
        }

        let linkStringWithoutHead = linkString.stringByRemovingPrefix(SelectionLink.head)
        let arr = linkStringWithoutHead.components(separatedBy: ":")

        guard arr.count == 3 else {
            exitWithError("The link string has incorrect number of components: " + linkString)
        }

        guard let fileIDString = arr[0].removingPercentEncoding else {
            exitWithError("The link string contains an invalid file ID: " + linkString)
        }

        let fileID = FileID(filePathOrDNtpUuid: fileIDString)

        guard let selectionLocation = SelectionLocation(string: linkStringWithoutHead) else {
            exitWithError("Could not parse the link string to selection location: " + linkString)
        }
        self.init(fileID: fileID, selectionLocation: selectionLocation)
    }

    override var string: String {
        let fileIDString = fileID.percentEncodedString
        return "\(SelectionLink.head)\(fileIDString):\(selectionLocation.stringWithoutPDFFilePath)"
    }

    override var location: Location {
        return selectionLocation
    }

    var pageIndices: [Int] {
        return selectionLocation.pageIndices
    }

    var firstPageIndex: Int {
        return pageIndices.reduce(Int.max) { min($0, $1) }
    }

    var selectionTextArrayInOneLine: String {
        return selectionLocation.selectionTextInOneLine
    }

    fileprivate struct Constants {
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
        let selectionString = selectionLineLocations.map { ($0 as AnyObject).string }.map { (string: String) -> String in
            let replacedString = string.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter({!$0.isEmpty}).joined(separator: "+")
            let allowedCharaterSet = NSMutableCharacterSet(charactersIn: "+")
            allowedCharaterSet.formUnion(with: URIUnreservedCharacterSet as CharacterSet)
            let encodedString = replacedString.addingPercentEncoding(withAllowedCharacters: allowedCharaterSet as CharacterSet)!
            return encodedString
        }.joined(separator: SelectionLink.Constants.SelectionTextDelimiter)
        guard let unwrappedSelectionLineLocations = selectionLineLocations as? [SelectionLineLocation] else {
            exitWithError("selectionLineLocations contain non-SelectionLineLocation object. selectionLineLocations: \(selectionLineLocations)")
        }
        let locationStrings = unwrappedSelectionLineLocations.map { (lineLocation: SelectionLineLocation) -> String in
            var lineLocationString = "p\(lineLocation.pageIndex + 1)_\(lineLocation.range.location)_\(lineLocation.range.length)"
            if Preferences.sharedPreferences.boolForSelectionLinkIncludesBoundsInfo {
                lineLocationString += "_\(lineLocation.bound.origin.x)_\(lineLocation.bound.origin.y)_\(lineLocation.bound.size.width)_\(lineLocation.bound.size.height)"
            }
            return lineLocationString
        }
        return selectionString + ":" + locationStrings.joined(separator: "-")
    }

    var pageIndices: [Int] {
        guard let unwrappedSelectionLineLocations = selectionLineLocations as? [SelectionLineLocation] else {
            exitWithError("selectionLineLocations contain non-SelectionLineLocation object. selectionLineLocations: \(selectionLineLocations)")
        }
        return unwrappedSelectionLineLocations.map { Int($0.pageIndex) }
    }

    var selectionTextInOneLine: String {
        return selectionLineLocations.map { ($0 as AnyObject).string }.joined(separator: " ")
    }

    convenience init?(string: String) {
        let arr = string.components(separatedBy: ":")
        if arr.count != 3 {
            exitWithError("Incorrect selection link format")
        }
        let pdfFilePath = FileID(filePathOrDNtpUuid: arr[0].removingPercentEncoding!).getFilePath()
        let stringArray = arr[1].components(separatedBy: SelectionLink.Constants.SelectionTextDelimiter)
        let selectionArray = arr[2].components(separatedBy: "-")
        let zippedArray = Array(zip(stringArray, selectionArray))
        let selectionLineLocations = zippedArray.map { (stringAndSelection: (annotationString: String, selection: String)) -> SelectionLineLocation in
            let annotationString = stringAndSelection.annotationString.removingPercentEncoding!
            let selectionString = stringAndSelection.selection
            if selectionString.hasPrefix("p") {
                let arr = String(selectionString.dropFirst()).components(separatedBy: "_")
                if arr.count == 3 || arr.count == 7 {
                    if let pageNumber = Int(arr[0]),
                             let location = Int(arr[1]),
                               let length = Int(arr[2])
                    // swiftlint:disable opening_brace
                    {
                        let pageIndex = UInt(pageNumber - 1)
                        let range = NSRange(location: location, length: length)
                        var bound: NSRect = CGRect.zero
                        if Preferences.sharedPreferences.boolForSelectionLinkIncludesBoundsInfo && arr.count == 7 {
                            if let x = NumberFormatter().number(from: arr[3])?.floatValue,
                                   let y = NumberFormatter().number(from: arr[4])?.floatValue,
                               let width = NumberFormatter().number(from: arr[5])?.floatValue,
                              let height = NumberFormatter().number(from: arr[6])?.floatValue
                            {
                                bound = NSRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
                            } else {
                                exitWithError("Incorrect selection link format")
                            }
                        }
                        return SelectionLineLocation(string: annotationString, pageIndex: pageIndex, range: range, bound: bound)
                    }
                    // swiftlint:enable opening_brace
                }
            }
            exitWithError("Incorrect selection link format")
        }
        self.init(pdfFilePath: pdfFilePath, selectionLineLocations: selectionLineLocations)
    }
// swiftlint:enable function_body_length

}
