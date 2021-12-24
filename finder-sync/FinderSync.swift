//
//  FinderSync.swift
//  finder-sync
//
//  Created by Mehul Bhavani on 12/24/21.
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync {

    var myFolderURL = URL(fileURLWithPath: "/")
    
    override init() {
        super.init()
        
        NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)
        
        // Set up the directory we are syncing.
        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]
    }
    
    // MARK: - Primary Finder Sync protocol methods
    
    override func beginObservingDirectory(at url: URL) {
        // The user is now seeing the container's contents.
        // If they see it in more than one view at a time, we're only told once.
        NSLog("beginObservingDirectoryAtURL: %@", url.path as NSString)
    }
    
    
    override func endObservingDirectory(at url: URL) {
        // The user is no longer seeing the container's contents.
        NSLog("endObservingDirectoryAtURL: %@", url.path as NSString)
    }
    
    // MARK: - Menu and toolbar item support
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        // Produce a menu for the extension.
        let menu = NSMenu(title: "")
        let item = menu.addItem(withTitle: "Signator", action: #selector(sampleAction(_:)), keyEquivalent: "")
        item.image = NSImage(named: "icn_signator")
        
        return menu
    }
    
    @IBAction func sampleAction(_ sender: AnyObject?) {
        let items = FIFinderSyncController.default().selectedItemURLs()
        
        if let items = items {
            for item in items {
                if let url = URL(string: "sgntr://check?path=\(item.path)") {
                    NSWorkspace.shared.open(url)
                }
            }
        }
    }

}

