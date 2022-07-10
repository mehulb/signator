//
//  WindowsManager.swift
//  signator
//
//  Created by Mehul Bhavani on 12/24/21.
//

import AppKit

class WindowController: NSWindowController {
    
}

class Window: NSWindow, NSWindowDelegate {
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self..standardWindowButton(.closeButton)?.isHidden = true
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true
    }
    
    func windowWillClose(_ notification: Notification) {
        if let windowController = self.windowController {
            WindowsManager.shared.pop(windowController)
        }
    }
}

class WindowsManager {
    private init() {}
    static let shared = WindowsManager()
    
    private var controllers = [NSWindowController]()
    
    func pushEmpty() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        if let windowController = storyboard.instantiateController(withIdentifier: "\(WindowController.self)") as? WindowController {
            windowController.showWindow(self)
            push(windowController)
        }
    }
    func push(forFilepath path: String) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        if let windowController = storyboard.instantiateController(withIdentifier: "\(WindowController.self)") as? WindowController {
            windowController.showWindow(self)
            push(windowController)
            if let viewController = windowController.contentViewController as? ViewController {
                viewController.check(path)
            }
        }
    }
    func push(_ controller: NSWindowController) {
        controllers.append(controller)
    }
    func pop(_ controller: NSWindowController) {
        let index = controllers.firstIndex(of: controller)
        if let index = index {
            controllers.remove(at: index)
        }
    }
}
