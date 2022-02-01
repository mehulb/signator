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
    
    private var path: String
    private var updateBlock: CodeBlock
    private var completionBlock: CodeBlock
    
    init(withPath path: String, update: @escaping CodeBlock, completion: @escaping CodeBlock) {
        self.path = path
        self.updateBlock = update
        self.completionBlock = completion
    }
    func sign() {
        for cmd in CommandCenter.shared.commands {
            let result = runShellCommand(withLaunchPath: cmd.path, arguments: [cmd.arguments, "\(path)"])
            updateBlock(cmd.title, result.message, nil)
        }
        completionBlock(nil, nil, nil)
    }
}

extension Signator {
    private func runShellCommand(withLaunchPath launchPath: String, arguments: [String], timeout: TimeInterval = 0) -> (status: Bool, message: String) {
        Logger.info("CMD: \(launchPath) \(arguments)")
        
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
        
        Logger.info("STS: \(_status)\nMSG: \(_message)")
        return (_status, _message)
    }
}

extension Process {
    func waitUntil(futureDate: Date) {
        while self.isRunning {
            if Date() > futureDate {
                Logger.info("ERR: task taking too long, terminate!")
                self.terminate()
            }
            Thread.sleep(forTimeInterval: 1.0)
        }
    }
}

