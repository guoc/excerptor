//
//  PasteboardHelper.swift
//  excerptor
//
//  Created by Chen Guo on 17/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Cocoa

class PasteboardHelper {

    struct Constants {
        static let OutputPasteboardName = "name.guoc.excerptor.ExcerptorToPDFReader"
        static let InputPasteboardName = "name.guoc.excerptor.PDFReaderToExcerptor"
        static let PasteboardType = "org.nspasteboard.TransientType"
        static let ExcerptorToPDFReaderHeader = "ExcerptorToPDFReader:"
        static let PDFReaderToExcerptorHeader = "PDFReaderToExcerptor:"
    }

    class func writeGeneralPasteboardWith(selectionLink: SelectionLink?) -> Bool {
        if let selectionLink = selectionLink {
            let pasteboard = NSPasteboard.generalPasteboard()
            pasteboard.clearContents()
            let attributedString = NSAttributedString(string: selectionLink.selectionTextArrayInOneLine, attributes: [NSLinkAttributeName: selectionLink.string])
            return pasteboard.writeObjects([attributedString])
                && pasteboard.setString(selectionLink.string, forType:NSPasteboardTypeString)
        }
        return false
    }

    class func readExcerptorPasteboard() -> Location! {
        let pasteboard = NSPasteboard(name: Constants.InputPasteboardName)
        guard let data = pasteboard.dataForType(Constants.PasteboardType) else {
            exitWithError("Could not get selection/annotation information")
        }
        guard let unarchivedObject = NSKeyedUnarchiver.unarchiveObjectWithData(data) else {
            exitWithError("Could not unarchive object with data " + data.description)
        }
        guard let location = unarchivedObject as? Location else {
            if let errorMessage = unarchivedObject as? NSString {
                exitWithError("Error message in pasteboard: " + String(errorMessage))
            } else {
                exitWithError("Could not convert unarchived object to location " + unarchivedObject.description)
            }
        }
        return location
    }

    class func writeExcerptorPasteboardWithLocation(location: Location) -> Bool {
        let pasteboard = NSPasteboard(name: Constants.OutputPasteboardName)
        pasteboard.clearContents()
        let data = NSKeyedArchiver.archivedDataWithRootObject(location)
        return pasteboard.setData(data, forType:Constants.PasteboardType)
    }


}
