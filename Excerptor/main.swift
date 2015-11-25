//
//  main.swift
//  Excerptor
//
//  Created by Chen Guo on 20/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Foundation

import CommandLine

if Process.argc == 1 || Process.argc == 3 && Process.arguments[1] == "-NSDocumentRevisionsDebugMode" && Process.arguments[2] == "YES" {
    NSApplicationMain(Process.argc, Process.unsafeArgv)
    exit(0)
}

enum Operation: String {
    case List = "list"
    case Export = "export"
}

enum ExtractionType: String {
    case Annotation = "annotation"
}

enum Format: String {
    case Text = "text"
    case JSON = "JSON"
}

let operation = EnumOption<Operation>(longFlag: "operation", helpMessage: "'list' / 'export', 'list' by default.")
let extractionType = EnumOption<ExtractionType>(longFlag: "type", helpMessage: "Type of data to be extracted, currently only supports 'annotation', by default 'annotation'.")
let format = EnumOption<Format>(longFlag: "format", helpMessage: "Display format, currently only supports 'text' and 'JSON', 'text' by default.")
let sourceFilePath = StringOption(longFlag: "source-file", required: true, helpMessage: "Path of the PDF file which containing required data.")

let cli = CommandLine()

cli.addOptions(operation, extractionType, format, sourceFilePath)

runningInCLI = true
do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

let unwrappedOperation = operation.value ?? Operation.List

let unwrappedExtractionType = extractionType.value ?? ExtractionType.Annotation

let unwrappedFormat = format.value ?? Format.Text
let outputFormat: OutputFormat = {
    switch unwrappedFormat {
    case .JSON:
        return .JSON
    case .Text:
        return .Text
    }
}()

guard let unwrappedSourceFilePath = sourceFilePath.value else {
    exitWithError("--source-file is required")
}
guard let sourceFileURL = NSURL(fileURLWithPath: unwrappedSourceFilePath, isDirectory: false).URLByStandardizingPath else {
    exitWithError("\(unwrappedSourceFilePath): Incorrect source file path")
}

switch unwrappedOperation {

case Operation.List:
    printAnnotationsFrom(sourceFileURL, withFormat: outputFormat)

case Operation.Export:
    writePDFAnnotationsFrom(sourceFileURL)
}

runningInCLI = false
