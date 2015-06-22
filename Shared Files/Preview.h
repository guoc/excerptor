//
//  Preview.h
//  PDFReaderPlugin
//
//  Created by Chen Guo on 15/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

#ifndef PDFReaderPlugin_Preview_h
#define PDFReaderPlugin_Preview_h

@import Quartz;

@interface PVAnnotation : NSObject

@property(retain) NSDate *date;
@property struct CGRect bounds;

@end


@interface PVPDFView : PDFView

- (id)annotations;
- (void)selectAnnotation:(id)arg1 byModifyingExistingSelection:(BOOL)arg2;

@end


@interface PVMediaContainerBase : NSDocument

@end


@interface PVPDFPageContainer : PVMediaContainerBase

@property(retain) PDFDocument *pdfDocument; // @synthesize pdfDocument=_pdfDocument;

@end


@interface PVWindowController : NSWindowController

@property(readonly) PVPDFView *pdfView;

@end

#endif
