//
//  AddCommandWindowController.swift
//  Signator
//
//  Created by Mehul Bhavani on 17/01/22.
//

import Cocoa

class AddCommandWindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
    }
}

class AddCommandViewController: NSViewController {
    
    @IBOutlet private var titleBox: NSBox?
    @IBOutlet private var pathBox: NSBox?
    @IBOutlet private var argumentsBox: NSBox?
    
    @IBOutlet private var titleTextField: NSTextField?
    @IBOutlet private var pathTextField: NSTextField?
    @IBOutlet private var argumentsTextField: NSTextField?
    
    @IBOutlet private var errorTextField: NSTextField?
    
    private(set) var currentCommand: Command?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButton_Clicked(_ button: NSButton) {
        if let window = self.view.window {
            window.sheetParent?.endSheet(window, returnCode: .cancel)
        }
    }
    @IBAction func addButton_Clicked(_ button: NSButton) {
        guard let title = titleTextField?.stringValue, title.count != 0 else {
            errorTextField?.stringValue = "Invalid command title. Try again!"
            titleBox?.borderColor = .systemYellow
            return
        }
        guard let path = pathTextField?.stringValue, path.count != 0 else {
            errorTextField?.stringValue = "Invalid command path. Try again!"
            return
        }
        guard let arguments = argumentsTextField?.stringValue, arguments.count != 0 else {
            errorTextField?.stringValue = "Invalid command arguments. Try again!"
            return
        }
        
        currentCommand = Command(isEnabled: true, title: title, path: path, arguments: arguments)
        if let window = self.view.window {
            window.sheetParent?.endSheet(window, returnCode: .OK)
        }
    }
    
    func setCurrentCommand(cmd: Command?) {
        currentCommand = cmd
        if let currentCommand = currentCommand {
            titleTextField?.stringValue = currentCommand.title
            pathTextField?.stringValue = currentCommand.path
            argumentsTextField?.stringValue = currentCommand.arguments
        }
    }
}
