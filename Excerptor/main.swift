//
//  main.swift
//  Excerptor
//
//  Created by Chen Guo on 20/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Foundation

import CommandLineKit

if CommandLine.argc == 1 || CommandLine.argc == 3 && CommandLine.arguments[1] == "-NSDocumentRevisionsDebugMode" && CommandLine.arguments[2] == "YES" {
    _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    exit(0)
}

enum Operation: String {
    case list
    case export
}

enum ExtractionType: String {
    case annotation
}

enum Format: String {
    case text
    case JSON
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

let unwrappedOperation = operation.value ?? Operation.list

let unwrappedExtractionType = extractionType.value ?? ExtractionType.annotation

let unwrappedFormat = format.value ?? Format.text
let outputFormat: OutputFormat = {
    switch unwrappedFormat {
    case .JSON:
        return .json
    case .text:
        return .text
    }
}()

guard let unwrappedSourceFilePath = sourceFilePath.value else {
    exitWithError("--source-file is required")
}
guard let sourceFileURL = NSURL(fileURLWithPath: unwrappedSourceFilePath, isDirectory: false).standardizingPath else {
    exitWithError("\(unwrappedSourceFilePath): Incorrect source file path")
}

switch unwrappedOperation {

case Operation.list:
    printAnnotationsFrom(sourceFileURL, withFormat: outputFormat)

case Operation.export:
    writePDFAnnotationsFrom(sourceFileURL)
}

runningInCLI = false
