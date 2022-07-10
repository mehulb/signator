//
//  FileInfo.swift
//  Signator
//
//  Created by Mehul Bhavani on 29/06/22.
//

import Foundation
import AppKit

class FileInfo {
    var name: String
    var fullname: String
    var url: URL
    var icon: NSImage
//    var type: String
    
    var teamIndentifier =  ""
    var signingAuthorities = [String]()
    var supportedArchs = [String]()
    var isNotarized = false
    var isAppstoreApp = false
    
    var extendedAttributes = [String]()
    
    var plistInfo: PListInfo?
    
    init(withURL fileUrl: URL) {
        url = fileUrl
        name = fileUrl.deletingPathExtension().lastPathComponent
        fullname = fileUrl.lastPathComponent
        icon = NSWorkspace.shared.icon(forFile: url.path)
        
        plistInfo = PListInfo(url.appendingPathComponent("Contents").appendingPathComponent("Info.plist").path)
    }
}
