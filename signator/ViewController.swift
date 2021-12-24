//
//  ViewController.swift
//  signator
//
//  Created by Mehul Bhavani on 12/24/21.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet private var resultTextView: NSTextView!
    private var signator: Signator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signator = Signator()

        (self.view as! DDView).didDropFile { (filePath) in
            print("Dropped path: \(filePath)")
            self.check(filePath)
        }
    }
    
    func check(_ path: String) {
        if let signator = signator {
            signator.sign(path: path) { cmd, msg, err in
                if let cmd = cmd {
                    self.appendCmd(cmd)
                }
                if let msg = msg {
                    self.appendMsg(msg)
                }
                if let err = err {
                    self.appendErr(err.localizedDescription)
                }
            } completion: { _, _, _ in
                
            }

        }
    }
    
    private func appendCmd(_ cmd: String) {
        var attributes: [NSAttributedString.Key: Any]
        attributes = [.font: NSFont(name: "Courier", size: 14)!, .foregroundColor: NSColor.labelColor]
        
        let attrString = NSAttributedString(string: cmd+"\n", attributes: attributes)
        DispatchQueue.main.async {
            self.resultTextView?.textStorage?.append(attrString)
            self.resultTextView?.scrollToEndOfDocument(nil)
        }
    }
    private func appendMsg(_ msg: String) {
        var attributes: [NSAttributedString.Key: Any]
        attributes = [.font: NSFont(name: "Courier", size: 14)!, .foregroundColor: NSColor.secondaryLabelColor]
        
        let attrString = NSAttributedString(string: msg+"\n", attributes: attributes)
        DispatchQueue.main.async {
            self.resultTextView?.textStorage?.append(attrString)
            self.resultTextView?.scrollToEndOfDocument(nil)
        }
    }
    private func appendErr(_ err: String) {
        var attributes: [NSAttributedString.Key: Any]
        attributes = [.font: NSFont(name: "Courier", size: 14)!, .foregroundColor: NSColor.red]
        
        let attrString = NSAttributedString(string: err+"\n", attributes: attributes)
        DispatchQueue.main.async {
            self.resultTextView?.textStorage?.append(attrString)
            self.resultTextView?.scrollToEndOfDocument(nil)
        }
    }
}

