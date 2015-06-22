//
//  SKNExtendedAttributeManager.h
//
//  Created by Adam R. Maxwell on 05/12/05.
/*
 This software is Copyright (c) 2005-2014
 Adam R. Maxwell. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

 - Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

 - Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in
    the documentation and/or other materials provided with the
    distribution.

 - Neither the name of Adam R. Maxwell nor the names of any
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
    @abstract    An singleton class to read and write extended attributes.
    @discussion  This header file declares API for a singleton class to read and write extended attributes in the format expected for Skim notes.
*/
#import <Foundation/Foundation.h>

/*!
    @enum        SKNXattrFlags 
    @abstract    Options for writing extended attributes.
    @discussion  These options can be passed to methods writing extended attributes to modify the way these methods behave.
    @constant    kSKNXattrDefault      Create or replace, follow symlinks, split data.
    @constant    kSKNXattrNoFollow     Don't follow symlinks.
    @constant    kSKNXattrCreateOnly   Setting will fail if the attribute already exists.
    @constant    kSKNXattrReplaceOnly  Setting will fail if the attribute does not exist.
    @constant    kSKNXattrNoSplitData  Don't split data objects into segments.
    @constant    kSKNXattrNoCompress   Don't compress data to reduce space for long attributes.
*/
enum {
    kSKNXattrDefault     = 0,
    kSKNXattrNoFollow    = 1 << 1,
    kSKNXattrCreateOnly  = 1 << 2,
    kSKNXattrReplaceOnly = 1 << 3,
    kSKNXattrNoSplitData = 1 << 4,
    kSKNXattrNoCompress  = 1 << 5
};
typedef NSInteger SKNXattrFlags;

/*!
    @discussion  Error domain for the extended attribute manager used for non-POSIX errors.
*/
extern NSString *SKNSkimNotesErrorDomain;

/*!
    @enum        SKNErrorCodes 
    @abstract    Error codes in the SKNSkimNotesErrorDomain.
    @discussion  These error codes are the non-POSIX errors returned by the extended attribute manager.  Apart from these, also errors from NSPOSIXErrorDomain can be returned.
    @constant    SKNReassembleAttributeFailedError  Fragments could not be reassembled to a combined value.
    @constant    SKNPlistSerializationFailedError   Property list serialization failed. Uses the description from NSPropertyListSerialization.
    @constant    SKNPlistDeserializationFailedError Property list deserialization failed. Uses the description from NSPropertyListSerialization.
*/
enum {
    SKNReassembleAttributeFailedError  = 1,
    SKNPlistSerializationFailedError   = 2,
    SKNPlistDeserializationFailedError = 3
};

/*!
    @abstract    Provides an Objective-C wrapper for the low-level BSD functions dealing with file attributes.
    @discussion  This class is the core object to read and write extended attributes, which are used to store Skim notes with PDF files.
*/
@interface SKNExtendedAttributeManager : NSObject {
    NSString *namePrefix;
    NSString *uniqueKey;
    NSString *wrapperKey;
    NSString *fragmentsKey;
}

/*!
    @abstract   Returns the shared instance.  You probably always should use this instance, and is required for Skim notes.
    @discussion This shared manager uses the default prefix and is used for reading and writing Skim notes to PDF files.  It may split attributes into fragments if the data is too long.
    @result     The default shared EA manager used for Skim notes.
*/
+ (id)sharedManager;

/*!
    @abstract   Returns a shared instance with nil prefix.  This instance never splits attributes, and can also not reassemble splitted attributes.
    @discussion This manager never splits attributes into fragments.  Settting attributes is always as if <code>kSKNXattrNoSplitData</code> is passed. Also when reading it will not be able to reassemble split attributes.
                However attributes that were set using this manager will be readable also by managers with different prefixes, such as the <code>sharedManager</code>.
    @result     A shared EA manager that never splits extended attributes.
*/
+ (id)sharedNoSplitManager;

/*!
    @abstract   Initializes a new extended attribute manager with keys and attribute name prefixes used for segments determined by a prefix.
    @discussion The prefix is used in splitting large attributes.  EA managers with different prefixes are mutually incompatible,
                i.e. attributes written with one manager cannot be safely read by a manager with a different prefix.
                It is safest to just use the shared instance.  The prefix should only contain characters that are valid in attribute names.
                This is the designated initializer, and should be used for any subclass.
    @param      prefix Defaults to <code>"net_sourceforge_skim-app"</code> for the shared instance.  If <code>nil</code>, the manager never splits attributes.
    @result     An initialized EA manager object.  This may be one of the shared managers.
*/
- (id)initWithPrefix:(NSString *)prefix;

/*!
    @abstract   Return a list of extended attributes for the given file.
    @discussion Calls <code>listxattr(2)</code> to determine all of the extended attributes, and returns them as
                an array of <code>NSString</code> objects.  Returns <code>nil</code> if an error occurs.  Does not return attribute names for fragments.
    @param      path Path to the object in the file system.
    @param      follow Follow symlinks (<code>listxattr(2)</code> does this by default, so typically you should pass <code>YES</code>).
    @param      error Error object describing the error if <code>nil</code> was returned.
    @result     Array of strings or <code>nil</code> if an error occurred.
*/
- (NSArray *)extendedAttributeNamesAtPath:(NSString *)path traverseLink:(BOOL)follow error:(NSError **)error;

/*!
    @abstract   Return the extended attribute named <code>attr</code> for a given file.
    @discussion Calls <code>getxattr(2)</code> to determine the extended attribute, and returns it as data.
    @param      attr The attribute name.
    @param      path Path to the object in the file system.
    @param      follow Follow symlinks (<code>getxattr(2)</code> does this by default, so typically you should pass <code>YES</code>).
    @param      error Error object describing the error if <code>nil</code> was returned.
    @result     Data object representing the extended attribute or <code>nil</code> if an error occurred.
*/
- (NSData *)extendedAttributeNamed:(NSString *)attr atPath:(NSString *)path traverseLink:(BOOL)follow error:(NSError **)error;

/*!
    @abstract   Returns all extended attributes for the given file, each as an <code>NSData</code> object.
    @discussion Calls <code>extendedAttributeNamesAtPath:traverseLink:error:</code> to find all attribute names and then calls <code>extendedAttributeNamed:atPath:traverseLink:error:</code> repreatedly for all attribute names.
    @param      path Path to the object in the file system.
    @param      follow Follow symlinks (<code>getxattr(2)</code> does this by default, so typically you should pass <code>YES</code>).
    @param      error Error object describing the error if <code>nil</code> was returned.
    @result     Dictionary of data objects as values and strings as key, or <code>nil</code> if an error occurred.
*/
- (NSDictionary *)allExtendedAttributesAtPath:(NSString *)path traverseLink:(BOOL)follow error:(NSError **)error;

/*!
    @abstract   Returns a property list using NSPropertyListSerialization.
    @discussion (comprehensive description)
    @param      attr The attribute name.
    @param      path Path to the object in the file system.
    @param      follow Follow symlinks (<code>getxattr(2)</code> does this by default, so typically you should pass <code>YES</code>).
    @param      error Error object describing the error if <code>nil</code> was returned.
    @result     A property list object <code>nil</code> if an error occurred.
*/
- (id)propertyListFromExtendedAttributeNamed:(NSString *)attr atPath:(NSString *)path traverseLink:(BOOL)follow error:(NSError **)error;

/*!
    @abstract   Sets the value of attribute named <code>attr</code> to <code>value</code>, which is an <code>NSData</code> object.
    @discussion Calls <code>setxattr(2)</code> to set the attributes for the file.
                If the options do not contain the <code>kSKNXattrNoSplitData</code> flag and the prefix is not <code>nil</code>, the data may be split into subfragments and a dictionary pointing to the fragments is saved in the attribute names <code>attr</code>.
    @param      attr The attribute name.
    @param      value The value of the attribute as <code>NSData</code>.
    @param      path Path to the object in the file system.
    @param      options See </code>SKNXattrFlags<code> for valid options and their behavior.
    @param      error Error object describing the error if <code>NO</code> was returned.
    @result     Returns <code>NO</code> if an error occurred.
*/
- (BOOL)setExtendedAttributeNamed:(NSString *)attr toValue:(NSData *)value atPath:(NSString *)path options:(SKNXattrFlags)options error:(NSError **)error;

/*!
    @abstract   Sets the extended attribute named <code>attr</code> to the specified property list.
    @discussion The plist is converted to <code>NSData</code> using <code>NSPropertyListSerialization</code> and set using <code>setExtendedAttributeNamed:toValue:atPath:options:error:</code>.
                For the non-split manager without prefix, the data may be compressed using <code>bzip2</code> when the archived data is too large.
    @param      attr The attribute name.
    @param      plist The value of the attribute as a plist object.
    @param      path Path to the object in the file system.
    @param      options See </code>SKNXattrFlags<code> for valid options and their behavior.
    @param      error Error object describing the error if <code>NO</code> was returned.
    @result     Returns <code>NO</code> if an error occurred.
*/
- (BOOL)setExtendedAttributeNamed:(NSString *)attr toPropertyListValue:(id)plist atPath:(NSString *)path options:(SKNXattrFlags)options error:(NSError **)error;

/*!
    @abstract   Removes the given attribute <code>attr</code> from the named file at <code>path</code>.
    @discussion Calls <code>removexattr(2)</code> to remove the given attribute from the file.
    @param      attr The attribute name.
    @param      path Path to the object in the file system.
    @param      follow Follow symlinks (<code>removexattr(2)</code> does this by default, so typically you should pass <code>YES</code>).
    @param      error Error object describing the error if <code>nil</code> was returned.
    @result     Returns <code>NO</code> if an error occurred.
*/
- (BOOL)removeExtendedAttributeNamed:(NSString *)attr atPath:(NSString *)path traverseLink:(BOOL)follow error:(NSError **)error;

/*!
    @abstract   Removes all extended attributes at the specified path.
    @discussion Calls <code>removexattr(2)</code> repeatedly to remove all attributes from the file.
    @param      path Path to the object in the file system.
    @param      follow Follow symlinks (<code>removexattr(2)</code> does this by default, so typically you should pass <code>YES</code>).
    @param      error Error object describing the error if <code>NO</code> was returned.
    @result     Returns <code>NO</code> if an error occurred.
*/
- (BOOL)removeAllExtendedAttributesAtPath:(NSString *)path traverseLink:(BOOL)follow error:(NSError **)error;

@end
