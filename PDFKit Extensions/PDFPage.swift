import Foundation
import Quartz

extension PDFPage {

    var pageNumber: Int {
        return pageIndex + 1
    }

    var pageIndex: Int {
        return document!.index(for: self)
    }
}
