//
//  AppDelegate.swift
//  excerptor
//
//  Created by Chen Guo on 17/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Cocoa
import PreferencePanes

class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var preferencesWindowController: PreferencesWindowController = PreferencesWindowController(windowNibName: "PreferencesWindow")

    func applicationWillFinishLaunching(_ notification: Notification) {

        preferencesWindowController.showPreferencesOnlyOnceIfNecessaryAfterDelay(0.3)

        let servicesProvider = ServicesProvider()
        NSApplication.shared().servicesProvider = servicesProvider

        let appleEventManager: NSAppleEventManager = NSAppleEventManager.shared()
        appleEventManager.setEventHandler(self, andSelector: #selector(handleGetURLEvent(_:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        preferencesWindowController.showPreferencesOnlyOnceIfNecessaryAfterDelay(0.3)
    }

    func handleGetURLEvent(_ event: NSAppleEventDescriptor, withReplyEvent: NSAppleEventDescriptor) {
        PreferencesWindowController.needShowPreferences = false
        if let theURLString = event.forKeyword(AEKeyword(keyDirectObject))?.stringValue {
            if let link = AnnotationLink(linkString: theURLString) ?? SelectionLink(linkString: theURLString) {
                PasteboardHelper.writeExcerptorPasteboardWithLocation(link.location)
                let applicationName: String
                switch Preferences.sharedPreferences.appForOpenPDF {
                case .preview:
                    applicationName = "Preview.app"
                case .skim:
                    applicationName = "Skim.app"
                }
                NSWorkspace().openFile(link.getFilePath(), withApplication: applicationName, andDeactivate: true)
            }
        }
    }


}
