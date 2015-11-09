//
//  Preferences.swift
//  Excerptor
//
//  Created by Chen Guo on 19/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

import Cocoa
import PreferencePanes


class PreferencesWindowController: NSWindowController {
    
    static var needShowPreferences = true
    
    private var prefPane: NSPreferencePane! = {
        if let pathToPrefPaneBundle = NSBundle.mainBundle().pathForResource("PrefsPane", ofType: "prefPane", inDirectory: "PreferencePanes"),
            prefBundle = NSBundle(path: pathToPrefPaneBundle),
            prefPaneClass = prefBundle.principalClass as? NSPreferencePane.Type
        {
            var prefPane = prefPaneClass.init(bundle: prefBundle)
            (prefPane as PrefsPane).setDelegate!(Preferences.sharedPreferences)
            return prefPane
        } else {
            exitWithError("Could not load preference pane bundle")
        }
    }()
    

    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func showPreferencesIfNecessary() {
        if !PreferencesWindowController.needShowPreferences {
            return
        }

        if window!.contentView!.subviews.count == 0 {
            prefPane.loadMainView()
            prefPane.willSelect()
            let prefView = prefPane.mainView
            window!.setContentSize(prefView.frame.size)
            window!.contentView!.addSubview(prefView)
            prefPane.didSelect()
        }

        NSApp.activateIgnoringOtherApps(true)
        showWindow(self)
    }
    
    func showPreferencesOnlyOnceIfNecessaryAfterDelay(delaySeconds: NSTimeInterval) {
        delay(0.3) {
            self.showPreferencesIfNecessary()
            PreferencesWindowController.needShowPreferences = true
        }
    }

}

@objc public protocol PrefsPane {
    optional func setDelegate(delegate: PrefsPaneDelegate)
}

extension NSPreferencePane: PrefsPane {}

