//
//  PDFDocument.swift
//  Excerptor
//
//  Created by Chen Guo on 21/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Quartz

extension PDFDocument {
    
    var pages: [PDFPage] {
        get {
            return (0..<self.pageCount()).map { self.pageAtIndex($0) }
        }
    }
    
    var annotations: [PDFAnnotation] {
        get {
            return pages.reduce([PDFAnnotation]()) { $0 + ($1.annotations() as! [PDFAnnotation]) }
        }
    }
}
