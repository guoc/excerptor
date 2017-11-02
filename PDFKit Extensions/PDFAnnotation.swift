import Foundation
import Quartz

// MARK: - PDFAnnotation Extension

extension PDFAnnotation {

    var annotationText: String {
        return (self as? PDFAnnotationMarkup)?.selectionText ?? ""
    }

    var noteText: String {
        return isSkimNote() ? string() : (contents ?? "")
    }

    var typeName: String {
        return type ?? "Unrecognized"
    }

    var author: String {
        return userName ?? ""
    }

    var pageIndex: Int {
        return page!.pageIndex
    }

    var date: Date {
        return modificationDate!
    }

    var pdfFilePath: String {
        return self.page!.document!.documentURL!.path
    }

    var pdfFileName: String {
        return URL(fileURLWithPath: pdfFilePath).lastPathComponent
    }

}
