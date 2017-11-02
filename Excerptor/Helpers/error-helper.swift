//
//  error-helper.swift
//  excerptor
//
//  Created by Chen Guo on 17/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

func printToStandardError(_ string: String) {
    let stderr = FileHandle.standardError
    let stringWithAppInfo = "Excerptor: \(string)"
    stderr.write(stringWithAppInfo.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
}

func printlnToStandardError(_ string: String) {
    printToStandardError("\(string)\n")
}

var runningInCLI = false

func exitWithError(_ err: String) -> Never {
    if runningInCLI {
        printlnToStandardError(err)
        exit(1)
    } else {
        notifyWithError("Excerptor error", informativeText: err)
        fatalError(err)
    }
}

private let userNotificationCenterDelegate = UserNotificationCenterDelegate()

private struct Constants {
    static let PDFFilePathToRevealInFinder = "PDFFilePathToRevealInFinder"
}

func notifyWithUserNotification(_ userNotification: NSUserNotification) {
    if runningInCLI {
        var err = ""
        if let title = userNotification.title {
            err += "\(title)\n"
        }
        if let subtitle = userNotification.subtitle {
            err += "\(subtitle)\n"
        }
        if let informativeText = userNotification.informativeText {
            err += "\(informativeText)\n"
        }
        if let userInfo = userNotification.userInfo {
            err += userInfo.values.map { $0 as? String ?? "" }.joined(separator: "\n")
            err += "\n"
        }
        printlnToStandardError(err)
    } else {
        let userNotificationCenter = NSUserNotificationCenter.default
        userNotificationCenter.delegate = userNotificationCenterDelegate
        userNotificationCenter.deliver(userNotification)
    }
}

func notifyWithError(_ err: String, informativeText: String?) {
    let userNotification = NSUserNotification()
    let errComponents = err.components(separatedBy: "\n")
    switch errComponents.count {
    case 1:
        userNotification.title = errComponents[0]
    case 2:
        userNotification.title = errComponents[0]
        userNotification.subtitle = errComponents[1]
    default:
        userNotification.title = err
    }
    userNotification.informativeText = informativeText
    userNotification._ignoresDoNotDisturb = true
    notifyWithUserNotification(userNotification)
}

func notifyPDFFileNotFoundInDNtpWith(_ filePath: String, replacingPlaceholder: String) {
    let userNotification = NSUserNotification()
    userNotification.title = "Could Not Find The PDF File In DEVONthink"
    userNotification.subtitle = "\(replacingPlaceholder) applied instead"
    userNotification.informativeText = URL(fileURLWithPath: filePath).lastPathComponent
    let path = URL(fileURLWithPath: filePath).standardizedFileURL.path
    userNotification.userInfo = [Constants.PDFFilePathToRevealInFinder: path]
    userNotification._ignoresDoNotDisturb = true
    notifyWithUserNotification(userNotification)
}

class UserNotificationCenterDelegate: NSObject, NSUserNotificationCenterDelegate {

    // Notifications may be suppressed if the application is already frontmost,
    // this extension is to make sure notifications can be showed in this case,
    // although the case doesn't happen.
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    // Prevent from showing preferences window when users click on notification.
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        PreferencesWindowController.needShowPreferences = false
        if let userInfo = notification.userInfo, let filePath = userInfo[Constants.PDFFilePathToRevealInFinder] as? String {
            let url = URL(fileURLWithPath: filePath, isDirectory: false)
            NSWorkspace.shared.activateFileViewerSelecting([url])
        }
    }

}
