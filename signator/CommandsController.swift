//
//  CommandsController.swift
//  Signator
//
//  Created by Mehul Bhavani on 16/01/22.
//

import AppKit

class CommandsWindowController: NSWindowController {
    @IBAction func addToolbarItem_Clicked(_ item: Any) {
        if let viewController = self.contentViewController as? CommandsViewController {
            viewController.addCommand()
        }
    }
    @IBAction func removeToolbarItem_Clicked(_ item: Any) {
        if let viewController = self.contentViewController as? CommandsViewController {
            viewController.removeCommand()
        }
    }
    
}

class CommandsViewController: NSViewController {
    
    private var addCommandController: AddCommandWindowController?
    
    @IBOutlet var tableView: NSTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightClickMenu = NSMenu()
        let editMenuItem = NSMenuItem(title: "Edit", action: #selector(editMenuItem_Clicked(_:)), keyEquivalent: "")
        rightClickMenu.addItem(editMenuItem)
        tableView?.menu = rightClickMenu
    }
    
    @objc func editMenuItem_Clicked(_ item: Any) {
        if let row = tableView?.clickedRow, row >= 0 {
            let cmd = CommandCenter.shared.commands[row]
            showCommandEditor(cmd: cmd)
        }
    }
    func removeCommand() {
        if let index = tableView?.selectedRow, index >= 0, index < CommandCenter.shared.commands.count {
            let alert = NSAlert()
            alert.messageText = "Are you sure you want to remove this command?"
            alert.addButton(withTitle: "Remove")
            alert.addButton(withTitle: "Cancel")
            alert.beginSheetModal(for: self.view.window!) { (response) in
                if response == .alertFirstButtonReturn {
                    CommandCenter.shared.replace(command: CommandCenter.shared.commands[index], with: nil)
                    self.tableView?.reloadData()
                }
            }
        }
    }
    func addCommand() {
        showCommandEditor(cmd: nil)
    }
    
    func showCommandEditor(cmd: Command?) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        if let windowController = storyboard.instantiateController(withIdentifier: "\(AddCommandWindowController.self)") as? AddCommandWindowController {
            addCommandController = windowController
            if let viewController = addCommandController?.contentViewController as? AddCommandViewController {
                viewController.setCurrentCommand(cmd: cmd)
            }
            self.view.window?.beginSheet((addCommandController?.window)!, completionHandler: { [self] response in
                if response == .OK {
                    if let viewController = addCommandController?.contentViewController as? AddCommandViewController {
                        if let _cmd = viewController.currentCommand {
                            CommandCenter.shared.replace(command: cmd, with: _cmd)
                            tableView?.reloadData()
                        }
                    }
                }
            })
        }
    }
}
extension CommandsViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return CommandCenter.shared.commands.count
    }
}
extension CommandsViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: tableColumn!.identifier.rawValue), owner: self) as? NSTableCellView {
            let commands = CommandCenter.shared.commands
            let cmd = commands[row]
            if tableColumn?.identifier.rawValue == "kEnabled" {
//                let cmd = commands[row]
//                cell.
            } else if tableColumn?.identifier.rawValue == "kTitle" {
                cell.textField?.stringValue = cmd.title
            } else if tableColumn?.identifier.rawValue == "kPath" {
                cell.textField?.stringValue = cmd.path
            } else if tableColumn?.identifier.rawValue == "kArguments" {
                cell.textField?.stringValue = cmd.arguments
            }
            else {
                cell.textField?.stringValue = "#na"
            }
            
            
            return cell;
        }
        return nil;
    }
}
