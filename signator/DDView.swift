//
//  DDView.swift
//
//  Created by Mehul Bhavani on 28/10/20.
//  Copyright © 2020 MehulB. All rights reserved.
//

import Cocoa

class DDView: NSView {
    
    var validExtensions = [""]
    
    private var filePath: String?
    private var _completion: ((String) -> Void)?
    
    @IBOutlet private var messageBox: NSBox?
    @IBOutlet private var messageLabel: NSTextField?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        registerForDraggedTypes([NSPasteboard.PasteboardType.URL, NSPasteboard.PasteboardType.fileURL])
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func didDropFile(withCompletion completion: @escaping (String) -> Void) {
        _completion = completion
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        showMessageLabel()
        let result = checkExtension(sender)
        if result.0 {
            messageLabel?.stringValue = "Drop the \"\(result.1)\" here!"
            return .copy
        } else {
            messageLabel?.stringValue = "Invalid file format!"
            return NSDragOperation()
        }
    }
    override func draggingExited(_ sender: NSDraggingInfo?) {
        hideMessageLabel()
    }
    override func draggingEnded(_ sender: NSDraggingInfo) {
        if let completion = _completion, let filePath = filePath, !filePath.isEmpty {
           completion(filePath)
        }
    }
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = pasteboard[0] as? String
            else { return false }
        
        filePath = path
        hideMessageLabel()
        return true
    }
    
    private func checkExtension(_ drag: NSDraggingInfo) -> (Bool, String) {
        guard let board = drag.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = board[0] as? String
            else { return (false, "") }
        let fileURL = URL(fileURLWithPath: path)
        return (true, "\(fileURL.lastPathComponent)")
    }
    private func showMessageLabel() {
        messageBox?.frame = bounds
        messageBox?.isHidden = false
    }
    private func hideMessageLabel() {
        messageBox?.isHidden = true
    }
}
