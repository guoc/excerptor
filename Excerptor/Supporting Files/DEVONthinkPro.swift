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
    optional var properties: DEVONthinkProRecord { get set } // All of the object's properties.
    optional func closeSaving(saving: String, savingIn: AnyObject!) // Close an object.
    optional func delete() // Delete an object.
    optional func duplicateTo(to: SBObject!, withProperties: DEVONthinkProRecord!) // Copy object(s) and put the copies at a new location.
    optional func exists() -> Bool // Verify if an object exists.
    optional func moveTo(to: SBObject!) // Move object(s) to a new location.
    optional func saveAs(`as`: String!, `in` in_: AnyObject!) // Save an object.
    optional func bold() // Bold some text
    optional func italicize() // Italicize some text
    optional func plain() // Make some text plain
    optional func reformat() // Reformat some text. Similar to WordService's Reformat service.
    optional func scrollToVisible() // Scroll to and animate some text. Requires Mac OS X 10.6.
    optional func strike() // Strike some text
    optional func unbold() // Unbold some text
    optional func underline() // Underline some text
    optional func unitalicize() // Unitalicize some text
    optional func unstrike() // Unstrike some text
    optional func ununderline() // Ununderline some text
    optional func addRowCells(cells: [AnyObject]!) -> Bool // Add new row to current sheet.
    optional func deleteRowAtPosition(position: Int) -> Bool // Remove row at specified position from current sheet.
    optional func getCellAtColumn(column: Int, row: Int) -> String // Get content of cell at specified position of current sheet.
    optional func setCellAtColumn(column: Int, row: Int, to: String!) -> Bool // Set cell at specified position of current sheet.
    optional func convertImageRecord(record: DEVONthinkProRecord!, rotateBy: Int, to: DEVONthinkProRecord!, waitingForReply: Bool) -> DEVONthinkProRecord // Returns a searchable PDF for an image record.
    optional func ocrFile(file: String!, attributes: DEVONthinkProRecord!, rotateBy: Int, to: DEVONthinkProRecord!, waitingForReply: Bool) -> DEVONthinkProRecord // Returns a record with a searchable PDF.
}
extension SBObject: DEVONthinkProItem {}

// MARK: DEVONthinkProApplication
@objc public protocol DEVONthinkProApplication: SBApplicationProtocol {
    optional func documents() -> SBElementArray
    optional func windows() -> SBElementArray
    optional var frontmost: Bool { get } // Is this the frontmost (active) application?
    optional var name: String { get } // The name of the application.
    optional var version: String { get } // The version of the application.
    optional func open(x: AnyObject!) -> DEVONthinkProDocument // Open an object.
    optional func print(x: AnyObject!, printDialog: Bool, withProperties: DEVONthinkProPrintSettings!) // Print an object.
    optional func quitSaving(saving: String) // Quit an application.
    optional func addDownload(x: String!, automatic: Bool, password: String!, referrer: String!, user: String!) -> Bool // Add a URL to the download manager.
    optional func backupDatabase(database: DEVONthinkProDatabase!, to: String!, includingFiles: Bool) -> Bool // Backup a DEVONthink Pro database.
    optional func classifyRecord(record: DEVONthinkProRecord!) -> [AnyObject] // Get a list of classification proposals.
    optional func compareContent(content: String!, record: DEVONthinkProRecord!, to: DEVONthinkProDatabase!) -> [AnyObject] // Get a list of similar records, either by specifying a record or a content (and database).
    optional func compressDatabase(database: DEVONthinkProDatabase!, to: String!) -> Bool // Compress a DEVONthink Pro database into a Zip archive.
    optional func consolidateRecord(record: DEVONthinkProRecord!) -> Bool // Move an external/indexed record (and its children) into the database.
    optional func convertRecord(record: DEVONthinkProRecord!, `in` in_: DEVONthinkProRecord!, to: DEVONthinkProDatabase) -> DEVONthinkProRecord // Convert a record to simple or rich text and create a new record afterwards.
    optional func convertFeedToHTML(x: String!, baseURL: String!) -> String // Convert a RSS, RDF or Atom feed to HTML.
    optional func createDatabase(x: String!) -> DEVONthinkProDatabase // Create a new DEVONthink Pro database.
    optional func createFormattedNoteFrom(x: String!, agent: String!, `in` in_: DEVONthinkProRecord!, name: String!, referrer: String!, source: String!) -> DEVONthinkProRecord // Create a new formatted note from a web page.
    optional func createLocation(x: String!, `in` in_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Create a hierarchy of groups if necessary.
    optional func createMarkdownFrom(x: String!, agent: String!, `in` in_: DEVONthinkProRecord!, name: String!, referrer: String!) -> DEVONthinkProRecord // Create a Markdown document from a web resource.
    optional func createPDFDocumentFrom(x: String!, agent: String!, `in` in_: DEVONthinkProRecord!, name: String!, pagination: Bool, referrer: String!, width: Int) -> DEVONthinkProRecord // Create a new PDF document with or without pagination from a web resource.
    optional func createThumbnailFor(for_: DEVONthinkProRecord!) -> Bool // Create image/movie thumbnail (and image info/characteristic) for a record.
    optional func createWebDocumentFrom(x: String!, agent: String!, `in` in_: DEVONthinkProRecord!, name: String!, referrer: String!) -> DEVONthinkProRecord // Create a new record (picture, PDF or web archive) from a web resource.
    optional func deconsolidateRecord(record: DEVONthinkProRecord!) -> Bool // Move an internal/imported record (and its children) to the enclosing external folder in the filesystem. Creation/Modification dates, Spotlight comments and OpenMeta tags are immediately updated.
    optional func deleteRecord(record: DEVONthinkProRecord!, `in` in_: DEVONthinkProRecord!) -> Bool // Delete all instances of a record from the database or one instance from the specified group.
    optional func deleteThumbnailOf(of: DEVONthinkProRecord!) -> Bool // Delete existing image/movie/web thumbnail of a record.
    optional func deleteWorkspace(x: String!) -> Bool // Delete a workspace.
    optional func displayAuthenticationDialog(x: String!) -> DEVONthinkProRecord // Display a dialog to enter a username and its password.
    optional func displayGroupSelector(x: String!, buttons: [AnyObject]!, `for` for_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Display a dialog to select a (destination) group.
    optional func displayNameEditor(x: String!, defaultAnswer: String!, info: String!) -> String // Display a dialog to enter a name.
    optional func doJavaScript(x: String!, `in` in_: DEVONthinkProThinkWindow!) -> String // Applies a string of JavaScript code to a think window.
    optional func downloadMarkupFrom(x: String!, agent: String!, encoding: String!, password: String!, post: DEVONthinkProRecord!, referrer: String!, user: String!) -> String // Download an HTML or XML page (including RSS, RDF or Atom feeds).
    optional func downloadURL(x: String!, agent: String!, password: String!, post: DEVONthinkProRecord!, referrer: String!, user: String!) -> AnyObject // Download a URL.
    optional func duplicateRecord(record: DEVONthinkProRecord!, to: DEVONthinkProRecord!) -> DEVONthinkProRecord // Duplicate a record.
    optional func existsRecordAt(x: String!, `in` in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record exists at the specified location.
    optional func existsRecordWithComment(x: String!, `in` in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified comment exists.
    optional func existsRecordWithFile(x: String!, `in` in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified last path component exists.
    optional func existsRecordWithPath(x: String!, `in` in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified path exists.
    optional func existsRecordWithURL(x: String!, `in` in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified URL exists.
    optional func exportRecord(record: DEVONthinkProRecord!, to: String!) -> String // Export a record (and its children).
    optional func exportTagsOfRecord(record: DEVONthinkProRecord!) -> Bool // Export OpenMeta/Mavericks tags of a record.
    optional func exportWebsiteRecord(record: DEVONthinkProRecord!, to: String!, encoding: String!, entities: Bool, indexPages: Bool, template template_: String!) -> String // Export a record (and its children) as a website.
    optional func getCachedDataForURL(x: String!, from: DEVONthinkProTab!) -> AnyObject // Get cached data for URL of a resource which is part of a loaded webpage and its DOM tree, rendered in a think tab/window.
    optional func getConcordanceOfRecord(record: DEVONthinkProRecord!, sortedBy: String) -> [AnyObject] // Get list of words of a record.
    optional func getDatabaseWithId(x: Int) -> DEVONthinkProDatabase // Get database with the specified id.
    optional func getDatabaseWithUuid(x: String!) -> DEVONthinkProDatabase // Get database with the specified uuid.
    optional func getEmbeddedImagesOf(x: String!, baseURL: String!, type: String!) -> [AnyObject] // Get the URLs of all embedded images of an HTML page.
    optional func getEmbeddedObjectsOf(x: String!, baseURL: String!, type: String!) -> [AnyObject] // Get the URLs of all embedded objects of an HTML page.
    optional func getEmbeddedSheetsAndScriptsOf(x: String!, baseURL: String!, type: String!) -> [AnyObject] // Get the URLs of all embedded style sheets and scripts of an HTML page.
    optional func getFramesOf(x: String!, baseURL: String!) -> [AnyObject] // Get the URLs of all frames of an HTML page.
    optional func getItemsOfFeed(x: String!, baseURL: String!) -> [AnyObject] // Get the items of a RSS, RDF or Atom feed. Dictionaries contain title (text), link (text), annotationDate (text), calendarDate (annotationDate), description (text), content (text), author (text), html (item converted to HTML), tags (list) and enclosures (list)
    optional func getLinksOf(x: String!, baseURL: String!, containing: String!, type: String!) -> [AnyObject] // Get the URLs of all links of an HTML page.
    optional func getRecordAt(x: String!, `in` in_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Search for record at the specified location.
    optional func getRecordWithId(x: Int, `in` in_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Get record with the specified id.
    optional func getRecordWithUuid(x: String!, `in` in_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Get record with the specified uuid.
    optional func getRichTextOf(x: String!, baseURL: String!) -> DEVONthinkProText // Get the rich text of an HTML page.
    optional func getTextOf(x: String!) -> String // Get the text of an HTML page.
    optional func getTitleOf(x: String!) -> String // Get the title of an HTML page.
    optional func hideProgressIndicator() -> Bool // Hide a visible progress indicator.
    optional func `import`(x: String!, from: String!, name: String!, placeholders: DEVONthinkProRecord!, to: DEVONthinkProRecord!, type: String) -> DEVONthinkProRecord // Import a file or folder (including its subfolders).
    optional func importTemplate(x: String!, to: DEVONthinkProRecord!) -> DEVONthinkProRecord // Import a template. Note: Template scripts are not supported.
    optional func indicate(x: String!, to: DEVONthinkProRecord!, type: String) -> DEVONthinkProRecord // Indicate ('index') a file or folder (including its subfolders). If no type is specified or the type is 'all', then links to unknown file types are created too.
    optional func loadWorkspace(x: String!) -> Bool // Load a workspace.
    optional func logMessage(x: String!, info: String!) -> Bool // Log info for a file or action to the Log panel of DEVONthink Pro.
    optional func lookupRecordsWithComment(x: String!, `in` in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records with specified comment.
    optional func lookupRecordsWithFile(x: String!, `in` in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records whose last path component is the specified file.
    optional func lookupRecordsWithPath(x: String!, `in` in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records with specified path.
    optional func lookupRecordsWithTags(x: [AnyObject]!, any: Bool, `in` in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records with all or any of the specified tags.
    optional func lookupRecordsWithURL(x: String!, `in` in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records with specified URL.
    optional func mergeRecords(records: [AnyObject]!, `in` in_: DEVONthinkProRecord!) -> DEVONthinkProRecord // Merge either a list of records as an RTF(D)/a PDF document or merge a list of not indexed groups/tags.
    optional func moveRecord(record: DEVONthinkProRecord!, to: DEVONthinkProRecord!, from: DEVONthinkProRecord!) -> DEVONthinkProRecord // Move all instances of a record or one instance from the specified group to a different group.
    optional func openDatabase(x: String!) -> DEVONthinkProDatabase // Open an existing DEVONthink Pro database. To close a database, use the standard "close" command.
    optional func openTabForIn(in_: DEVONthinkProThinkWindow!, record: DEVONthinkProRecord!, referrer: String!, URL: String!) -> DEVONthinkProTab // Open a new tab for the specified URL or record in a think window.
    optional func openWindowForRecord(record: DEVONthinkProRecord!) -> DEVONthinkProThinkWindow // Open a (new) viewer or document window for the specified record (use the 'close' command to close a window). Only recommended for viewer windows, use 'open tab for' for document windows.
    optional func optimizeDatabase(database: DEVONthinkProDatabase!) -> Bool // Backup & optimize a DEVONthink Pro database.
    optional func pasteClipboardTo(to: DEVONthinkProRecord!) -> DEVONthinkProRecord // Create a new record with the contents of the clipboard.
    optional func refreshRecord(record: DEVONthinkProRecord!) -> Bool // Refresh a record. Currently only supported by feeds.
    optional func replicateRecord(record: DEVONthinkProRecord!, to: DEVONthinkProRecord!) -> DEVONthinkProRecord // Replicate a record.
    optional func saveWorkspace(x: String!) -> Bool // Save a workspace.
    optional func search(x: String!, age: Double, comparison: String, `in` in_: DEVONthinkProRecord!, label: Int, locking: Bool, state: Bool, unread: Bool, within: String) -> [AnyObject] // Search records by string, label, state/flag, locking and/or age.
    optional func showProgressIndicator(x: String!, cancelButton: Bool, steps: Int) -> Bool // Show a progress indicator or update an already visible indicator. You have to ensure that the indicator is hidden again via 'hide progress indicator' when the script ends or if an error occurs.
    optional func startDownloads() -> Bool // Start queue of download manager.
    optional func stepProgressIndicator(x: String!) -> Bool // Go to next step of a progress.
    optional func stopDownloads() -> Bool // Stop queue of download manager.
    optional func synchronizeRecord(record: DEVONthinkProRecord!) -> Bool // Synchronize a record (and its children) by adding new external items, indexing updated external items and removing missing items. Not supported by triggered scripts.
    optional func updateThumbnailOf(of: DEVONthinkProRecord!) -> Bool // Update existing image/movie thumbnail (and image info/characteristic) of a record.
    optional func verifyDatabase(database: DEVONthinkProDatabase!) -> Int // Verify a DEVONthink Pro database. Returns total number of errors and missing files.
    optional func databases() -> SBElementArray
    optional func documentWindows() -> SBElementArray
    optional func searchWindows() -> SBElementArray
    optional func thinkWindows() -> SBElementArray
    optional func viewerWindows() -> SBElementArray
    optional var cancelledProgress: Bool { get } // Specifies if a process with a visible progress indicator should be cancelled.
    optional var contentRecord: DEVONthinkProRecord { get } // The record of the visible document in the frontmost think window.
    optional var currentDatabase: DEVONthinkProDatabase { get } // The currently used database.
    optional var currentGroup: DEVONthinkProRecord { get } // The (selected) group of the frontmost window of the current database. Returns root of current database if no current group exists.
    optional var inbox: DEVONthinkProDatabase { get } // The global inbox.
    optional var incomingGroup: DEVONthinkProRecord { get } // The default group for new notes. Either global inbox or incoming group of current database.
    optional var lastDownloadedURL: String { get } // The actual URL of the last download.
    optional var selection: [AnyObject] { get } // The selected records of the frontmost viewer or search window or the record of the frontmost document window.
    optional var workspaces: [AnyObject] { get } // The names of all available workspaces.
}
extension SBApplication: DEVONthinkProApplication {}

// MARK: DEVONthinkProColor
@objc public protocol DEVONthinkProColor: DEVONthinkProItem {
}
extension SBObject: DEVONthinkProColor {}

// MARK: DEVONthinkProDocument
@objc public protocol DEVONthinkProDocument: DEVONthinkProItem {
    optional var modified: Bool { get } // Has the document been modified since the last save?
    optional var name: String { get set } // The document's name.
    optional var path: String { get set } // The document's path.
}
extension SBObject: DEVONthinkProDocument {}

// MARK: DEVONthinkProWindow
@objc public protocol DEVONthinkProWindow: DEVONthinkProItem {
    optional var bounds: NSRect { get set } // The bounding rectangle of the window.
    optional var closeable: Bool { get } // Whether the window has a close box.
    optional var document: DEVONthinkProDocument { get } // The document whose contents are being displayed in the window.
    optional var floating: Bool { get } // Whether the window floats.
    optional func id() -> Int // The unique identifier of the window.
    optional var index: Int { get set } // The index of the window, ordered front to back.
    optional var miniaturizable: Bool { get } // Whether the window can be miniaturized.
    optional var miniaturized: Bool { get set } // Whether the window is currently miniaturized.
    optional var modal: Bool { get } // Whether the window is the application's current modal window.
    optional var name: String { get set } // The full title of the window.
    optional var resizable: Bool { get } // Whether the window can be resized.
    optional var titled: Bool { get } // Whether the window has a title bar.
    optional var visible: Bool { get set } // Whether the window is currently visible.
    optional var zoomable: Bool { get } // Whether the window can be zoomed.
    optional var zoomed: Bool { get set } // Whether the window is currently zoomed.
}
extension SBObject: DEVONthinkProWindow {}

// MARK: DEVONthinkProAttributeRun
@objc public protocol DEVONthinkProAttributeRun: DEVONthinkProItem {
    optional func attachments() -> SBElementArray
    optional func attributeRuns() -> SBElementArray
    optional func characters() -> SBElementArray
    optional func paragraphs() -> SBElementArray
    optional func words() -> SBElementArray
    optional var color: NSColor { get set } // The color of the first character.
    optional var font: String { get set } // The name of the font of the first character.
    optional var size: Int { get set } // The size in points of the first character.
    optional var alignment: String { get set } // Alignment of the text.
    optional var background: NSColor { get set } // The background color of the first character.
    optional var baselineOffset: Double { get set } // Number of pixels shifted above or below the normal baseline.
    optional var firstLineHeadIndent: Double { get set } // Paragraph first line head indent of the text (always 0 or positive)
    optional var headIndent: Double { get set } // Paragraph head indent of the text (always 0 or positive).
    optional var lineSpacing: Double { get set } // Line spacing of the text.
    optional var maximumLineHeight: Double { get set } // Maximum line height of the text.
    optional var minimumLineHeight: Double { get set } // Minimum line height of the text.
    optional var paragraphSpacing: Double { get set } // Paragraph spacing of the text.
    optional var superscript: Int { get set } // The superscript level of the text.
    optional var tailIndent: Double { get set } // Paragraph tail indent of the text. If positive, it's the absolute line width. If 0 or negative, it's added to the line width.
    optional var text: String { get set } // The actual text content.
    optional var underlined: Bool { get set } // Is the first character underlined?
    optional var URL: String { get set } // Link of the text.
}
extension SBObject: DEVONthinkProAttributeRun {}

// MARK: DEVONthinkProCharacter
@objc public protocol DEVONthinkProCharacter: DEVONthinkProItem {
    optional func attachments() -> SBElementArray
    optional func attributeRuns() -> SBElementArray
    optional func characters() -> SBElementArray
    optional func paragraphs() -> SBElementArray
    optional func words() -> SBElementArray
    optional var color: NSColor { get set } // The color of the first character.
    optional var font: String { get set } // The name of the font of the first character.
    optional var size: Int { get set } // The size in points of the first character.
    optional var alignment: String { get set } // Alignment of the text.
    optional var background: NSColor { get set } // The background color of the first character.
    optional var baselineOffset: Double { get set } // Number of pixels shifted above or below the normal baseline.
    optional var firstLineHeadIndent: Double { get set } // Paragraph first line head indent of the text (always 0 or positive)
    optional var headIndent: Double { get set } // Paragraph head indent of the text (always 0 or positive).
    optional var lineSpacing: Double { get set } // Line spacing of the text.
    optional var maximumLineHeight: Double { get set } // Maximum line height of the text.
    optional var minimumLineHeight: Double { get set } // Minimum line height of the text.
    optional var paragraphSpacing: Double { get set } // Paragraph spacing of the text.
    optional var superscript: Int { get set } // The superscript level of the text.
    optional var tailIndent: Double { get set } // Paragraph tail indent of the text. If positive, it's the absolute line width. If 0 or negative, it's added to the line width.
    optional var text: String { get set } // The actual text content.
    optional var underlined: Bool { get set } // Is the first character underlined?
    optional var URL: String { get set } // Link of the text.
}
extension SBObject: DEVONthinkProCharacter {}

// MARK: DEVONthinkProParagraph
@objc public protocol DEVONthinkProParagraph: DEVONthinkProItem {
    optional func attachments() -> SBElementArray
    optional func attributeRuns() -> SBElementArray
    optional func characters() -> SBElementArray
    optional func paragraphs() -> SBElementArray
    optional func words() -> SBElementArray
    optional var color: NSColor { get set } // The color of the first character.
    optional var font: String { get set } // The name of the font of the first character.
    optional var size: Int { get set } // The size in points of the first character.
    optional var alignment: String { get set } // Alignment of the text.
    optional var background: NSColor { get set } // The background color of the first character.
    optional var baselineOffset: Double { get set } // Number of pixels shifted above or below the normal baseline.
    optional var firstLineHeadIndent: Double { get set } // Paragraph first line head indent of the text (always 0 or positive)
    optional var headIndent: Double { get set } // Paragraph head indent of the text (always 0 or positive).
    optional var lineSpacing: Double { get set } // Line spacing of the text.
    optional var maximumLineHeight: Double { get set } // Maximum line height of the text.
    optional var minimumLineHeight: Double { get set } // Minimum line height of the text.
    optional var paragraphSpacing: Double { get set } // Paragraph spacing of the text.
    optional var superscript: Int { get set } // The superscript level of the text.
    optional var tailIndent: Double { get set } // Paragraph tail indent of the text. If positive, it's the absolute line width. If 0 or negative, it's added to the line width.
    optional var text: String { get set } // The actual text content.
    optional var underlined: Bool { get set } // Is the first character underlined?
    optional var URL: String { get set } // Link of the text.
}
extension SBObject: DEVONthinkProParagraph {}

// MARK: DEVONthinkProText
@objc public protocol DEVONthinkProText: DEVONthinkProItem {
    optional func attachments() -> SBElementArray
    optional func attributeRuns() -> SBElementArray
    optional func characters() -> SBElementArray
    optional func paragraphs() -> SBElementArray
    optional func words() -> SBElementArray
    optional var color: NSColor { get set } // The color of the first character.
    optional var font: String { get set } // The name of the font of the first character.
    optional var size: Int { get set } // The size in points of the first character.
    optional func addDownloadAutomatic(automatic: Bool, password: String!, referrer: String!, user: String!) -> Bool // Add a URL to the download manager.
    optional func convertFeedToHTMLBaseURL(baseURL: String!) -> String // Convert a RSS, RDF or Atom feed to HTML.
    optional func createDatabase() -> DEVONthinkProDatabase // Create a new DEVONthink Pro database.
    optional func createFormattedNoteFromAgent(agent: String!, `in` in_: DEVONthinkProRecord!, name: String!, referrer: String!, source: String!) -> DEVONthinkProRecord // Create a new formatted note from a web page.
    optional func createLocationIn(in_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Create a hierarchy of groups if necessary.
    optional func createMarkdownFromAgent(agent: String!, `in` in_: DEVONthinkProRecord!, name: String!, referrer: String!) -> DEVONthinkProRecord // Create a Markdown document from a web resource.
    optional func createPDFDocumentFromAgent(agent: String!, `in` in_: DEVONthinkProRecord!, name: String!, pagination: Bool, referrer: String!, width: Int) -> DEVONthinkProRecord // Create a new PDF document with or without pagination from a web resource.
    optional func createWebDocumentFromAgent(agent: String!, `in` in_: DEVONthinkProRecord!, name: String!, referrer: String!) -> DEVONthinkProRecord // Create a new record (picture, PDF or web archive) from a web resource.
    optional func deleteWorkspace() -> Bool // Delete a workspace.
    optional func displayAuthenticationDialog() -> DEVONthinkProRecord // Display a dialog to enter a username and its password.
    optional func displayGroupSelectorButtons(buttons: [AnyObject]!, `for` for_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Display a dialog to select a (destination) group.
    optional func displayNameEditorDefaultAnswer(defaultAnswer: String!, info: String!) -> String // Display a dialog to enter a name.
    optional func doJavaScriptIn(in_: DEVONthinkProThinkWindow!) -> String // Applies a string of JavaScript code to a think window.
    optional func downloadMarkupFromAgent(agent: String!, encoding: String!, password: String!, post: DEVONthinkProRecord!, referrer: String!, user: String!) -> String // Download an HTML or XML page (including RSS, RDF or Atom feeds).
    optional func downloadURLAgent(agent: String!, password: String!, post: DEVONthinkProRecord!, referrer: String!, user: String!) -> AnyObject // Download a URL.
    optional func existsRecordAtIn(in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record exists at the specified location.
    optional func existsRecordWithCommentIn(in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified comment exists.
    optional func existsRecordWithFileIn(in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified last path component exists.
    optional func existsRecordWithPathIn(in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified path exists.
    optional func existsRecordWithURLIn(in_: DEVONthinkProDatabase!) -> Bool // Check if at least one record with the specified URL exists.
    optional func getCachedDataForURLFrom(from: DEVONthinkProTab!) -> AnyObject // Get cached data for URL of a resource which is part of a loaded webpage and its DOM tree, rendered in a think tab/window.
    optional func getDatabaseWithUuid() -> DEVONthinkProDatabase // Get database with the specified uuid.
    optional func getEmbeddedImagesOfBaseURL(baseURL: String!, type: String!) -> [AnyObject] // Get the URLs of all embedded images of an HTML page.
    optional func getEmbeddedObjectsOfBaseURL(baseURL: String!, type: String!) -> [AnyObject] // Get the URLs of all embedded objects of an HTML page.
    optional func getEmbeddedSheetsAndScriptsOfBaseURL(baseURL: String!, type: String!) -> [AnyObject] // Get the URLs of all embedded style sheets and scripts of an HTML page.
    optional func getFramesOfBaseURL(baseURL: String!) -> [AnyObject] // Get the URLs of all frames of an HTML page.
    optional func getItemsOfFeedBaseURL(baseURL: String!) -> [AnyObject] // Get the items of a RSS, RDF or Atom feed. Dictionaries contain title (text), link (text), annotationDate (text), calendarDate (annotationDate), description (text), content (text), author (text), html (item converted to HTML), tags (list) and enclosures (list)
    optional func getLinksOfBaseURL(baseURL: String!, containing: String!, type: String!) -> [AnyObject] // Get the URLs of all links of an HTML page.
    optional func getRecordAtIn(in_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Search for record at the specified location.
    optional func getRecordWithUuidIn(in_: DEVONthinkProDatabase!) -> DEVONthinkProRecord // Get record with the specified uuid.
    optional func getRichTextOfBaseURL(baseURL: String!) -> DEVONthinkProText // Get the rich text of an HTML page.
    optional func getTextOf() -> String // Get the text of an HTML page.
    optional func getTitleOf() -> String // Get the title of an HTML page.
    optional func importFrom(from: String!, name: String!, placeholders: DEVONthinkProRecord!, to: DEVONthinkProRecord!, type: String) -> DEVONthinkProRecord // Import a file or folder (including its subfolders).
    optional func importTemplateTo(to: DEVONthinkProRecord!) -> DEVONthinkProRecord // Import a template. Note: Template scripts are not supported.
    optional func indicateTo(to: DEVONthinkProRecord!, type: String) -> DEVONthinkProRecord // Indicate ('index') a file or folder (including its subfolders). If no type is specified or the type is 'all', then links to unknown file types are created too.
    optional func loadWorkspace() -> Bool // Load a workspace.
    optional func logMessageInfo(info: String!) -> Bool // Log info for a file or action to the Log panel of DEVONthink Pro.
    optional func lookupRecordsWithCommentIn(in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records with specified comment.
    optional func lookupRecordsWithFileIn(in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records whose last path component is the specified file.
    optional func lookupRecordsWithPathIn(in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records with specified path.
    optional func lookupRecordsWithURLIn(in_: DEVONthinkProDatabase!) -> [AnyObject] // Lookup records with specified URL.
    optional func openDatabase() -> DEVONthinkProDatabase // Open an existing DEVONthink Pro database. To close a database, use the standard "close" command.
    optional func saveWorkspace() -> Bool // Save a workspace.
    optional func searchAge(age: Double, comparison: String, `in` in_: DEVONthinkProRecord!, label: Int, locking: Bool, state: Bool, unread: Bool, within: String) -> [AnyObject] // Search records by string, label, state/flag, locking and/or age.
    optional func showProgressIndicatorCancelButton(cancelButton: Bool, steps: Int) -> Bool // Show a progress indicator or update an already visible indicator. You have to ensure that the indicator is hidden again via 'hide progress indicator' when the script ends or if an error occurs.
    optional func stepProgressIndicator() -> Bool // Go to next step of a progress.
    optional var alignment: String { get set } // Alignment of the text.
    optional var background: NSColor { get set } // The background color of the first character.
    optional var baselineOffset: Double { get set } // Number of pixels shifted above or below the normal baseline.
    optional var firstLineHeadIndent: Double { get set } // Paragraph first line head indent of the text (always 0 or positive)
    optional var headIndent: Double { get set } // Paragraph head indent of the text (always 0 or positive).
    optional var lineSpacing: Double { get set } // Line spacing of the text.
    optional var maximumLineHeight: Double { get set } // Maximum line height of the text.
    optional var minimumLineHeight: Double { get set } // Minimum line height of the text.
    optional var paragraphSpacing: Double { get set } // Paragraph spacing of the text.
    optional var superscript: Int { get set } // The superscript level of the text.
    optional var tailIndent: Double { get set } // Paragraph tail indent of the text. If positive, it's the absolute line width. If 0 or negative, it's added to the line width.
    optional var text: String { get set } // The actual text content.
    optional var underlined: Bool { get set } // Is the first character underlined?
    optional var URL: String { get set } // Link of the text.
}
extension SBObject: DEVONthinkProText {}

// MARK: DEVONthinkProAttachment
@objc public protocol DEVONthinkProAttachment: DEVONthinkProText {
    optional var fileName: String { get set } // The path to the file for the attachment
}
extension SBObject: DEVONthinkProAttachment {}

// MARK: DEVONthinkProWord
@objc public protocol DEVONthinkProWord: DEVONthinkProItem {
    optional func attachments() -> SBElementArray
    optional func attributeRuns() -> SBElementArray
    optional func characters() -> SBElementArray
    optional func paragraphs() -> SBElementArray
    optional func words() -> SBElementArray
    optional var color: NSColor { get set } // The color of the first character.
    optional var font: String { get set } // The name of the font of the first character.
    optional var size: Int { get set } // The size in points of the first character.
    optional var alignment: String { get set } // Alignment of the text.
    optional var background: NSColor { get set } // The background color of the first character.
    optional var baselineOffset: Double { get set } // Number of pixels shifted above or below the normal baseline.
    optional var firstLineHeadIndent: Double { get set } // Paragraph first line head indent of the text (always 0 or positive)
    optional var headIndent: Double { get set } // Paragraph head indent of the text (always 0 or positive).
    optional var lineSpacing: Double { get set } // Line spacing of the text.
    optional var maximumLineHeight: Double { get set } // Maximum line height of the text.
    optional var minimumLineHeight: Double { get set } // Minimum line height of the text.
    optional var paragraphSpacing: Double { get set } // Paragraph spacing of the text.
    optional var superscript: Int { get set } // The superscript level of the text.
    optional var tailIndent: Double { get set } // Paragraph tail indent of the text. If positive, it's the absolute line width. If 0 or negative, it's added to the line width.
    optional var text: String { get set } // The actual text content.
    optional var underlined: Bool { get set } // Is the first character underlined?
    optional var URL: String { get set } // Link of the text.
}
extension SBObject: DEVONthinkProWord {}

// MARK: DEVONthinkProDatabase
@objc public protocol DEVONthinkProDatabase: DEVONthinkProItem {
    optional func contents() -> SBElementArray
    optional func parents() -> SBElementArray
    optional func records() -> SBElementArray
    optional func tagGroups() -> SBElementArray
    optional var comment: String { get set } // The comment of the database.
    optional var currentGroup: DEVONthinkProRecord { get } // The (selected) group of the frontmost window. Returns root if no current group exists.
    optional func id() -> Int // The scripting identifier of a database.
    optional var incomingGroup: DEVONthinkProRecord { get } // The default group for new notes. Might be identical to root.
    optional var name: String { get set } // The name of the database.
    optional var path: String { get } // The POSIX path of the database.
    optional var readOnly: Bool { get } // Specifies if a database is read-only and can't be modified.
    optional var root: DEVONthinkProRecord { get } // The top level group of the database.
    optional var syncGroup: DEVONthinkProRecord { get } // The group for synchronizing.
    optional var tagsGroup: DEVONthinkProRecord { get } // The group for tags.
    optional var trashGroup: DEVONthinkProRecord { get } // The trash's group.
    optional var uuid: String { get } // The unique and persistent identifier of a database for external referencing.
}
extension SBObject: DEVONthinkProDatabase {}

// MARK: DEVONthinkProRecord
@objc public protocol DEVONthinkProRecord: DEVONthinkProItem {
    optional func children() -> SBElementArray
    optional func parents() -> SBElementArray
    optional var additionDate: NSDate { get } // Date when the record was added to the database.
    optional var aliases: String { get set } // Wiki aliases (separated by commas or semicolons) of a record.
    optional var attachedScript: String { get set } // POSIX path of script attached to a record.
    optional var cells: [AnyObject] { get set } // The cells of a sheet.
    optional var characterCount: Int { get } // The character count of a record.
    optional var columns: [AnyObject] { get } // The column names of a sheet.
    optional var comment: String { get set } // The comment of a record.
    optional var creationDate: NSDate { get set } // The creation annotationDate of a record.
    optional var data: AnyObject { get set } // The file data of a record. Currently only supported by PDF documents, images, rich texts and web archives.
    optional var database: DEVONthinkProDatabase { get } // The database of the record.
    optional var date: NSDate { get set } // The (creation/modification) annotationDate of a record.
    optional var dimensions: [AnyObject] { get } // The width and height of an image or PDF document in pixels.
    optional var dpi: Int { get } // The resultion of an image in dpi.
    optional var duplicates: [AnyObject] { get } // The duplicates of a record (only other instances, not including the record).
    optional var excludeFromClassification: Bool { get set } // Exclude group or record from classifying.
    optional var excludeFromSearch: Bool { get set } // Exclude group or record from searching.
    optional var excludeFromSeeAlso: Bool { get set } // Exclude record from see also.
    optional var excludeFromTagging: Bool { get set } // Exclude group from tagging.
    optional var filename: String { get } // The proposed file name for a record.
    optional var height: Int { get } // The height of an image or PDF document in pixels.
    optional func id() -> Int // The scripting identifier of a record. Optimizing or closing a database might modify this identifier.
    optional var image: AnyObject { get set } // The image or PDF document of a record.
    optional var indexed: Bool { get } // Indexed or imported record.
    optional var interval: Double { get set } // Refresh interval of a feed. Currently overriden by preferences.
    optional var kind: String { get } // The human readable kind of a record. WARNING: Don't use this to check the type of a record, otherwise your script might fail depending on the version and the localization.
    optional var label: Int { get set } // Index of label (0-7) of a record.
    optional var location: String { get } // The location in the database as a POSIX path (/ in names is replaced with \/).
    optional var locking: Bool { get set } // The locking of a record.
    optional var metaData: DEVONthinkProRecord { get } // The metadata of a record as a dictionary containing key-value pairs. Possible keys are currently kMDItemTitle, kMDItemHeadline, kMDItemSubject, kMDItemDescription, kMDItemCopyright, kMDItemComment, kMDItemURL, kMDItemKeywords, kMDItemCreator, kMDItemProdu
    optional var MIMEType: String { get } // The (proposed) MIME type of a record.
    optional var modificationDate: NSDate { get set } // The modification annotationDate of a record.
    optional var name: String { get set } // The name of a record.
    optional var numberOfDuplicates: Int { get } // The number of duplicates of a record.
    optional var numberOfReplicants: Int { get } // The number of replicants of a record.
    optional var openingDate: NSDate { get } // Date when a content was opened the last time or when a feed was refreshed the last time.
    optional var pageCount: Int { get } // The page count of a record. Currently only supported by PDF documents.
    optional var path: String { get } // The POSIX file path of a record.
    optional var plainText: String { get set } // The plain text of a record.
    optional var referenceURL: String { get }
    optional var richText: DEVONthinkProText { get set } // The rich text of a record (see text suite).
    optional var score: Double { get } // The score of the last comparison, classification or search (value between 0.0 and 1.0) or undefined otherwise.
    optional var size: Int { get } // The size of a record in bytes.
    optional var source: String { get set } // The HTML/XML source of a record if available or the record converted to HTML if possible.
    optional var state: Bool { get set } // The state/flag of a record.
    optional var stateVisibility: Bool { get set } // Obsolete.
    optional var tagType: String { get } // The tag type of a record.
    optional var tags: [AnyObject] { get set } // The tags of a record.
    optional var thumbnail: AnyObject { get set } // The thumbnail of a record.
    optional var type: String { get } // The type of a record.
    optional var unread: Bool { get set } // The unread flag of a record.
    optional var URL: String { get set } // The URL of a record.
    optional var uuid: String { get } // The unique and persistent identifier of a record.
    optional var width: Int { get } // The width of an image or PDF document in pixels.
    optional var wordCount: Int { get } // The word count of a record.
    optional func createRecordWithIn(in_: DEVONthinkProRecord!) -> DEVONthinkProRecord // Create a new record.
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
    optional var contentRecord: DEVONthinkProRecord { get } // The record of the visible document.
    optional var currentPage: Int { get } // Zero-based index of current PDF page.
    optional var database: DEVONthinkProDatabase { get } // The database of the tab.
    optional func id() -> Int // The unique identifier of the tab.
    optional var loading: Bool { get } // Specifies if the current web page is still loading.
    optional var numberOfColumns: Int { get } // Number of columns of the current sheet.
    optional var numberOfRows: Int { get } // Number of rows of the current sheet.
    optional var paginatedPDF: AnyObject { get } // A printed PDF with pagination of the visible document.
    optional var PDF: AnyObject { get } // A PDF without pagination of the visible document retaining the screen layout.
    optional var selectedColumn: Int { get set } // Index (1-n) of selected column of the current sheet.
    optional var selectedColumns: [AnyObject] { get } // Indices (1-n) of selected columns of the current sheet.
    optional var selectedRow: Int { get set } // Index (1-n) of selected row of the current sheet.
    optional var selectedRows: [AnyObject] { get } // Indices (1-n) of selected rows of the current sheet.
    optional var selectedText: DEVONthinkProSelectedText { get set } // The text container for the selection of the tab.
    optional var source: String { get } // The HTML source of the current web page.
    optional var text: DEVONthinkProText { get set } // The text container of the tab.
    optional var thinkWindow: DEVONthinkProThinkWindow { get } // The think window of the tab.
    optional var URL: String { get set } // The URL of the current web page.
    optional var webArchive: AnyObject { get } // Web archive of the current web page.
}
extension SBObject: DEVONthinkProTab {}

// MARK: DEVONthinkProTagGroup
@objc public protocol DEVONthinkProTagGroup: DEVONthinkProRecord {
}
extension SBObject: DEVONthinkProTagGroup {}

// MARK: DEVONthinkProThinkWindow
@objc public protocol DEVONthinkProThinkWindow: DEVONthinkProWindow {
    optional func tabs() -> SBElementArray
    optional var contentRecord: DEVONthinkProRecord { get } // The record of the visible document.
    optional var currentPage: Int { get } // Zero-based index of current PDF page.
    optional var currentTab: DEVONthinkProTab { get set } // The selected tab of the think window.
    optional var database: DEVONthinkProDatabase { get } // The database of the window.
    optional var loading: Bool { get } // Specifies if the current web page is still loading.
    optional var numberOfColumns: Int { get } // Number of columns of the current sheet.
    optional var numberOfRows: Int { get } // Number of rows of the current sheet.
    optional var paginatedPDF: AnyObject { get } // A printed PDF with pagination of the visible document.
    optional var PDF: AnyObject { get } // A PDF without pagination of the visible document retaining the screen layout.
    optional var selectedColumn: Int { get set } // Index (1-n) of selected column of the current sheet.
    optional var selectedColumns: [AnyObject] { get } // Indices (1-n) of selected columns of the current sheet.
    optional var selectedRow: Int { get set } // Index (1-n) of selected row of the current sheet.
    optional var selectedRows: [AnyObject] { get } // Indices (1-n) of selected rows of the current sheet.
    optional var selectedText: DEVONthinkProSelectedText { get set } // The text container for the selection of the window.
    optional var source: String { get } // The HTML source of the current web page.
    optional var text: DEVONthinkProText { get set } // The text container of the window.
    optional var URL: String { get set } // The URL of the current web page.
    optional var webArchive: AnyObject { get } // Web archive of the current web page.
}
extension SBObject: DEVONthinkProThinkWindow {}

// MARK: DEVONthinkProDocumentWindow
@objc public protocol DEVONthinkProDocumentWindow: DEVONthinkProThinkWindow {
    optional var record: DEVONthinkProRecord { get set } // The record of the document.
}
extension SBObject: DEVONthinkProDocumentWindow {}

// MARK: DEVONthinkProSearchWindow
@objc public protocol DEVONthinkProSearchWindow: DEVONthinkProThinkWindow {
    optional var results: [AnyObject] { get set } // The search results.
    optional var selection: [AnyObject] { get } // The selected results.
}
extension SBObject: DEVONthinkProSearchWindow {}

// MARK: DEVONthinkProViewerWindow
@objc public protocol DEVONthinkProViewerWindow: DEVONthinkProThinkWindow {
    optional var root: DEVONthinkProRecord { get set } // The top level group of the viewer.
    optional var selection: [AnyObject] { get set } // The selected records.
}
extension SBObject: DEVONthinkProViewerWindow {}

// MARK: DEVONthinkProPrintSettings
@objc public protocol DEVONthinkProPrintSettings: SBObjectProtocol {
    optional var copies: Int { get set } // the number of copies of a document to be printed
    optional var collating: Bool { get set } // Should printed copies be collated?
    optional var startingPage: Int { get set } // the first page of the document to be printed
    optional var endingPage: Int { get set } // the last page of the document to be printed
    optional var pagesAcross: Int { get set } // number of logical pages laid across a physical page
    optional var pagesDown: Int { get set } // number of logical pages laid out down a physical page
    optional var requestedPrintTime: NSDate { get set } // the time at which the desktop printer should print the document
    optional var errorHandling: String { get set } // how errors are handled
    optional var faxNumber: String { get set } // for fax number
    optional var targetPrinter: String { get set } // for target printer
    optional func closeSaving(saving: String, savingIn: AnyObject!) // Close an object.
    optional func delete() // Delete an object.
    optional func duplicateTo(to: SBObject!, withProperties: DEVONthinkProRecord!) // Copy object(s) and put the copies at a new location.
    optional func exists() -> Bool // Verify if an object exists.
    optional func moveTo(to: SBObject!) // Move object(s) to a new location.
    optional func saveAs(`as`: String!, `in` in_: AnyObject!) // Save an object.
    optional func bold() // Bold some text
    optional func italicize() // Italicize some text
    optional func plain() // Make some text plain
    optional func reformat() // Reformat some text. Similar to WordService's Reformat service.
    optional func scrollToVisible() // Scroll to and animate some text. Requires Mac OS X 10.6.
    optional func strike() // Strike some text
    optional func unbold() // Unbold some text
    optional func underline() // Underline some text
    optional func unitalicize() // Unitalicize some text
    optional func unstrike() // Unstrike some text
    optional func ununderline() // Ununderline some text
    optional func addRowCells(cells: [AnyObject]!) -> Bool // Add new row to current sheet.
    optional func deleteRowAtPosition(position: Int) -> Bool // Remove row at specified position from current sheet.
    optional func getCellAtColumn(column: Int, row: Int) -> String // Get content of cell at specified position of current sheet.
    optional func setCellAtColumn(column: Int, row: Int, to: String!) -> Bool // Set cell at specified position of current sheet.
    optional func convertImageRecord(record: DEVONthinkProRecord!, rotateBy: Int, to: DEVONthinkProRecord!, waitingForReply: Bool) -> DEVONthinkProRecord // Returns a searchable PDF for an image record.
    optional func ocrFile(file: String!, attributes: DEVONthinkProRecord!, rotateBy: Int, to: DEVONthinkProRecord!, waitingForReply: Bool) -> DEVONthinkProRecord // Returns a record with a searchable PDF.
}
extension SBObject: DEVONthinkProPrintSettings {}

