//
//  AppDelegate.swift
//  signator
//
//  Created by Mehul Bhavani on 12/24/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var cmdsWindowController: CommandsWindowController?
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(handleURL(event:reply:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        WindowsManager.shared.pushEmpty()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        WindowsManager.shared.pushEmpty()
        return true
    }
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        WindowsManager.shared.push(forFilepath: filename)
        return true
    }
    
    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        for filename in filenames {
            WindowsManager.shared.push(forFilepath: filename)
        }
    }

    @objc func handleURL(event: NSAppleEventDescriptor, reply: NSAppleEventDescriptor) {
        if let path = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue {
            if let components = URLComponents(string: path) {
                if let queryItems = components.queryItems {
                    for item in queryItems {
                        if item.name == "path" {
                            if let path = item.value {
                                WindowsManager.shared.push(forFilepath: path)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func commandsMenuItem_Clicked(_ item: Any) {
        if cmdsWindowController == nil {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            if let windowController = storyboard.instantiateController(withIdentifier: "\(CommandsWindowController.self)") as? CommandsWindowController {
                cmdsWindowController = windowController
            }
        }
        if let cmdsWindowController = cmdsWindowController {
            cmdsWindowController.showWindow(self)
        }
    }
}

