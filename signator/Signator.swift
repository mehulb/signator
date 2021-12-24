//
//  Signator.swift
//  signator
//
//  Created by Mehul Bhavani on 12/24/21.
//

import Foundation

enum SignatorError: Error {
    case SignErr(_ errMsg: String)
}

class Signator {
//    private init() {}
//    static let shared = Signator()
    
    typealias CodeBlock = (String?, String?, Error?) -> Void
    
    private var _path: String?
    private var _updateBlock: CodeBlock?
    private var _completionBlock: CodeBlock?
    
    func sign(path: String, update: @escaping CodeBlock, completion: @escaping CodeBlock) {
        _path = path
        _updateBlock = update
        _completionBlock = completion
        
        if let _updateBlock = _updateBlock {
            _updateBlock("Filepath", "\(path)\n", nil)
        }
        
        checkSPCTL()
        checkXATTR()
        checkCODESIGN()
    }
    
    private func checkSPCTL() {
        if let path = _path, let update = _updateBlock {
            let result = runShellCommand(withLaunchPath: "/usr/sbin/spctl", arguments: ["-av", "\(path)"])
            update("spctl -av", result.message, nil)
        }
    }
    private func checkXATTR() {
        if let path = _path, let update = _updateBlock {
            let result = runShellCommand(withLaunchPath: "/usr/bin/xattr", arguments: ["\(path)"])
            update("xattr", result.message, nil)
        }
    }
    private func checkCODESIGN() {
        if let path = _path, let update = _updateBlock {
            let result = runShellCommand(withLaunchPath: "/usr/bin/codesign", arguments: ["-dvvvv", "\(path)"])
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
