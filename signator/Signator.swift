//
//  Signator.swift
//  signator
//
//  Created by Mehul Bhavani on 12/24/21.
//

import Foundation

enum SignatorError: Error {
    case InvalidFilePath
    case UpdateBlockMissing
    case CompletionBlockMissing
    case msg(_ : String)
}

class Signator {
    typealias CodeBlock = (String?, String?, Error?) -> Void
    
    var fileInfo: FileInfo
    private var _updateBlock: CodeBlock?
    private var _completionBlock: CodeBlock?
    
    required init(withPath path: String) {
        fileInfo = FileInfo(withURL: URL(fileURLWithPath: path))
    }
    
    func sign(update: @escaping CodeBlock, completion: @escaping CodeBlock) {
        _updateBlock = update
        _completionBlock = completion
        
        checkSPCTL()
        checkXATTR()
        checkCODESIGN()
        
        completion(nil, nil, nil)
    }
    
    private func checkSPCTL() {
        if let update = _updateBlock {
            let result = runShellCommand(withLaunchPath: "/usr/sbin/spctl", arguments: ["-av", "\(fileInfo.url.path)"])
            if result.message.contains("Notarized Developer ID") {
                fileInfo.isNotarized = true
            } else if result.message.contains("Mac App Store") {
                fileInfo.isAppstoreApp = true
            }
            
            update("spctl -av", result.message, nil)
        }
    }
    private func checkXATTR() {
        if let update = _updateBlock {
            let result = runShellCommand(withLaunchPath: "/usr/bin/xattr", arguments: ["\(fileInfo.url.path)"])
            let attrs = result.message.replacingOccurrences(of: "\(fileInfo.url.path): ", with: "")
            fileInfo.extendedAttributes = attrs.components(separatedBy: "\n")
            
            update("xattr", result.message, nil)
        }
    }
    private func checkCODESIGN() {
        if let update = _updateBlock {
            let result = runShellCommand(withLaunchPath: "/usr/bin/codesign", arguments: ["-dvvvv", "\(fileInfo.url.path)"])
            
            let lines = result.message.components(separatedBy: "\n")
            lines.forEach { line in
                if line.contains("Format=") {
                    if line.contains("x86_64") {
                        fileInfo.supportedArchs.append("Intel")
                    }
                    if line.contains("arm64") {
                        fileInfo.supportedArchs.append("Apple Silicon")
                    }
                }
                if line.contains("Authority=") {
                    let authority = line.replacingOccurrences(of: "Authority=", with: "")
                    fileInfo.signingAuthorities.append(authority)
                }
                if line.contains("TeamIdentifier=") {
                    fileInfo.teamIndentifier = line.replacingOccurrences(of: "TeamIdentifier=", with: "")
                }
            }
            
            
            update("codesign -dvvvv", result.message, nil)
        }
    }
}

extension Signator {
    private func runShellCommand(withLaunchPath launchPath: String, arguments: [String], timeout: TimeInterval = 0) -> (status: Bool, message: String) {
        print("CMD: \(launchPath) \(arguments)")
        
        var _status = true
        var _message = ""
        
        let task = Process()
        let outPipe = Pipe()
        let errPipe = Pipe()
        task.launchPath = launchPath
        task.arguments = arguments
        task.standardOutput = outPipe
        task.standardError = errPipe
        task.launch()
        if timeout > 0 {
            task.waitUntil(futureDate: Date().addingTimeInterval(timeout))
        }
        task.waitUntilExit()
        
        if task.terminationStatus != 0 {
            _status = false
            _message = "\(task.terminationReason.rawValue)"
        }
        let errData = errPipe.fileHandleForReading.readDataToEndOfFile()
        if !errData.isEmpty, let err = (String(data: errData, encoding: .utf8)) {
            _status = false
            _message = err
        }
        
        let data = outPipe.fileHandleForReading.readDataToEndOfFile()
        if !data.isEmpty, let msg = (String(data: data, encoding: .utf8)) {
            _status = true
            _message = msg
        }
        
        print("STS: \(_status)\nMSG: \(_message)")
        return (_status, _message)
    }
}

extension Process {
    func waitUntil(futureDate: Date) {
        while self.isRunning {
            if Date() > futureDate {
                print("ERR: task taking too long, terminate!")
                self.terminate()
            }
            Thread.sleep(forTimeInterval: 1.0)
        }
    }
}

