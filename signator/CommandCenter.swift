//
//  CommandCenter.swift
//  Signator
//
//  Created by Mehul Bhavani on 16/01/22.
//

import Foundation
import AppKit

struct Command: Codable {
    var id: String
    var isEnabled: Bool
    var title: String
    var path: String
    var arguments: String
    
    init(id: String = UUID().uuidString, isEnabled: Bool = true, title: String, path: String, arguments: String = "") {
        self.id = id
        self.isEnabled = isEnabled
        self.title = title
        self.path = path
        self.arguments = arguments
    }
    
    func dictionaryRepresentation() -> [String: Any] {
        return [
            "i": id,
            "e": isEnabled,
            "t": title,
            "p": path,
            "a": arguments
        ]
    }
}

extension Command {
    init?(obj: [String: Any]) {
        guard let id = obj["i"] as? String else {
            Logger.error("ID missing")
            return nil
        }
        guard let enabled = obj["e"] as? Bool else {
            Logger.error("isEnabled missing")
            return nil
        }
        guard let title = obj["t"] as? String else {
            Logger.error("Title missing")
            return nil
        }
        guard let path = obj["p"] as? String else {
            Logger.error("Path missing")
            return nil
        }
        guard let args = obj["a"] as? String else {
            Logger.error("Args missing")
            return nil
        }
        
        self.id = id
        self.isEnabled = enabled
        self.title = title
        self.path = path
        self.arguments = args
    }
}

class CommandCenter {
    
    private(set) var commands: [Command]
    
    private init() {
        commands = [
            Command(title: "spctl -av", path: "/usr/sbin/spctl", arguments: "-av"),
            Command(title: "xattr", path: "/usr/bin/xattr"),
            Command(title: "codesign -dvvvv", path: "/usr/bin/codesign", arguments: "-dvvvv"),
            Command(title: "otool -L", path: "/usr/bin/otool", arguments: "-L")
        ]
        NotificationCenter.default.addObserver(forName: NSApplication.willTerminateNotification, object: nil, queue: .main) { _ in
            self.writeCommands()
        }
    }
    
    static let shared: CommandCenter = {
        let center = CommandCenter()
        center.readCommands()
        //center.writeCommands()
        return center
    }()
    
    func replace(command oldCommand: Command?, with newCommand: Command?) {
        if let oldCommand = oldCommand {
            let index = commands.firstIndex {
                $0.id == oldCommand.id
            }
            if let index = index {
                if let newCommand = newCommand {
                    Logger.info("Update command!")
                    commands[index] = newCommand
                } else {
                    Logger.info("Remove command!")
                    commands.remove(at: index)
                }
            }
        } else if let newCommand = newCommand {
            Logger.info("Add command!")
            commands.append(newCommand)
        }
    }
}

extension CommandCenter {
    private func readCommands() {
        do {
            if let path = commandsFilePath {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                if let arr = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves]) as? [[String: Any]] {
                    commands.removeAll()
                    for obj in arr {
                        Logger.debug("\(obj)")
                        if let cmd  = Command(obj: obj) {
                            commands.append(cmd)
                        }
                    }
                }
//                Logger.debug("\(jsonObject)")
            }
        } catch {
            Logger.error("\(error)")
        }
    }
    private func writeCommands() {
        var cmdsArr = [[String: Any]]()
        for cmd in commands {
            cmdsArr.append(cmd.dictionaryRepresentation())
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: cmdsArr, options: [.prettyPrinted])
            if let path = commandsFilePath {
                Logger.info("Write commands to '\(path)'")
                let url = URL(fileURLWithPath: path)
                try data.write(to: url, options: [.atomicWrite])
            }
        } catch {
            Logger.error("\(error)")
        }
    }
    
    private var commandsFilePath: String? {
        if let path = getDocumentsDirectoryPath(for: "cmds.json") {
            if FileManager.default.fileExists(atPath: path) {
                return path
            } else if FileManager.default.createFile(atPath: path, contents: nil, attributes: nil) {
                return path
            }
        }
        Logger.error("Failed to get 'cmds.json' path!")
        return nil
    }
    private func getDocumentsDirectoryPath(for filename: String) -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if paths.count > 0 {
            var url = URL(fileURLWithPath: paths[0])
            url.appendPathComponent(filename)
            return url.path
        }
        return nil
    }
}
