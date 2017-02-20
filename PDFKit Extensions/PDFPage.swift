import Foundation
import Quartz

extension PDFPage {

    var pageNumber: Int {
        get {
            return pageIndex + 1
        }
    }

    var pageIndex: Int {
        get {
            return document!.index(for: self)
        }
    }
}
