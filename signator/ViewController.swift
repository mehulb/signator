//
//  ViewController.swift
//  signator
//
//  Created by Mehul Bhavani on 12/24/21.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet private var resultTextView            : NSTextView!
    @IBOutlet private var filePathControl           : NSPathControl!
    
    @IBOutlet private var teamIDLabel               : NSTextField!
    @IBOutlet private var supportedArchsLabel       : NSTextField!
    @IBOutlet private var minOSLabel                : NSTextField!
    @IBOutlet private var signingAuthorityLabel     : NSTextField!
    @IBOutlet private var extendedAttrLabel         : NSTextField!
    @IBOutlet private var bundleIDLabel             : NSTextField!
    @IBOutlet private var versionLabel              : NSTextField!
    
    @IBOutlet private var notarizedCheckBox         : NSButton!
    @IBOutlet private var appStoreCheckBox          : NSButton!
    @IBOutlet private var quarantineCheckBox        : NSButton!
    
    @IBOutlet private var activityIndicator         : NSProgressIndicator!
    
    @IBAction func checkBoxButton_StateChanged(_ sender: NSButton) {
        sender.state = sender.state == .on ? .off : .on
    }
    
    private var signator: Signator?

    override func viewDidLoad() {
        super.viewDidLoad()

        (self.view as! DDView).didDropFile { (filePath) in
            print("Dropped path: \(filePath)")
            self.check(filePath)
        }
    }
    
    func check(_ path: String) {
        startActivity()
        
        clearAll()
        signator = Signator(withPath: path)
        if let signator = signator {
            
            self.view.window?.setTitleWithRepresentedFilename(signator.fileInfo.fullname)
            self.view.window?.standardWindowButton(.documentIconButton)?.image = signator.fileInfo.icon
            filePathControl.url = signator.fileInfo.url
            
            signator.sign { cmd, msg, err in
                if let cmd = cmd {
                    self.appendCmd(cmd)
                }
                if let msg = msg {
                    self.appendMsg(msg)
                }
                if let err = err {
                    self.appendErr(err.localizedDescription)
                }
                
                self.updateUI(signator)
                
            } completion: { _, _, _ in
                self.stopActivity()
            }
            
        }
    }
    
    private func updateUI(_ signator: Signator) {
        DispatchQueue.main.async {
            self.teamIDLabel.stringValue = signator.fileInfo.teamIndentifier
            self.supportedArchsLabel.stringValue = signator.fileInfo.supportedArchs.joined(separator: ", ")
            self.minOSLabel.stringValue = signator.fileInfo.plistInfo?.minOSVersion ?? ""
            self.signingAuthorityLabel.stringValue = signator.fileInfo.signingAuthorities.joined(separator: "\n")
            self.extendedAttrLabel.stringValue = signator.fileInfo.extendedAttributes.joined(separator: "\n")
            self.bundleIDLabel.stringValue = signator.fileInfo.plistInfo?.bundleID ?? ""
            self.versionLabel.stringValue = "\(signator.fileInfo.plistInfo?.version ?? "0").\(signator.fileInfo.plistInfo?.build ?? "0")"
            
            self.notarizedCheckBox.state = signator.fileInfo.isNotarized ? .on : .off
            self.appStoreCheckBox.state = signator.fileInfo.isAppstoreApp ? .on : .off
            self.quarantineCheckBox.state = signator.fileInfo.extendedAttributes.contains("com.apple.quarantine") ? .on : .off
        }
    }
    
    private func appendCmd(_ cmd: String) {
        var attributes: [NSAttributedString.Key: Any]
        attributes = [.font: NSFont(name: "Courier", size: 14)!, .foregroundColor: NSColor.secondaryLabelColor]
        
        let attrString = NSAttributedString(string: cmd+"\n", attributes: attributes)
        DispatchQueue.main.async {
            self.resultTextView?.textStorage?.append(attrString)
            self.resultTextView?.scrollToEndOfDocument(nil)
        }
    }
    private func appendMsg(_ msg: String) {
        var attributes: [NSAttributedString.Key: Any]
        attributes = [.font: NSFont(name: "Courier New", size: 12)!, .foregroundColor: NSColor.labelColor]
        
        let attrString = NSAttributedString(string: msg+"\n", attributes: attributes)
        DispatchQueue.main.async {
            self.resultTextView?.textStorage?.append(attrString)
            self.resultTextView?.scrollToEndOfDocument(nil)
        }
    }
    private func appendErr(_ err: String) {
        var attributes: [NSAttributedString.Key: Any]
        attributes = [.font: NSFont(name: "Courier New", size: 12)!, .foregroundColor: NSColor.red]
        
        let attrString = NSAttributedString(string: err+"\n", attributes: attributes)
        DispatchQueue.main.async {
            self.resultTextView?.textStorage?.append(attrString)
            self.resultTextView?.scrollToEndOfDocument(nil)
        }
    }
    private func clearAll() {
        DispatchQueue.main.async {
            self.resultTextView.string = ""
        }
    }
    
    private func startActivity() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimation(self)
        }
    }
    private func stopActivity() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimation(self)
        }
    }
}

