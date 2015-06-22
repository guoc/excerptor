//
//  PDFAnnotation_SKNExtensions.h
//  SkimNotes
//
//  Created by Christiaan Hofman on 6/15/08.
/*
 This software is Copyright (c) 2008-2014
 Christiaan Hofman. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

 - Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

 - Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in
    the documentation and/or other materials provided with the
    distribution.

 - Neither the name of Christiaan Hofman nor the names of any
    contributors may be used to endorse or promote products derived
    from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*!
    @header      
    @abstract    An <code>PDFAnnotation</code> category to manage Skim notes.
    @discussion  This header file provides API for an <code>PDFAnnotation</code> categories to convert Skim note dictionaries to <code>PDFAnnotations</code> and back.
*/
#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

/*!
    @discussion  Global string for Free Text note type.
*/
extern NSString *SKNFreeTextString;
/*!
    @discussion  Global string for Text note type.
*/
extern NSString *SKNTextString;
/*!
    @discussion  Global string for Note note type.
*/
extern NSString *SKNNoteString;
/*!
    @discussion  Global string for Circle note type.
*/
extern NSString *SKNCircleString;
/*!
    @discussion  Global string for Square note type.
*/
extern NSString *SKNSquareString;
/*!
    @discussion  Global string for Mark Up note type.
*/
extern NSString *SKNMarkUpString;
/*!
    @discussion  Global string for Highlight note type.
*/
extern NSString *SKNHighlightString;
/*!
    @discussion  Global string for Underline note type.
*/
extern NSString *SKNUnderlineString;
/*!
    @discussion  Global string for Strike Out note type.
*/
extern NSString *SKNStrikeOutString;
/*!
    @discussion  Global string for Line note type.
*/
extern NSString *SKNLineString;
/*!
    @discussion  Global string for Ink note type.
*/
extern NSString *SKNInkString;

/*!
    @discussion  Global string for annotation type key.
*/
extern NSString *SKNPDFAnnotationTypeKey;
/*!
    @discussion  Global string for annotation bounds key.
*/
extern NSString *SKNPDFAnnotationBoundsKey;
/*!
    @discussion  Global string for annotation page key.
*/
extern NSString *SKNPDFAnnotationPageKey;
/*!
    @discussion  Global string for annotation page index key.
*/
extern NSString *SKNPDFAnnotationPageIndexKey;
/*!
    @discussion  Global string for annotation contents key.
*/
extern NSString *SKNPDFAnnotationContentsKey;
/*!
    @discussion  Global string for annotation string key.
*/
extern NSString *SKNPDFAnnotationStringKey;
/*!
    @discussion  Global string for annotation color key.
*/
extern NSString *SKNPDFAnnotationColorKey;
/*!
    @discussion  Global string for annotation border key.
*/
extern NSString *SKNPDFAnnotationBorderKey;
/*!
    @discussion  Global string for annotation line width key.
*/
extern NSString *SKNPDFAnnotationLineWidthKey;
/*!
    @discussion  Global string for annotation border style key.
*/
extern NSString *SKNPDFAnnotationBorderStyleKey;
/*!
    @discussion  Global string for annotation dash pattern key.
*/
extern NSString *SKNPDFAnnotationDashPatternKey;
/*!
    @discussion  Global string for annotation modification date key.
*/
extern NSString *SKNPDFAnnotationModificationDateKey;
/*!
    @discussion  Global string for annotation user name key.
*/
extern NSString *SKNPDFAnnotationUserNameKey;

/*!
    @discussion  Global string for annotation interior color key.
*/
extern NSString *SKNPDFAnnotationInteriorColorKey;

/*!
    @discussion  Global string for annotation start line style key.
*/
extern NSString *SKNPDFAnnotationStartLineStyleKey;
/*!
    @discussion  Global string for annotation end line style key.
*/
extern NSString *SKNPDFAnnotationEndLineStyleKey;
/*!
    @discussion  Global string for annotation start point key.
*/
extern NSString *SKNPDFAnnotationStartPointKey;
/*!
    @discussion  Global string for annotation end point key.
*/
extern NSString *SKNPDFAnnotationEndPointKey;

/*!
    @discussion  Global string for annotation font key.
*/
extern NSString *SKNPDFAnnotationFontKey;
/*!
    @discussion  Global string for annotation font color key.
*/
extern NSString *SKNPDFAnnotationFontColorKey;
/*!
    @discussion  Global string for annotation font name key.
*/
extern NSString *SKNPDFAnnotationFontNameKey;
/*!
    @discussion  Global string for annotation font size key.
*/
extern NSString *SKNPDFAnnotationFontSizeKey;
/*!
    @discussion  Global string for annotation text alignment key.
*/
extern NSString *SKNPDFAnnotationAlignmentKey;
/*!
    @discussion  Global string for annotation rotation key.
*/
extern NSString *SKNPDFAnnotationRotationKey;

/*!
    @discussion  Global string for annotation quadrilateral points key.
*/
extern NSString *SKNPDFAnnotationQuadrilateralPointsKey;

/*!
    @discussion  Global string for annotation icon type key.
*/
extern NSString *SKNPDFAnnotationIconTypeKey;

/*!
    @discussion  Global string for annotation point lists key.
*/
extern NSString *SKNPDFAnnotationPointListsKey;

/*!
    @abstract    Provides methods to translate between dictionary representations of Skim notes and <code>PDFAnnotation</code> objects.
    @discussion  Methods from this category are used by the <code>PDFDocument (SKNExtensions)</code> category to add new annotations from Skim notes.
*/
@interface PDFAnnotation (SKNExtensions)

/*!
    @abstract   Initializes a new Skim note annotation.  This is the designated initializer for a Skim note.
    @discussion This method can be implemented in subclasses to provide default properties for Skim notes.
    @param      bounds The bounding box of the annotation, in page space.
    @result     An initialized Skim note annotation instance, or <code>NULL</code> if the object could not be initialized.
*/
- (id)initSkimNoteWithBounds:(NSRect)bounds;

/*!
    @abstract   Initializes a new Skim note annotation with the given properties.
    @discussion This method determines the proper subclass from the value for the <code>"type"</code> key in dict, initializes an instance using <code>initSkimNoteWithBounds:</code>, and sets the known properties from dict. Implementations in subclasses should call it on super and set their properties from dict if available.
    @param      dict A dictionary with Skim notes properties, as returned from properties.  This is required to contain values for <code>"type"</code> and <code>"bounds"</code>.
    @result     An initialized Skim note annotation instance, or <code>NULL</code> if the object could not be initialized.
*/
- (id)initSkimNoteWithProperties:(NSDictionary *)dict;

/*!
    @abstract   The Skim notes properties.
    @discussion These properties can be used to initialize a new copy, and to save to extended attributes or file.
    @result     A dictionary with properties of the Skim note.  All values are standard Cocoa objects conforming to <code>NSCoding</code> and <code>NSCopying</code>.
*/
- (NSDictionary *)SkimNoteProperties;

/*!
    @abstract   Returns whether the annotation is a Skim note.  
    @discussion An annotation initalized with initializers starting with initSkimNote will return <code>YES</code> by default.
    @result     YES if the annotation is a Skim note; otherwise NO.
*/
- (BOOL)isSkimNote;

/*!
    @abstract   Sets whether the receiver is to be interpreted as a Skim note.
    @discussion You normally would not use this yourself, but rely on the initializer to set the <code>isSkimNote</code> flag.
    @param      flag Set this value to <code>YES</code> if you want the annotation to be interpreted as a Skim note.
*/
- (void)setSkimNote:(BOOL)flag;

/*!
    @abstract   The string value of the annotation.
    @discussion By default, this is just the same as the contents.  However for <code>SKNPDFAnnotationNote</code> the contents will contain both string and text.
    @result     A string representing the string value associated with the annotation.
*/
- (NSString *)string;

/*!
    @abstract   Sets the string of the annotation.  By default just sets the contents.
    @discussion By default just calls <code>setContent:</code>.
    @param      newString The new string value for the annotation.
*/
- (void)setString:(NSString *)newString;

@end

#pragma mark -

/*!
    @abstract    Provides methods to translate between dictionary representations of Skim notes and <code>PDFAnnotation</code> objects.
    @discussion  Implements <code>initSkimNotesWithProperties:</code> and properties to take care of the extra properties of a circle annotation.
*/
@interface PDFAnnotationCircle (SKNExtensions)
@end

#pragma mark -

/*!
    @abstract    Provides methods to translate between dictionary representations of Skim notes and <code>PDFAnnotation</code> objects.
    @discussion  Implements <code>initSkimNotesWithProperties:</code> and properties to take care of the extra properties of a square annotation.
*/
@interface PDFAnnotationSquare (SKNExtensions)
@end

#pragma mark -

/*!
    @abstract    Provides methods to translate between dictionary representations of Skim notes and <code>PDFAnnotation</code> objects.
    @discussion  Implements <code>initSkimNotesWithProperties:</code> and properties to take care of the extra properties of a line annotation.
*/
@interface PDFAnnotationLine (SKNExtensions)
@end

#pragma mark -

/*!
    @abstract    Provides methods to translate between dictionary representations of Skim notes and <code>PDFAnnotation</code> objects.
    @discussion  Implements <code>initSkimNotesWithProperties:</code> and properties to take care of the extra properties of a free text annotation.
*/
@interface PDFAnnotationFreeText (SKNExtensions)
@end

#pragma mark -

/*!
    @abstract    Provides methods to translate between dictionary representations of Skim notes and <code>PDFAnnotation</code> objects.
    @discussion  Implements <code>initSkimNotesWithProperties:</code> and properties to take care of the extra properties of a markup annotation.
*/
@interface PDFAnnotationMarkup (SKNExtensions)
@end

/*!
    @abstract    An informal protocol providing a method name for an optional method that may be implemented in a category.
    @discussion  This defines an optional method that another <code>PDFAnnotationMarkup</code> category may implement to provide a default color.
*/
@interface PDFAnnotationMarkup (SKNOptional)
/*!
    @abstract   Optional method to implement to return the default color to use for markup initialized with properties that do not contain a color.
    @param      markupType The markup style for which to return the default color.
    @discussion This optional method can be implemented in another category to provide a default color for Skim notes that have no color set in the properties dictionary.  This method is not implemented by default.
    @result     The default color for an annotation with the passed in markup style.
*/
+ (NSColor *)defaultSkimNoteColorForMarkupType:(NSInteger)markupType;
@end

#pragma mark -

/*!
    @abstract    Provides methods to translate between dictionary representations of Skim notes and <code>PDFAnnotation</code> objects.
    @discussion  Implements <code>initSkimNotesWithProperties:</code> and properties to take care of the extra properties of a text annotation.
*/
@interface PDFAnnotationText (SKNExtensions)
@end

#pragma mark -

/*!
    @abstract    Provides methods to translate between dictionary representations of Skim notes and <code>PDFAnnotation</code> objects.
    @discussion  Implements <code>initSkimNotesWithProperties:</code> and properties to take care of the extra properties of a text annotation.
*/
@interface PDFAnnotationInk (SKNExtensions)
/*!
    @abstract   Method to add a point to a path, to be used to build the path for a Skim note.
    @param      point The point to add to the path.
    @param      path The bezier path to add the point to.
    @discussion This method adds a cubic curve element to path to point.  It is used to build up paths for the Skim note from the points.  This is used in <code>initSkimNoteWithProperties:</code>.
*/
+ (void)addPoint:(NSPoint)point toSkimNotesPath:(NSBezierPath *)path;
@end
