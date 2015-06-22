//
//  Skim.h
//  PDFReaderPlugin
//
//  Created by Chen Guo on 16/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#ifndef PDFReaderPlugin_Skim_h
#define PDFReaderPlugin_Skim_h

@interface SKPDFView : PDFView

- (void)scrollAnnotationToVisible:(PDFAnnotation *)annotation;
- (void)setActiveAnnotation:(PDFAnnotation *)newAnnotation;

@end


@interface SKMainDocument : NSDocument

@property (nonatomic, readonly) PDFDocument *pdfDocument;

@end

#endif
