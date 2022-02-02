//
//  ViewController.swift
//  signator
//
//  Created by Mehul Bhavani on 12/24/21.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet private var resultTextView: NSTextView?
    @IBOutlet private var activityView: NSProgressIndicator?
    @IBOutlet private var progressView: NSProgressIndicator?
    
    private var signator: Signator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.view as! DDView).didDropFile { (filePath) in
            Logger.info(filePath)
            self.check(filePath)
        }
    }
    
    func check(_ path: String) {
        activityView?.startAnimation(self)
        signator = Signator(withPath: path, update: { cmd, msg, err in
            DispatchQueue.main.async {
                if let cmd = cmd {
                    self.appendCmd(cmd)
                }
                if let msg = msg {
                    self.appendMsg(msg)
                }
                if let err = err {
                    self.appendErr(err.localizedDescription)
                }
            }
        }, completion: { _, _, _ in
            DispatchQueue.main.async {
                self.activityView?.stopAnimation(self)
            }
        })
        DispatchQueue.global(qos: .background).async {
            self.signator?.sign()
        }
    }
}

extension ViewController {
    private func appendCmd(_ cmd: String) {
        var attributes: [NSAttributedString.Key: Any]
        attributes = [.font: NSFont(name: "Courier", size: 18)!, .foregroundColor: NSColor.systemGreen]
        
        let attrString = NSAttributedString(string: cmd+"\n", attributes: attributes)
        DispatchQueue.main.async {
            self.resultTextView?.textStorage?.append(attrString)
            self.resultTextView?.scrollToEndOfDocument(nil)
        }
    }
    private func appendMsg(_ msg: String) {
        var attributes: [NSAttributedString.Key: Any]
        attributes = [.font: NSFont(name: "Courier", size: 14)!, .foregroundColor: NSColor.labelColor]
        
        let attrString = NSAttributedString(string: msg+"\n", attributes: attributes)
        DispatchQueue.main.async {
            self.resultTextView?.textStorage?.append(attrString)
            self.resultTextView?.scrollToEndOfDocument(nil)
        }
    }
    private func appendErr(_ err: String) {
        var attributes: [NSAttributedString.Key: Any]
        attributes = [.font: NSFont(name: "Courier", size: 14)!, .foregroundColor: NSColor.systemRed]
        
        let attrString = NSAttributedString(string: err+"\n", attributes: attributes)
        DispatchQueue.main.async {
            self.resultTextView?.textStorage?.append(attrString)
            self.resultTextView?.scrollToEndOfDocument(nil)
        }
    }
}

