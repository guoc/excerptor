import AppKit
import ScriptingBridge

@objc public protocol SBObjectProtocol: NSObjectProtocol {
    func get() -> AnyObject!
}

@objc public protocol SBApplicationProtocol: SBObjectProtocol {
    func activate()
    var delegate: SBApplicationDelegate! { get set }
}

// MARK: DEVONthinkProItem
@objc public protocol DEVONthinkProItem: SBObjectProtocol {
    @objc optional var properties: DEVONthinkProRecord { get set } // All of the object's properties.
    @objc optional func closeSaving(_ saving: String, savingIn: AnyObject!) // Close an object.
    @objc optional func delete() // Delete an object.
    @objc optional func duplicateTo(_ to: SBObject!, withProperties: DEVONthinkProRecord!) // Copy object(s) and put the copies at a new location.
    @objc optional func exists() -> Bool // Verify if an object exists.
    @objc optional func moveTo(_ to: SBObject!) // Move object(s) to a new location.
    @objc optional func saveAs(_ as: String!, in in_: AnyObject!) // Save an object.
    @objc optional func bold() // Bold some text
    @objc optional func italicize() // Italicize some text
    @objc optional func plain() // Make some text plain
    @objc optional func reformat() // Reformat some text. Similar to WordService's Reformat service.
    @objc optional func scrollToVisible() // Scroll to and animate some text. Requires Mac OS X 10.6.
    @objc optional func strike() // Strike some text
    @objc optional func unbold() // Unbold some text
    @objc optional func underline() // Underline some text
    @objc optional func unitalicize() // Unitalicize some text
    @objc optional func unstrike() // Unstrike some text
    @objc optional func ununderline() // Ununderline some text
    @objc optional func addRowCells(_ cells: [AnyObject]!) -> Bool // Add new row to current sheet.
    @objc optional func deleteRowAtPosition(_ position: Int) -> Bool // Remove row at specified position from current sheet.
    @objc optional func getCellAtColumn(_ column: Int, row: Int) -> String // Get content of cell at specified position of current sheet.
    @objc optional func setCellAtColumn(_ column: Int, row: Int, to: String!) -> Bool // Set cell at specified position of current sheet.
    @objc optional func convertImageRecord(_ record: DEVONthinkProRecord!, rotateBy: Int, to: DEVONthinkProRecord!, waitingForReply: Bool) -> DEVONthinkProRecord // Returns a searchable PDF for an image record.
    @objc optional func ocrFile(_ file: String!, attributes: DEVONthinkProRecord!, rotateBy: Int, to: DEVONthinkProRecord!, waitingForReply: Bool) -> DEVONthinkProRecord // Returns a record with a searchable PDF.
}
extension SBObject: DEVONthinkProItem {}

// MARK: DEVONthinkProApplication
@objc public protocol DEVONthinkProApplication: SBApplicationProtocol {
    @objc optional func documents() -> SBElementArray
    @objc optional func windows() -> SBElementArray
    @objc optional var frontmost: Bool { get } // Is this the frontmost (active) application?
    @objc optional var name: String { get } // The name of the application.
    @objc optional var version: String { get } // The version of the application.
    @objc optional func open(_ x: AnyObject!) -> DEVONthinkProDocument // Open an object.
    @objc optional func print(_ x: AnyObject!, printDialog: Bool, withProperties: DEVONthinkProPrintSettings!) // Print an object.
    @objc optional func quitSaving(_ saving: String) // Quit an application.
    @objc optional func addDownload(_ x: String!, automatic: Bool, password: String!, referrer: String!, user: String!) -> Bool // Add a URL to the download manager.
    @objc optional func backupDatabase(_ database: DEVONthinkProDatabase!, to: String!, includingFiles: Bool) -> Bool // Backup a DEVONthink Pro database.
    @objc optional func classifyRecord(_ record: DEVONthinkProRecord!) -> [AnyObject] // Get a list of classification proposals.
    @objc optional func compareContent(_ content: String!, record: DEVONthinkProRecord!, to: DEVONthinkProDatabase!) -> [AnyObject] // Get a list of similar records, either by specifying a record or a content (and database).
    @objc optional func compressDatabase(_ database: DEVONthinkProDatabase!, to: String!) -> Bool // Compress a DEVONthink Pro database into a Zip archive.
    @objc optional func consolidateRecord(_ record: DEVONthinkProRecord!) -> Bool // Move an external/indexed record (and its children) into the database.
    @objc optional func convertRecord(_ record: DEVONthinkProRecord!, in in_: DEVONthinkProRecord!, to: DEVONthinkProDatabase) -> DEVONthinkProRecord // Convert a record to simple or rich text and create a new record afterwards.
    @objc optional func convertFeedToHTML(_ x: String!, baseURL: String!) -> String // Convert a RSS, RDF or Atom feed to HTML.
    @objc optional func createDatabase(_ x: String!) -> DEVONthinkProDatabase // Create a new DEVONthink Pro database.
    @objc optional func createFormattedNoteFrom(_ x: String!, agent: String!, in in_: DEVONthinkProRecord!, name: String!, referrer: String!, source: String!) -> DEVONthinkProRecord // Create a new formatted note from a web page.
    @objc optional func createLocation(_ x: String!, in in_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Create a hierarchy of groups if necessary.
    @objc optional func createMarkdownFrom(_ x: String!, agent: String!, in in_: DEVONthinkProRecord!, name: String!, referrer: String!) -> DEVONthinkProRecord // Create a Markdown document from a web resource.
    @objc optional func createPDFDocumentFrom(_ x: String!, agent: String!, in in_: DEVONthinkProRecord!, name: String!, pagination: Bool, referrer: String!, width: Int) -> DEVONthinkProRecord // Create a new PDF document with or without pagination from a web resource.
    @objc optional func createThumbnailFor(_ for_: DEVONthinkProRecord!) -> Bool // Create image/movie thumbnail (and image info/characteristic) for a record.
    @objc optional func createWebDocumentFrom(_ x: String!, agent: String!, in in_: DEVONthinkProRecord!, name: String!, referrer: String!) -> DEVONthinkProRecord // Create a new record (picture, PDF or web archive) from a web resource.
    @objc optional func deconsolidateRecord(_ record: DEVONthinkProRecord!) -> Bool // Move an internal/imported record (and its children) to the enclosing external folder in the filesystem. Creation/Modification dates, Spotlight comments and OpenMeta tags are immediately updated.
    @objc optional func deleteRecord(_ record: DEVONthinkProRecord!, in in_: DEVONthinkProRecord!) -> Bool // Delete all instances of a record from the database or one instance from the specified group.
    @objc optional func deleteThumbnailOf(_ of: DEVONthinkProRecord!) -> Bool // Delete existing image/movie/web thumbnail of a record.
    @objc optional func deleteWorkspace(_ x: String!) -> Bool // Delete a workspace.
    @objc optional func displayAuthenticationDialog(_ x: String!) -> DEVONthinkProRecord // Display a dialog to enter a username and its password.
    @objc optional func displayGroupSelector(_ x: String!, buttons: [AnyObject]!, for for_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Display a dialog to select a (destination) group.
    @objc optional func displayNameEditor(_ x: String!, defaultAnswer: String!, info: String!) -> String // Display a dialog to enter a name.
    @objc optional func doJavaScript(_ x: String!, in in_: DEVONthinkProThinkWindow!) -> String // Applies a string of JavaScript code to a think window.
    @objc optional func downloadMarkupFrom(_ x: String!, agent: String!, encoding: String!, password: String!, post: DEVONthinkProRecord!, referrer: String!, user: String!) -> String // Download an HTML or XML page (including RSS, RDF or Atom feeds).
    @objc optional func downloadURL(_ x: String!, agent: String!, password: String!, post: DEVONthinkProRecord!, referrer: String!, user: String!) -> AnyObject // Download a URL.
    @objc optional func duplicateRecord(_ record: DEVONthinkProRecord!, to: DEVONthinkProRecord!) -> DEVONthinkProRecord // Duplicate a record.
    @objc optional func existsRecordAt(_ x: String!, in in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record exists at the specified location.
    @objc optional func existsRecordWithComment(_ x: String!, in in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified comment exists.
    @objc optional func existsRecordWithFile(_ x: String!, in in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified last path component exists.
    @objc optional func existsRecordWithPath(_ x: String!, in in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified path exists.
    @objc optional func existsRecordWithURL(_ x: String!, in in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified URL exists.
    @objc optional func exportRecord(_ record: DEVONthinkProRecord!, to: String!) -> String // Export a record (and its children).
    @objc optional func exportTagsOfRecord(_ record: DEVONthinkProRecord!) -> Bool // Export OpenMeta/Mavericks tags of a record.
    @objc optional func exportWebsiteRecord(_ record: DEVONthinkProRecord!, to: String!, encoding: String!, entities: Bool, indexPages: Bool, template template_: String!) -> String // Export a record (and its children) as a website.
    @objc optional func getCachedDataForURL(_ x: String!, from: DEVONthinkProTab!) -> AnyObject // Get cached data for URL of a resource which is part of a loaded webpage and its DOM tree, rendered in a think tab/window.
    @objc optional func getConcordanceOfRecord(_ record: DEVONthinkProRecord!, sortedBy: String) -> [AnyObject] // Get list of words of a record.
    @objc optional func getDatabaseWithId(_ x: Int) -> DEVONthinkProDatabase // Get database with the specified id.
    @objc optional func getDatabaseWithUuid(_ x: String!) -> DEVONthinkProDatabase // Get database with the specified uuid.
    @objc optional func getEmbeddedImagesOf(_ x: String!, baseURL: String!, type: String!) -> [AnyObject] // Get the URLs of all embedded images of an HTML page.
    @objc optional func getEmbeddedObjectsOf(_ x: String!, baseURL: String!, type: String!) -> [AnyObject] // Get the URLs of all embedded objects of an HTML page.
    @objc optional func getEmbeddedSheetsAndScriptsOf(_ x: String!, baseURL: String!, type: String!) -> [AnyObject] // Get the URLs of all embedded style sheets and scripts of an HTML page.
    @objc optional func getFramesOf(_ x: String!, baseURL: String!) -> [AnyObject] // Get the URLs of all frames of an HTML page.
    @objc optional func getItemsOfFeed(_ x: String!, baseURL: String!) -> [AnyObject] // Get the items of a RSS, RDF or Atom feed. Dictionaries contain title (text), link (text), annotationDate (text), calendarDate (annotationDate), description (text), content (text), author (text), html (item converted to HTML), tags (list) and enclosures (list)
    @objc optional func getLinksOf(_ x: String!, baseURL: String!, containing: String!, type: String!) -> [AnyObject] // Get the URLs of all links of an HTML page.
    @objc optional func getRecordAt(_ x: String!, in in_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Search for record at the specified location.
    @objc optional func getRecordWithId(_ x: Int, in in_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Get record with the specified id.
    @objc optional func getRecordWithUuid(_ x: String!, in in_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Get record with the specified uuid.
    @objc optional func getRichTextOf(_ x: String!, baseURL: String!) -> DEVONthinkProText // Get the rich text of an HTML page.
    @objc optional func getTextOf(_ x: String!) -> String // Get the text of an HTML page.
    @objc optional func getTitleOf(_ x: String!) -> String // Get the title of an HTML page.
    @objc optional func hideProgressIndicator() -> Bool // Hide a visible progress indicator.
    @objc optional func `import`(_ x: String!, from: String!, name: String!, placeholders: DEVONthinkProRecord!, to: DEVONthinkProRecord!, type: String) -> DEVONthinkProRecord // Import a file or folder (including its subfolders).
    @objc optional func importTemplate(_ x: String!, to: DEVONthinkProRecord!) -> DEVONthinkProRecord // Import a template. Note: Template scripts are not supported.
    @objc optional func indicate(_ x: String!, to: DEVONthinkProRecord!, type: String) -> DEVONthinkProRecord // Indicate ('index') a file or folder (including its subfolders). If no type is specified or the type is 'all', then links to unknown file types are created too.
    @objc optional func loadWorkspace(_ x: String!) -> Bool // Load a workspace.
    @objc optional func logMessage(_ x: String!, info: String!) -> Bool // Log info for a file or action to the Log panel of DEVONthink Pro.
    @objc optional func lookupRecordsWithComment(_ x: String!, in in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records with specified comment.
    @objc optional func lookupRecordsWithFile(_ x: String!, in in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records whose last path component is the specified file.
    @objc optional func lookupRecordsWithPath(_ x: String!, in in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records with specified path.
    @objc optional func lookupRecordsWithTags(_ x: [AnyObject]!, any: Bool, in in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records with all or any of the specified tags.
    @objc optional func lookupRecordsWithURL(_ x: String!, in in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records with specified URL.
    @objc optional func mergeRecords(_ records: [AnyObject]!, in in_: DEVONthinkProRecord!) -> DEVONthinkProRecord // Merge either a list of records as an RTF(D)/a PDF document or merge a list of not indexed groups/tags.
    @objc optional func moveRecord(_ record: DEVONthinkProRecord!, to: DEVONthinkProRecord!, from: DEVONthinkProRecord!) -> DEVONthinkProRecord // Move all instances of a record or one instance from the specified group to a different group.
    @objc optional func openDatabase(_ x: String!) -> DEVONthinkProDatabase // Open an existing DEVONthink Pro database. To close a database, use the standard "close" command.
    @objc optional func openTabForIn(_ in_: DEVONthinkProThinkWindow!, record: DEVONthinkProRecord!, referrer: String!, URL: String!) -> DEVONthinkProTab // Open a new tab for the specified URL or record in a think window.
    @objc optional func openWindowForRecord(_ record: DEVONthinkProRecord!) -> DEVONthinkProThinkWindow // Open a (new) viewer or document window for the specified record (use the 'close' command to close a window). Only recommended for viewer windows, use 'open tab for' for document windows.
    @objc optional func optimizeDatabase(_ database: DEVONthinkProDatabase!) -> Bool // Backup & optimize a DEVONthink Pro database.
    @objc optional func pasteClipboardTo(_ to: DEVONthinkProRecord!) -> DEVONthinkProRecord // Create a new record with the contents of the clipboard.
    @objc optional func refreshRecord(_ record: DEVONthinkProRecord!) -> Bool // Refresh a record. Currently only supported by feeds.
    @objc optional func replicateRecord(_ record: DEVONthinkProRecord!, to: DEVONthinkProRecord!) -> DEVONthinkProRecord // Replicate a record.
    @objc optional func saveWorkspace(_ x: String!) -> Bool // Save a workspace.
    @objc optional func search(_ x: String!, age: Double, comparison: String, in in_: DEVONthinkProRecord!, label: Int, locking: Bool, state: Bool, unread: Bool, within: String) -> [AnyObject] // Search records by string, label, state/flag, locking and/or age.
    @objc optional func showProgressIndicator(_ x: String!, cancelButton: Bool, steps: Int) -> Bool // Show a progress indicator or update an already visible indicator. You have to ensure that the indicator is hidden again via 'hide progress indicator' when the script ends or if an error occurs.
    @objc optional func startDownloads() -> Bool // Start queue of download manager.
    @objc optional func stepProgressIndicator(_ x: String!) -> Bool // Go to next step of a progress.
    @objc optional func stopDownloads() -> Bool // Stop queue of download manager.
    @objc optional func synchronizeRecord(_ record: DEVONthinkProRecord!) -> Bool // Synchronize a record (and its children) by adding new external items, indexing updated external items and removing missing items. Not supported by triggered scripts.
    @objc optional func updateThumbnailOf(_ of: DEVONthinkProRecord!) -> Bool // Update existing image/movie thumbnail (and image info/characteristic) of a record.
    @objc optional func verifyDatabase(_ database: DEVONthinkProDatabase!) -> Int // Verify a DEVONthink Pro database. Returns total number of errors and missing files.
    @objc optional func databases() -> SBElementArray
    @objc optional func documentWindows() -> SBElementArray
    @objc optional func searchWindows() -> SBElementArray
    @objc optional func thinkWindows() -> SBElementArray
    @objc optional func viewerWindows() -> SBElementArray
    @objc optional var cancelledProgress: Bool { get } // Specifies if a process with a visible progress indicator should be cancelled.
    @objc optional var contentRecord: DEVONthinkProRecord { get } // The record of the visible document in the frontmost think window.
    @objc optional var currentDatabase: DEVONthinkProDatabase { get } // The currently used database.
    @objc optional var currentGroup: DEVONthinkProRecord { get } // The (selected) group of the frontmost window of the current database. Returns root of current database if no current group exists.
    @objc optional var inbox: DEVONthinkProDatabase { get } // The global inbox.
    @objc optional var incomingGroup: DEVONthinkProRecord { get } // The default group for new notes. Either global inbox or incoming group of current database.
    @objc optional var lastDownloadedURL: String { get } // The actual URL of the last download.
    @objc optional var selection: [AnyObject] { get } // The selected records of the frontmost viewer or search window or the record of the frontmost document window.
    @objc optional var workspaces: [AnyObject] { get } // The names of all available workspaces.
}
extension SBApplication: DEVONthinkProApplication {}

// MARK: DEVONthinkProColor
@objc public protocol DEVONthinkProColor: DEVONthinkProItem {
}
extension SBObject: DEVONthinkProColor {}

// MARK: DEVONthinkProDocument
@objc public protocol DEVONthinkProDocument: DEVONthinkProItem {
    @objc optional var modified: Bool { get } // Has the document been modified since the last save?
    @objc optional var name: String { get set } // The document's name.
    @objc optional var path: String { get set } // The document's path.
}
extension SBObject: DEVONthinkProDocument {}

// MARK: DEVONthinkProWindow
@objc public protocol DEVONthinkProWindow: DEVONthinkProItem {
    @objc optional var bounds: NSRect { get set } // The bounding rectangle of the window.
    @objc optional var closeable: Bool { get } // Whether the window has a close box.
    @objc optional var document: DEVONthinkProDocument { get } // The document whose contents are being displayed in the window.
    @objc optional var floating: Bool { get } // Whether the window floats.
    @objc optional func id() -> Int // The unique identifier of the window.
    @objc optional var index: Int { get set } // The index of the window, ordered front to back.
    @objc optional var miniaturizable: Bool { get } // Whether the window can be miniaturized.
    @objc optional var miniaturized: Bool { get set } // Whether the window is currently miniaturized.
    @objc optional var modal: Bool { get } // Whether the window is the application's current modal window.
    @objc optional var name: String { get set } // The full title of the window.
    @objc optional var resizable: Bool { get } // Whether the window can be resized.
    @objc optional var titled: Bool { get } // Whether the window has a title bar.
    @objc optional var visible: Bool { get set } // Whether the window is currently visible.
    @objc optional var zoomable: Bool { get } // Whether the window can be zoomed.
    @objc optional var zoomed: Bool { get set } // Whether the window is currently zoomed.
}
extension SBObject: DEVONthinkProWindow {}

// MARK: DEVONthinkProAttributeRun
@objc public protocol DEVONthinkProAttributeRun: DEVONthinkProItem {
    @objc optional func attachments() -> SBElementArray
    @objc optional func attributeRuns() -> SBElementArray
    @objc optional func characters() -> SBElementArray
    @objc optional func paragraphs() -> SBElementArray
    @objc optional func words() -> SBElementArray
    @objc optional var color: NSColor { get set } // The color of the first character.
    @objc optional var font: String { get set } // The name of the font of the first character.
    @objc optional var size: Int { get set } // The size in points of the first character.
    @objc optional var alignment: String { get set } // Alignment of the text.
    @objc optional var background: NSColor { get set } // The background color of the first character.
    @objc optional var baselineOffset: Double { get set } // Number of pixels shifted above or below the normal baseline.
    @objc optional var firstLineHeadIndent: Double { get set } // Paragraph first line head indent of the text (always 0 or positive)
    @objc optional var headIndent: Double { get set } // Paragraph head indent of the text (always 0 or positive).
    @objc optional var lineSpacing: Double { get set } // Line spacing of the text.
    @objc optional var maximumLineHeight: Double { get set } // Maximum line height of the text.
    @objc optional var minimumLineHeight: Double { get set } // Minimum line height of the text.
    @objc optional var paragraphSpacing: Double { get set } // Paragraph spacing of the text.
    @objc optional var superscript: Int { get set } // The superscript level of the text.
    @objc optional var tailIndent: Double { get set } // Paragraph tail indent of the text. If positive, it's the absolute line width. If 0 or negative, it's added to the line width.
    @objc optional var text: String { get set } // The actual text content.
    @objc optional var underlined: Bool { get set } // Is the first character underlined?
    @objc optional var URL: String { get set } // Link of the text.
}
extension SBObject: DEVONthinkProAttributeRun {}

// MARK: DEVONthinkProCharacter
@objc public protocol DEVONthinkProCharacter: DEVONthinkProItem {
    @objc optional func attachments() -> SBElementArray
    @objc optional func attributeRuns() -> SBElementArray
    @objc optional func characters() -> SBElementArray
    @objc optional func paragraphs() -> SBElementArray
    @objc optional func words() -> SBElementArray
    @objc optional var color: NSColor { get set } // The color of the first character.
    @objc optional var font: String { get set } // The name of the font of the first character.
    @objc optional var size: Int { get set } // The size in points of the first character.
    @objc optional var alignment: String { get set } // Alignment of the text.
    @objc optional var background: NSColor { get set } // The background color of the first character.
    @objc optional var baselineOffset: Double { get set } // Number of pixels shifted above or below the normal baseline.
    @objc optional var firstLineHeadIndent: Double { get set } // Paragraph first line head indent of the text (always 0 or positive)
    @objc optional var headIndent: Double { get set } // Paragraph head indent of the text (always 0 or positive).
    @objc optional var lineSpacing: Double { get set } // Line spacing of the text.
    @objc optional var maximumLineHeight: Double { get set } // Maximum line height of the text.
    @objc optional var minimumLineHeight: Double { get set } // Minimum line height of the text.
    @objc optional var paragraphSpacing: Double { get set } // Paragraph spacing of the text.
    @objc optional var superscript: Int { get set } // The superscript level of the text.
    @objc optional var tailIndent: Double { get set } // Paragraph tail indent of the text. If positive, it's the absolute line width. If 0 or negative, it's added to the line width.
    @objc optional var text: String { get set } // The actual text content.
    @objc optional var underlined: Bool { get set } // Is the first character underlined?
    @objc optional var URL: String { get set } // Link of the text.
}
extension SBObject: DEVONthinkProCharacter {}

// MARK: DEVONthinkProParagraph
@objc public protocol DEVONthinkProParagraph: DEVONthinkProItem {
    @objc optional func attachments() -> SBElementArray
    @objc optional func attributeRuns() -> SBElementArray
    @objc optional func characters() -> SBElementArray
    @objc optional func paragraphs() -> SBElementArray
    @objc optional func words() -> SBElementArray
    @objc optional var color: NSColor { get set } // The color of the first character.
    @objc optional var font: String { get set } // The name of the font of the first character.
    @objc optional var size: Int { get set } // The size in points of the first character.
    @objc optional var alignment: String { get set } // Alignment of the text.
    @objc optional var background: NSColor { get set } // The background color of the first character.
    @objc optional var baselineOffset: Double { get set } // Number of pixels shifted above or below the normal baseline.
    @objc optional var firstLineHeadIndent: Double { get set } // Paragraph first line head indent of the text (always 0 or positive)
    @objc optional var headIndent: Double { get set } // Paragraph head indent of the text (always 0 or positive).
    @objc optional var lineSpacing: Double { get set } // Line spacing of the text.
    @objc optional var maximumLineHeight: Double { get set } // Maximum line height of the text.
    @objc optional var minimumLineHeight: Double { get set } // Minimum line height of the text.
    @objc optional var paragraphSpacing: Double { get set } // Paragraph spacing of the text.
    @objc optional var superscript: Int { get set } // The superscript level of the text.
    @objc optional var tailIndent: Double { get set } // Paragraph tail indent of the text. If positive, it's the absolute line width. If 0 or negative, it's added to the line width.
    @objc optional var text: String { get set } // The actual text content.
    @objc optional var underlined: Bool { get set } // Is the first character underlined?
    @objc optional var URL: String { get set } // Link of the text.
}
extension SBObject: DEVONthinkProParagraph {}

// MARK: DEVONthinkProText
@objc public protocol DEVONthinkProText: DEVONthinkProItem {
    @objc optional func attachments() -> SBElementArray
    @objc optional func attributeRuns() -> SBElementArray
    @objc optional func characters() -> SBElementArray
    @objc optional func paragraphs() -> SBElementArray
    @objc optional func words() -> SBElementArray
    @objc optional var color: NSColor { get set } // The color of the first character.
    @objc optional var font: String { get set } // The name of the font of the first character.
    @objc optional var size: Int { get set } // The size in points of the first character.
    @objc optional func addDownloadAutomatic(_ automatic: Bool, password: String!, referrer: String!, user: String!) -> Bool // Add a URL to the download manager.
    @objc optional func convertFeedToHTMLBaseURL(_ baseURL: String!) -> String // Convert a RSS, RDF or Atom feed to HTML.
    @objc optional func createDatabase() -> DEVONthinkProDatabase // Create a new DEVONthink Pro database.
    @objc optional func createFormattedNoteFromAgent(_ agent: String!, in in_: DEVONthinkProRecord!, name: String!, referrer: String!, source: String!) -> DEVONthinkProRecord // Create a new formatted note from a web page.
    @objc optional func createLocationIn(_ in_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Create a hierarchy of groups if necessary.
    @objc optional func createMarkdownFromAgent(_ agent: String!, in in_: DEVONthinkProRecord!, name: String!, referrer: String!) -> DEVONthinkProRecord // Create a Markdown document from a web resource.
    @objc optional func createPDFDocumentFromAgent(_ agent: String!, in in_: DEVONthinkProRecord!, name: String!, pagination: Bool, referrer: String!, width: Int) -> DEVONthinkProRecord // Create a new PDF document with or without pagination from a web resource.
    @objc optional func createWebDocumentFromAgent(_ agent: String!, in in_: DEVONthinkProRecord!, name: String!, referrer: String!) -> DEVONthinkProRecord // Create a new record (picture, PDF or web archive) from a web resource.
    @objc optional func deleteWorkspace() -> Bool // Delete a workspace.
    @objc optional func displayAuthenticationDialog() -> DEVONthinkProRecord // Display a dialog to enter a username and its password.
    @objc optional func displayGroupSelectorButtons(_ buttons: [AnyObject]!, for for_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Display a dialog to select a (destination) group.
    @objc optional func displayNameEditorDefaultAnswer(_ defaultAnswer: String!, info: String!) -> String // Display a dialog to enter a name.
    @objc optional func doJavaScriptIn(_ in_: DEVONthinkProThinkWindow!) -> String // Applies a string of JavaScript code to a think window.
    @objc optional func downloadMarkupFromAgent(_ agent: String!, encoding: String!, password: String!, post: DEVONthinkProRecord!, referrer: String!, user: String!) -> String // Download an HTML or XML page (including RSS, RDF or Atom feeds).
    @objc optional func downloadURLAgent(_ agent: String!, password: String!, post: DEVONthinkProRecord!, referrer: String!, user: String!) -> AnyObject // Download a URL.
    @objc optional func existsRecordAtIn(_ in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record exists at the specified location.
    @objc optional func existsRecordWithCommentIn(_ in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified comment exists.
    @objc optional func existsRecordWithFileIn(_ in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified last path component exists.
    @objc optional func existsRecordWithPathIn(_ in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified path exists.
    @objc optional func existsRecordWithURLIn(_ in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified URL exists.
    @objc optional func getCachedDataForURLFrom(_ from: DEVONthinkProTab!) -> AnyObject // Get cached data for URL of a resource which is part of a loaded webpage and its DOM tree, rendered in a think tab/window.
    @objc optional func getDatabaseWithUuid() -> DEVONthinkProDatabase // Get database with the specified uuid.
    @objc optional func getEmbeddedImagesOfBaseURL(_ baseURL: String!, type: String!) -> [AnyObject] // Get the URLs of all embedded images of an HTML page.
    @objc optional func getEmbeddedObjectsOfBaseURL(_ baseURL: String!, type: String!) -> [AnyObject] // Get the URLs of all embedded objects of an HTML page.
    @objc optional func getEmbeddedSheetsAndScriptsOfBaseURL(_ baseURL: String!, type: String!) -> [AnyObject] // Get the URLs of all embedded style sheets and scripts of an HTML page.
    @objc optional func getFramesOfBaseURL(_ baseURL: String!) -> [AnyObject] // Get the URLs of all frames of an HTML page.
    @objc optional func getItemsOfFeedBaseURL(_ baseURL: String!) -> [AnyObject] // Get the items of a RSS, RDF or Atom feed. Dictionaries contain title (text), link (text), annotationDate (text), calendarDate (annotationDate), description (text), content (text), author (text), html (item converted to HTML), tags (list) and enclosures (list)
    @objc optional func getLinksOfBaseURL(_ baseURL: String!, containing: String!, type: String!) -> [AnyObject] // Get the URLs of all links of an HTML page.
    @objc optional func getRecordAtIn(_ in_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Search for record at the specified location.
    @objc optional func getRecordWithUuidIn(_ in_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Get record with the specified uuid.
    @objc optional func getRichTextOfBaseURL(_ baseURL: String!) -> DEVONthinkProText // Get the rich text of an HTML page.
    @objc optional func getTextOf() -> String // Get the text of an HTML page.
    @objc optional func getTitleOf() -> String // Get the title of an HTML page.
    @objc optional func importFrom(_ from: String!, name: String!, placeholders: DEVONthinkProRecord!, to: DEVONthinkProRecord!, type: String) -> DEVONthinkProRecord // Import a file or folder (including its subfolders).
    @objc optional func importTemplateTo(_ to: DEVONthinkProRecord!) -> DEVONthinkProRecord // Import a template. Note: Template scripts are not supported.
    @objc optional func indicateTo(_ to: DEVONthinkProRecord!, type: String) -> DEVONthinkProRecord // Indicate ('index') a file or folder (including its subfolders). If no type is specified or the type is 'all', then links to unknown file types are created too.
    @objc optional func loadWorkspace() -> Bool // Load a workspace.
    @objc optional func logMessageInfo(_ info: String!) -> Bool // Log info for a file or action to the Log panel of DEVONthink Pro.
    @objc optional func lookupRecordsWithCommentIn(_ in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records with specified comment.
    @objc optional func lookupRecordsWithFileIn(_ in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records whose last path component is the specified file.
    @objc optional func lookupRecordsWithPathIn(_ in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records with specified path.
    @objc optional func lookupRecordsWithURLIn(_ in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records with specified URL.
    @objc optional func openDatabase() -> DEVONthinkProDatabase // Open an existing DEVONthink Pro database. To close a database, use the standard "close" command.
    @objc optional func saveWorkspace() -> Bool // Save a workspace.
    @objc optional func searchAge(_ age: Double, comparison: String, in in_: DEVONthinkProRecord!, label: Int, locking: Bool, state: Bool, unread: Bool, within: String) -> [AnyObject] // Search records by string, label, state/flag, locking and/or age.
    @objc optional func showProgressIndicatorCancelButton(_ cancelButton: Bool, steps: Int) -> Bool // Show a progress indicator or update an already visible indicator. You have to ensure that the indicator is hidden again via 'hide progress indicator' when the script ends or if an error occurs.
    @objc optional func stepProgressIndicator() -> Bool // Go to next step of a progress.
    @objc optional var alignment: String { get set } // Alignment of the text.
    @objc optional var background: NSColor { get set } // The background color of the first character.
    @objc optional var baselineOffset: Double { get set } // Number of pixels shifted above or below the normal baseline.
    @objc optional var firstLineHeadIndent: Double { get set } // Paragraph first line head indent of the text (always 0 or positive)
    @objc optional var headIndent: Double { get set } // Paragraph head indent of the text (always 0 or positive).
    @objc optional var lineSpacing: Double { get set } // Line spacing of the text.
    @objc optional var maximumLineHeight: Double { get set } // Maximum line height of the text.
    @objc optional var minimumLineHeight: Double { get set } // Minimum line height of the text.
    @objc optional var paragraphSpacing: Double { get set } // Paragraph spacing of the text.
    @objc optional var superscript: Int { get set } // The superscript level of the text.
    @objc optional var tailIndent: Double { get set } // Paragraph tail indent of the text. If positive, it's the absolute line width. If 0 or negative, it's added to the line width.
    @objc optional var text: String { get set } // The actual text content.
    @objc optional var underlined: Bool { get set } // Is the first character underlined?
    @objc optional var URL: String { get set } // Link of the text.
}
extension SBObject: DEVONthinkProText {}

// MARK: DEVONthinkProAttachment
@objc public protocol DEVONthinkProAttachment: DEVONthinkProText {
    @objc optional var fileName: String { get set } // The path to the file for the attachment
}
extension SBObject: DEVONthinkProAttachment {}

// MARK: DEVONthinkProWord
@objc public protocol DEVONthinkProWord: DEVONthinkProItem {
    @objc optional func attachments() -> SBElementArray
    @objc optional func attributeRuns() -> SBElementArray
    @objc optional func characters() -> SBElementArray
    @objc optional func paragraphs() -> SBElementArray
    @objc optional func words() -> SBElementArray
    @objc optional var color: NSColor { get set } // The color of the first character.
    @objc optional var font: String { get set } // The name of the font of the first character.
    @objc optional var size: Int { get set } // The size in points of the first character.
    @objc optional var alignment: String { get set } // Alignment of the text.
    @objc optional var background: NSColor { get set } // The background color of the first character.
    @objc optional var baselineOffset: Double { get set } // Number of pixels shifted above or below the normal baseline.
    @objc optional var firstLineHeadIndent: Double { get set } // Paragraph first line head indent of the text (always 0 or positive)
    @objc optional var headIndent: Double { get set } // Paragraph head indent of the text (always 0 or positive).
    @objc optional var lineSpacing: Double { get set } // Line spacing of the text.
    @objc optional var maximumLineHeight: Double { get set } // Maximum line height of the text.
    @objc optional var minimumLineHeight: Double { get set } // Minimum line height of the text.
    @objc optional var paragraphSpacing: Double { get set } // Paragraph spacing of the text.
    @objc optional var superscript: Int { get set } // The superscript level of the text.
    @objc optional var tailIndent: Double { get set } // Paragraph tail indent of the text. If positive, it's the absolute line width. If 0 or negative, it's added to the line width.
    @objc optional var text: String { get set } // The actual text content.
    @objc optional var underlined: Bool { get set } // Is the first character underlined?
    @objc optional var URL: String { get set } // Link of the text.
}
extension SBObject: DEVONthinkProWord {}

// MARK: DEVONthinkProDatabase
@objc public protocol DEVONthinkProDatabase: DEVONthinkProItem {
    @objc optional func contents() -> SBElementArray
    @objc optional func parents() -> SBElementArray
    @objc optional func records() -> SBElementArray
    @objc optional func tagGroups() -> SBElementArray
    @objc optional var comment: String { get set } // The comment of the database.
    @objc optional var currentGroup: DEVONthinkProRecord { get } // The (selected) group of the frontmost window. Returns root if no current group exists.
    @objc optional func id() -> Int // The scripting identifier of a database.
    @objc optional var incomingGroup: DEVONthinkProRecord { get } // The default group for new notes. Might be identical to root.
    @objc optional var name: String { get set } // The name of the database.
    @objc optional var path: String { get } // The POSIX path of the database.
    @objc optional var readOnly: Bool { get } // Specifies if a database is read-only and can't be modified.
    @objc optional var root: DEVONthinkProRecord { get } // The top level group of the database.
    @objc optional var syncGroup: DEVONthinkProRecord { get } // The group for synchronizing.
    @objc optional var tagsGroup: DEVONthinkProRecord { get } // The group for tags.
    @objc optional var trashGroup: DEVONthinkProRecord { get } // The trash's group.
    @objc optional var uuid: String { get } // The unique and persistent identifier of a database for external referencing.
}
extension SBObject: DEVONthinkProDatabase {}

// MARK: DEVONthinkProRecord
@objc public protocol DEVONthinkProRecord: DEVONthinkProItem {
    @objc optional func children() -> SBElementArray
    @objc optional func parents() -> SBElementArray
    @objc optional var additionDate: Date { get } // Date when the record was added to the database.
    @objc optional var aliases: String { get set } // Wiki aliases (separated by commas or semicolons) of a record.
    @objc optional var attachedScript: String { get set } // POSIX path of script attached to a record.
    @objc optional var cells: [AnyObject] { get set } // The cells of a sheet.
    @objc optional var characterCount: Int { get } // The character count of a record.
    @objc optional var columns: [AnyObject] { get } // The column names of a sheet.
    @objc optional var comment: String { get set } // The comment of a record.
    @objc optional var creationDate: Date { get set } // The creation annotationDate of a record.
    @objc optional var data: AnyObject { get set } // The file data of a record. Currently only supported by PDF documents, images, rich texts and web archives.
    @objc optional var database: DEVONthinkProDatabase { get } // The database of the record.
    @objc optional var date: Date { get set } // The (creation/modification) annotationDate of a record.
    @objc optional var dimensions: [AnyObject] { get } // The width and height of an image or PDF document in pixels.
    @objc optional var dpi: Int { get } // The resultion of an image in dpi.
    @objc optional var duplicates: [AnyObject] { get } // The duplicates of a record (only other instances, not including the record).
    @objc optional var excludeFromClassification: Bool { get set } // Exclude group or record from classifying.
    @objc optional var excludeFromSearch: Bool { get set } // Exclude group or record from searching.
    @objc optional var excludeFromSeeAlso: Bool { get set } // Exclude record from see also.
    @objc optional var excludeFromTagging: Bool { get set } // Exclude group from tagging.
    @objc optional var filename: String { get } // The proposed file name for a record.
    @objc optional var height: Int { get } // The height of an image or PDF document in pixels.
    @objc optional func id() -> Int // The scripting identifier of a record. Optimizing or closing a database might modify this identifier.
    @objc optional var image: AnyObject { get set } // The image or PDF document of a record.
    @objc optional var indexed: Bool { get } // Indexed or imported record.
    @objc optional var interval: Double { get set } // Refresh interval of a feed. Currently overriden by preferences.
    @objc optional var kind: String { get } // The human readable kind of a record. WARNING: Don't use this to check the type of a record, otherwise your script might fail depending on the version and the localization.
    @objc optional var label: Int { get set } // Index of label (0-7) of a record.
    @objc optional var location: String { get } // The location in the database as a POSIX path (/ in names is replaced with \/).
    @objc optional var locking: Bool { get set } // The locking of a record.
    @objc optional var metaData: DEVONthinkProRecord { get } // The metadata of a record as a dictionary containing key-value pairs. Possible keys are currently kMDItemTitle, kMDItemHeadline, kMDItemSubject, kMDItemDescription, kMDItemCopyright, kMDItemComment, kMDItemURL, kMDItemKeywords, kMDItemCreator, kMDItemProdu
    @objc optional var MIMEType: String { get } // The (proposed) MIME type of a record.
    @objc optional var modificationDate: Date { get set } // The modification annotationDate of a record.
    @objc optional var name: String { get set } // The name of a record.
    @objc optional var numberOfDuplicates: Int { get } // The number of duplicates of a record.
    @objc optional var numberOfReplicants: Int { get } // The number of replicants of a record.
    @objc optional var openingDate: Date { get } // Date when a content was opened the last time or when a feed was refreshed the last time.
    @objc optional var pageCount: Int { get } // The page count of a record. Currently only supported by PDF documents.
    @objc optional var path: String { get } // The POSIX file path of a record.
    @objc optional var plainText: String { get set } // The plain text of a record.
    @objc optional var referenceURL: String { get }
    @objc optional var richText: DEVONthinkProText { get set } // The rich text of a record (see text suite).
    @objc optional var score: Double { get } // The score of the last comparison, classification or search (value between 0.0 and 1.0) or undefined otherwise.
    @objc optional var size: Int { get } // The size of a record in bytes.
    @objc optional var source: String { get set } // The HTML/XML source of a record if available or the record converted to HTML if possible.
    @objc optional var state: Bool { get set } // The state/flag of a record.
    @objc optional var stateVisibility: Bool { get set } // Obsolete.
    @objc optional var tagType: String { get } // The tag type of a record.
    @objc optional var tags: [AnyObject] { get set } // The tags of a record.
    @objc optional var thumbnail: AnyObject { get set } // The thumbnail of a record.
    @objc optional var type: String { get } // The type of a record.
    @objc optional var unread: Bool { get set } // The unread flag of a record.
    @objc optional var URL: String { get set } // The URL of a record.
    @objc optional var uuid: String { get } // The unique and persistent identifier of a record.
    @objc optional var width: Int { get } // The width of an image or PDF document in pixels.
    @objc optional var wordCount: Int { get } // The word count of a record.
    @objc optional func createRecordWithIn(_ in_: DEVONthinkProRecord!) -> DEVONthinkProRecord // Create a new record.
}
extension SBObject: DEVONthinkProRecord {}

// MARK: DEVONthinkProChild
@objc public protocol DEVONthinkProChild: DEVONthinkProRecord {
}
extension SBObject: DEVONthinkProChild {}

// MARK: DEVONthinkProContent
@objc public protocol DEVONthinkProContent: DEVONthinkProRecord {
}
extension SBObject: DEVONthinkProContent {}

// MARK: DEVONthinkProParent
@objc public protocol DEVONthinkProParent: DEVONthinkProRecord {
}
extension SBObject: DEVONthinkProParent {}

// MARK: DEVONthinkProSelectedText
@objc public protocol DEVONthinkProSelectedText: DEVONthinkProText {
}
extension SBObject: DEVONthinkProSelectedText {}

// MARK: DEVONthinkProTab
@objc public protocol DEVONthinkProTab: DEVONthinkProItem {
    @objc optional var contentRecord: DEVONthinkProRecord { get } // The record of the visible document.
    @objc optional var currentPage: Int { get } // Zero-based index of current PDF page.
    @objc optional var database: DEVONthinkProDatabase { get } // The database of the tab.
    @objc optional func id() -> Int // The unique identifier of the tab.
    @objc optional var loading: Bool { get } // Specifies if the current web page is still loading.
    @objc optional var numberOfColumns: Int { get } // Number of columns of the current sheet.
    @objc optional var numberOfRows: Int { get } // Number of rows of the current sheet.
    @objc optional var paginatedPDF: AnyObject { get } // A printed PDF with pagination of the visible document.
    @objc optional var PDF: AnyObject { get } // A PDF without pagination of the visible document retaining the screen layout.
    @objc optional var selectedColumn: Int { get set } // Index (1-n) of selected column of the current sheet.
    @objc optional var selectedColumns: [AnyObject] { get } // Indices (1-n) of selected columns of the current sheet.
    @objc optional var selectedRow: Int { get set } // Index (1-n) of selected row of the current sheet.
    @objc optional var selectedRows: [AnyObject] { get } // Indices (1-n) of selected rows of the current sheet.
    @objc optional var selectedText: DEVONthinkProSelectedText { get set } // The text container for the selection of the tab.
    @objc optional var source: String { get } // The HTML source of the current web page.
    @objc optional var text: DEVONthinkProText { get set } // The text container of the tab.
    @objc optional var thinkWindow: DEVONthinkProThinkWindow { get } // The think window of the tab.
    @objc optional var URL: String { get set } // The URL of the current web page.
    @objc optional var webArchive: AnyObject { get } // Web archive of the current web page.
}
extension SBObject: DEVONthinkProTab {}

// MARK: DEVONthinkProTagGroup
@objc public protocol DEVONthinkProTagGroup: DEVONthinkProRecord {
}
extension SBObject: DEVONthinkProTagGroup {}

// MARK: DEVONthinkProThinkWindow
@objc public protocol DEVONthinkProThinkWindow: DEVONthinkProWindow {
    @objc optional func tabs() -> SBElementArray
    @objc optional var contentRecord: DEVONthinkProRecord { get } // The record of the visible document.
    @objc optional var currentPage: Int { get } // Zero-based index of current PDF page.
    @objc optional var currentTab: DEVONthinkProTab { get set } // The selected tab of the think window.
    @objc optional var database: DEVONthinkProDatabase { get } // The database of the window.
    @objc optional var loading: Bool { get } // Specifies if the current web page is still loading.
    @objc optional var numberOfColumns: Int { get } // Number of columns of the current sheet.
    @objc optional var numberOfRows: Int { get } // Number of rows of the current sheet.
    @objc optional var paginatedPDF: AnyObject { get } // A printed PDF with pagination of the visible document.
    @objc optional var PDF: AnyObject { get } // A PDF without pagination of the visible document retaining the screen layout.
    @objc optional var selectedColumn: Int { get set } // Index (1-n) of selected column of the current sheet.
    @objc optional var selectedColumns: [AnyObject] { get } // Indices (1-n) of selected columns of the current sheet.
    @objc optional var selectedRow: Int { get set } // Index (1-n) of selected row of the current sheet.
    @objc optional var selectedRows: [AnyObject] { get } // Indices (1-n) of selected rows of the current sheet.
    @objc optional var selectedText: DEVONthinkProSelectedText { get set } // The text container for the selection of the window.
    @objc optional var source: String { get } // The HTML source of the current web page.
    @objc optional var text: DEVONthinkProText { get set } // The text container of the window.
    @objc optional var URL: String { get set } // The URL of the current web page.
    @objc optional var webArchive: AnyObject { get } // Web archive of the current web page.
}
extension SBObject: DEVONthinkProThinkWindow {}

// MARK: DEVONthinkProDocumentWindow
@objc public protocol DEVONthinkProDocumentWindow: DEVONthinkProThinkWindow {
    @objc optional var record: DEVONthinkProRecord { get set } // The record of the document.
}
extension SBObject: DEVONthinkProDocumentWindow {}

// MARK: DEVONthinkProSearchWindow
@objc public protocol DEVONthinkProSearchWindow: DEVONthinkProThinkWindow {
    @objc optional var results: [AnyObject] { get set } // The search results.
    @objc optional var selection: [AnyObject] { get } // The selected results.
}
extension SBObject: DEVONthinkProSearchWindow {}

// MARK: DEVONthinkProViewerWindow
@objc public protocol DEVONthinkProViewerWindow: DEVONthinkProThinkWindow {
    @objc optional var root: DEVONthinkProRecord { get set } // The top level group of the viewer.
    @objc optional var selection: [AnyObject] { get set } // The selected records.
}
extension SBObject: DEVONthinkProViewerWindow {}

// MARK: DEVONthinkProPrintSettings
@objc public protocol DEVONthinkProPrintSettings: SBObjectProtocol {
    @objc optional var copies: Int { get set } // the number of copies of a document to be printed
    @objc optional var collating: Bool { get set } // Should printed copies be collated?
    @objc optional var startingPage: Int { get set } // the first page of the document to be printed
    @objc optional var endingPage: Int { get set } // the last page of the document to be printed
    @objc optional var pagesAcross: Int { get set } // number of logical pages laid across a physical page
    @objc optional var pagesDown: Int { get set } // number of logical pages laid out down a physical page
    @objc optional var requestedPrintTime: Date { get set } // the time at which the desktop printer should print the document
    @objc optional var errorHandling: String { get set } // how errors are handled
    @objc optional var faxNumber: String { get set } // for fax number
    @objc optional var targetPrinter: String { get set } // for target printer
    @objc optional func closeSaving(_ saving: String, savingIn: AnyObject!) // Close an object.
    @objc optional func delete() // Delete an object.
    @objc optional func duplicateTo(_ to: SBObject!, withProperties: DEVONthinkProRecord!) // Copy object(s) and put the copies at a new location.
    @objc optional func exists() -> Bool // Verify if an object exists.
    @objc optional func moveTo(_ to: SBObject!) // Move object(s) to a new location.
    @objc optional func saveAs(_ as: String!, in in_: AnyObject!) // Save an object.
    @objc optional func bold() // Bold some text
    @objc optional func italicize() // Italicize some text
    @objc optional func plain() // Make some text plain
    @objc optional func reformat() // Reformat some text. Similar to WordService's Reformat service.
    @objc optional func scrollToVisible() // Scroll to and animate some text. Requires Mac OS X 10.6.
    @objc optional func strike() // Strike some text
    @objc optional func unbold() // Unbold some text
    @objc optional func underline() // Underline some text
    @objc optional func unitalicize() // Unitalicize some text
    @objc optional func unstrike() // Unstrike some text
    @objc optional func ununderline() // Ununderline some text
    @objc optional func addRowCells(_ cells: [AnyObject]!) -> Bool // Add new row to current sheet.
    @objc optional func deleteRowAtPosition(_ position: Int) -> Bool // Remove row at specified position from current sheet.
    @objc optional func getCellAtColumn(_ column: Int, row: Int) -> String // Get content of cell at specified position of current sheet.
    @objc optional func setCellAtColumn(_ column: Int, row: Int, to: String!) -> Bool // Set cell at specified position of current sheet.
    @objc optional func convertImageRecord(_ record: DEVONthinkProRecord!, rotateBy: Int, to: DEVONthinkProRecord!, waitingForReply: Bool) -> DEVONthinkProRecord // Returns a searchable PDF for an image record.
    @objc optional func ocrFile(_ file: String!, attributes: DEVONthinkProRecord!, rotateBy: Int, to: DEVONthinkProRecord!, waitingForReply: Bool) -> DEVONthinkProRecord // Returns a record with a searchable PDF.
}
extension SBObject: DEVONthinkProPrintSettings {}

