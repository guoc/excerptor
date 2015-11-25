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

    func applicationWillFinishLaunching(notification: NSNotification) {

        preferencesWindowController.showPreferencesOnlyOnceIfNecessaryAfterDelay(0.3)

        let servicesProvider = ServicesProvider()
        NSApplication.sharedApplication().servicesProvider = servicesProvider

        let appleEventManager: NSAppleEventManager = NSAppleEventManager.sharedAppleEventManager()
        appleEventManager.setEventHandler(self, andSelector: "handleGetURLEvent:withReplyEvent:", forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }

    func applicationDidBecomeActive(notification: NSNotification) {
        preferencesWindowController.showPreferencesOnlyOnceIfNecessaryAfterDelay(0.3)
    }

    func handleGetURLEvent(event: NSAppleEventDescriptor, withReplyEvent: NSAppleEventDescriptor) {
        PreferencesWindowController.needShowPreferences = false
        if let theURLString = event.descriptorForKeyword(AEKeyword(keyDirectObject))?.stringValue {
            if let link = AnnotationLink(linkString: theURLString) ?? SelectionLink(linkString: theURLString) {
                PasteboardHelper.writeExcerptorPasteboardWithLocation(link.location)
                let applicationName: String
                switch Preferences.sharedPreferences.appForOpenPDF {
                case .Preview:
                    applicationName = "Preview.app"
                case .Skim:
                    applicationName = "Skim.app"
                }
                NSWorkspace().openFile(link.getFilePath(), withApplication: applicationName, andDeactivate: true)
            }
        }
    }


}
