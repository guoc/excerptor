import Foundation
import Quartz

// MARK: - PDFAnnotation Extension

extension PDFAnnotation {

    var annotationText: String {
        get {
            return (self as? PDFAnnotationMarkup)?.selectionText ?? ""
        }
    }

    var noteText: String {
        get {
            return isSkimNote() ? string() : (contents() ?? "")
        }
    }

    var typeName: String {
        get {
            return type() ?? "Unrecognized"
        }
    }

    var author: String {
        get {
            return userName() ?? ""
        }
    }

    var pageIndex: Int {
        get {
            return page().pageIndex
        }
    }

    var date: NSDate {
        get {
            return modificationDate()
        }
    }

    var pdfFilePath: String {
        get {
            return self.page().document().documentURL().path!
        }
    }

    var pdfFileName: String {
        get {
            return NSURL(fileURLWithPath: pdfFilePath).lastPathComponent!
        }
    }

}
