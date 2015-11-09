//
//  main.swift
//  Excerptor
//
//  Created by Chen Guo on 20/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

/*
import Foundation

import CLIKit

print(Process.arguments)
if Process.argc == 1 || Process.argc == 3 && Process.arguments[1] == "-NSDocumentRevisionsDebugMode" && Process.arguments[2] == "YES" {
*/
    NSApplicationMain(Process.argc, Process.unsafeArgv)
    exit(0)
/*
}

var manager = Manager()

manager.register("show annotation", "Show annotations in PDF file") { argv in
    if let pdfFilePath = argv.shift(), pdfFileUrl = NSURL(fileURLWithPath: pdfFilePath.stringByStandardizingPath, isDirectory: false) {
        let formatOption = argv.option("format")?.lowercaseString ?? "text"
        let format: OutputFormat = {
            switch formatOption {
            case "json":
                return .JSON
            case "text":
                return .Text
            default:
                printlnToStandardError("Unsupported format option, use \"text\" instead")
                return .Text
            }
        }()
        printAnnotationsFrom(pdfFileUrl, withFormat: format)
    } else {
        printlnToStandardError("Incorrect PDF file path")
    }
}

manager.register("extract annotation", "Extract annotations from PDF file") { argv in
    if let pdfFilePath = argv.shift(), pdfFileUrl = NSURL(fileURLWithPath: pdfFilePath, isDirectory: false) {
        if let targetFolder = argv.option("targetfolder"), targetFolderUrl = NSURL(fileURLWithPath: targetFolder.stringByStandardizingPath, isDirectory: true) {
            writePDFAnnotationsFrom(pdfFileUrl, toTargetFolder: targetFolderUrl)
        } else {
            writePDFAnnotationsFrom(pdfFileUrl)
        }
    } else {
        printlnToStandardError("Incorrect PDF file path")
    }
}

runningInCLI = true
manager.run()
runningInCLI = false
*/
