//
//  error-helper.swift
//  excerptor
//
//  Created by Chen Guo on 17/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

func printToStandardError(string: String) {
    let stderr = NSFileHandle.fileHandleWithStandardError()
    let stringWithAppInfo = "Excerptor: \(string)"
    stderr.writeData(stringWithAppInfo.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
}

func printlnToStandardError(string: String) {
    printToStandardError("\(string)\n")
}

var runningInCLI = false

@noreturn func exitWithError(err: String) {
    if runningInCLI {
        printlnToStandardError(err)
        exit(1)
    } else {
        let alert = NSAlert()
        alert.alertStyle = .WarningAlertStyle
        alert.messageText = "Excerptor"
        alert.informativeText = err
        alert.addButtonWithTitle("Ok")
        alert.runModal()
        fatalError(err)
    }
}

private let userNotificationCenterDelegate = UserNotificationCenterDelegate()

private struct Constants {
    static let PDFFilePathToRevealInFinder = "PDFFilePathToRevealInFinder"
}

func notifyWithUserNotification(userNotification: NSUserNotification) {
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
            err += "\n".join(userInfo.values.map{ $0 as? String ?? "" })
            err += "\n"
        }
        printlnToStandardError(err)
    } else {
        var userNotificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()
        userNotificationCenter.delegate = userNotificationCenterDelegate
        userNotificationCenter.deliverNotification(userNotification)
    }
}

func notifyWithError(err: String, informativeText: String?) {
    var userNotification = NSUserNotification()
    let errComponents = err.componentsSeparatedByString("\n")
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

func notifyPDFFileNotFoundInDNtpWith(filePath: String, #replacingPlaceholder: String) {
    var userNotification = NSUserNotification()
    userNotification.title = "Cannot Find The PDF File In DEVONthink"
    userNotification.subtitle = "\(replacingPlaceholder) applied instead"
    userNotification.informativeText = filePath.lastPathComponent
    userNotification.userInfo = [Constants.PDFFilePathToRevealInFinder as NSString: filePath.stringByStandardizingPath]
    userNotification._ignoresDoNotDisturb = true
    notifyWithUserNotification(userNotification)
}


class UserNotificationCenterDelegate: NSObject, NSUserNotificationCenterDelegate {

    // Notifications may be suppressed if the application is already frontmost,
    // this extension is to make sure notifications can be showed in this case,
    // although the case doesn't happen.
    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }
    
    // Prevent from showing preferences window when users click on notification.
    func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
        PreferencesWindowController.needShowPreferences = false
        if let userInfo = notification.userInfo, filePath = userInfo[Constants.PDFFilePathToRevealInFinder] as? String, url = NSURL(fileURLWithPath: filePath) {
            NSWorkspace.sharedWorkspace().activateFileViewerSelectingURLs([url])
        }
    }

}
