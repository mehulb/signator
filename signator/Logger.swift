//
//  Logger.swift
//  SwiftLogger
//
//  Created by Sauvik Dolui on 03/05/2017.
//  Copyright © 2016 Innofied Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

// Enum for showing the type of Log Types
enum LogEvent: String {
    case error = "❌" // error
    case info = "💬" // info
    case debug = "🐞" // debug
    case verbose = "🔬" // verbose
    case warning = "⚠️" // warning
    case critical = "🔥" // critical
}

class Logger {
    private init() {}
    
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    class func error(_ message: String, fileName: String = #file, line: Int = #line, column: Int = #column, methodName: String = #function) {
        _print(message: message, event: LogEvent.error, fileName: fileName, line: line, column: column, methodName: methodName)
    }
    class func info(_ message: String, fileName: String = #file, line: Int = #line, column: Int = #column, methodName: String = #function) {
        _print(message: message, event: LogEvent.info, fileName: fileName, line: line, column: column, methodName: methodName)
    }
    class func debug(_ message: String, fileName: String = #file, line: Int = #line, column: Int = #column, methodName: String = #function) {
        _print(message: message, event: LogEvent.debug, fileName: fileName, line: line, column: column, methodName: methodName)
    }
    class func verbose(_ message: String, fileName: String = #file, line: Int = #line, column: Int = #column, methodName: String = #function) {
        _print(message: message, event: LogEvent.verbose, fileName: fileName, line: line, column: column, methodName: methodName)
    }
    class func warning(_ message: String, fileName: String = #file, line: Int = #line, column: Int = #column, methodName: String = #function) {
        _print(message: message, event: LogEvent.warning, fileName: fileName, line: line, column: column, methodName: methodName)
    }
    class func critical(_ message: String, fileName: String = #file, line: Int = #line, column: Int = #column, methodName: String = #function) {
        _print(message: message, event: LogEvent.critical, fileName: fileName, line: line, column: column, methodName: methodName)
    }
    
    
    private class func _print(message: String, event: LogEvent, fileName: String, line: Int, column: Int, methodName: String) {
//        #if DEBUG
        print("[\(event.rawValue)][\(sourceFileName(filePath: fileName))->\(methodName)][L:\(line)|C:\(column)] \(message)")
//        #endif
    }
    
    private class func log(message: String, event: LogEvent, fileName: String = #file, line: Int = #line, column: Int = #column, methodName: String = #function) {
//        #if DEBUG
        print("\(Date().toString()) [\(event.rawValue)][\(sourceFileName(filePath: fileName))]:{L:\(line)|C:\(column)} \(methodName) -> \(message)")
//        #endif
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let filename = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
        return filename
    }
}

internal extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
