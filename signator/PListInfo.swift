//
//  PListInfo.swift
//  Signator
//
//  Created by Mehul Bhavani on 08/07/22.
//

import Foundation
import AppKit

struct PListInfo {
    enum PrivacyPermissionKeys {
        
        enum Bluetooth: String {
            case `default` = "NSBluetoothAlwaysUsageDescription"
            case peripheral = "NSBluetoothPeripheralUsageDescription"
            
            func name() -> String {
                switch self {
                    case .default:      return "Privacy - Bluetooth Always Usage Description"
                    case .peripheral:   return "Privacy - Bluetooth Peripheral Usage Description"
                }
            }
        }
        
        enum CalendarReminders: String {
            case calendars = "NSCalendarsUsageDescription"
            case reminder = "NSRemindersUsageDescription"
            
            func name() -> String {
                switch self {
                    case .calendars:    return "Privacy - Calendars Usage Description"
                    case .reminder:     return "Privacy - Reminders Usage Description"
                }
            }
        }
        
        enum CameraMicrophone: String {
            case camera = "NSCameraUsageDescription"
            case microphone = "NSMicrophoneUsageDescription"
            
            func name() -> String {
                switch self {
                    case .camera:       return "Privacy - Camera Usage Description"
                    case .microphone:   return "Privacy - Microphone Usage Description"
                }
            }
        }
        
        enum Contacts: String {
            case `default` = "NSContactsUsageDescription"
            
            func name() -> String {
                switch self {
                    case .default: return "Privacy - Contacts Usage Description"
                }
            }
        }
        
        enum FaceID: String {
            case `default` = "NSFaceIDUsageDescription"
            
            func name() -> String {
                switch self {
                    case .default: return "Privacy - Face ID Usage Description"
                }
            }
        }
        
        enum FilesFolders: String {
            case desktop = "NSDesktopFolderUsageDescription"
            case documents = "NSDocumentsFolderUsageDescription"
            case downloads = "NSDownloadsFolderUsageDescription"
            case networkVolumes = "NSNetworkVolumesUsageDescription"
            case removableVolumes = "NSRemovableVolumesUsageDescription"
            case fileProvider = "NSFileProviderDomainUsageDescription"
            
            func name() -> String {
                switch self {
                    case .desktop:          return "Privacy - Desktop Folder Usage Description"
                    case .documents:        return "Privacy - Documents Folder Usage Description"
                    case .downloads:        return "Privacy - Downloads Folder Usage Description"
                    case .networkVolumes:   return "Privacy - Network Volumes Usage Description"
                    case .removableVolumes: return "Privacy - Removable Volumes Usage Description"
                    case .fileProvider:     return "Privacy - Access to a File Provider Domain Usage Description"
                }
            }
        }
        
        enum GameCenter: String {
            case `default` = "NSGKFriendListUsageDescription"
            
            func name() -> String {
                switch self {
                    case .default: return "NSGKFriendListUsageDescription"
                }
            }
        }
        
        enum Health: String {
            case clinical = "NSHealthClinicalHealthRecordsShareUsageDescription"
            case share = "NSHealthShareUsageDescription"
            case update = "NSHealthUpdateUsageDescription"
            case requiredRead = "NSHealthRequiredReadAuthorizationTypeIdentifiers"
            
            func name() -> String {
                switch self {
                    case .clinical:     return "Privacy - Health Records Usage Description"
                    case .share:        return "Privacy - Health Share Usage Description"
                    case .update:       return "Privacy - Health Update Usage Description"
                    case .requiredRead: return "NSHealthRequiredReadAuthorizationTypeIdentifiers"
                }
            }
        }
        
        enum Home: String {
            case homeKit = "NSHomeKitUsageDescription"
            
            func name() -> String {
                switch self {
                    case .homeKit: return "Privacy - HomeKit Usage Description"
                }
            }
        }
        
        enum Location: String {
            case alwaysWhenInUse = "NSLocationAlwaysAndWhenInUseUsageDescription"
            case `default` = "NSLocationUsageDescription"
            case whenInUse = "NSLocationWhenInUseUsageDescription"
            case temporary = "NSLocationTemporaryUsageDescriptionDictionary"
            case widget = "NSWidgetWantsLocation"
            case accuracyReduced = "NSLocationDefaultAccuracyReduced"
            case always = "NSLocationAlwaysUsageDescription"
            
            func name() -> String {
                switch self {
                    case .alwaysWhenInUse:  return "Privacy - Location Always and When In Use Usage Description"
                    case .default:          return "Privacy - Location Usage Description"
                    case .whenInUse:        return "Privacy - Location When In Use Usage Description"
                    case .temporary:        return "Privacy - Location Temporary Usage Description Dictionary"
                    case .widget:           return "Widget wants location"
                    case .accuracyReduced:  return "Privacy - Location Default Accuracy Reduced"
                    case .always:           return "Privacy - Location Always Usage Description"
                }
            }
        }
        
        enum MediaPlayer: String {
            case appleMusic = "NSAppleMusicUsageDescription"
            
            func name() -> String {
                switch self {
                    case .appleMusic: return "Privacy - Media Library Usage Description"
                }
            }
        }
        
        enum Motion: String {
            case `default` = "NSMotionUsageDescription"
            case fallDetection = "NSFallDetectionUsageDescription"
            
            func name() -> String {
                switch self {
                    case .default:          return "Privacy - Motion Usage Description"
                    case .fallDetection:    return "Fall Detection Usage Description"
                }
            }
        }
        
        enum Networking: String {
            case local = "NSLocalNetworkUsageDescription"
            case nearby = "NSNearbyInteractionUsageDescription"
            case nearbyOnce = "NSNearbyInteractionAllowOnceUsageDescription"
            
            func name() -> String {
                switch self {
                    case .local:        return "Privacy - Local Network Usage Description"
                    case .nearby:       return "Privacy - Nearby Interaction Usage Description"
                    case .nearbyOnce:   return "Privacy - Nearby Interaction Allow Once Usage Description"
                }
            }
        }
        
        enum NFC: String {
            case `default` = "NFCReaderUsageDescription"
            
            func name() -> String {
                switch self {
                    case .default: return "Privacy - NFC Scan Usage Description"
                }
            }
        }
        
        enum Photos: String {
            case libraryAdd = "NSPhotoLibraryAddUsageDescription"
            case library = "NSPhotoLibraryUsageDescription"
            
            func name() -> String {
                switch self {
                    case .libraryAdd:   return "Privacy - Photo Library Additions Usage Description"
                    case .library:      return "Privacy - Photo Library Usage Description"
                }
            }
        }
        
        enum Scripting: String {
            case appleScript = "NSAppleScriptEnabled"
            
            func name() -> String {
                switch self {
                    case .appleScript: return "Scriptable"
                }
            }
        }
        
        enum Security: String {
            case userTracking = "NSUserTrackingUsageDescription"
            case appleEvents = "NSAppleEventsUsageDescription"
            case systemAdmin = "NSSystemAdministrationUsageDescription"
            case nonExemptEncryption = "ITSAppUsesNonExemptEncryption"
            case encryptionExport = "ITSEncryptionExportComplianceCode"
            
            func name() -> String {
                switch self {
                    case .userTracking:         return "Privacy - Tracking Usage Description"
                    case .appleEvents:          return "Privacy - AppleEvents Sending Usage Description"
                    case .systemAdmin:          return "Privacy - System Administration Usage Description"
                    case .nonExemptEncryption:  return "App Uses Non-Exempt Encryption"
                    case .encryptionExport:     return "App Encryption Export Compliance Code"
                }
            }
        }
        
        enum Sensors: String {
            case description = "NSSensorKitUsageDescription"
            case detail = "NSSensorKitUsageDetail"
            case privacyPolicyURL = "NSSensorKitPrivacyPolicyURL"
            
            func name() -> String {
                switch self {
                    case .description:      return "NSSensorKitUsageDescription"
                    case .detail:           return "NSSensorKitUsageDetail"
                    case .privacyPolicyURL: return "NSSensorKitPrivacyPolicyURL"
                }
            }
        }
        
        enum Siri: String {
            case `default` = "NSSiriUsageDescription"
            
            func name() -> String {
                switch self {
                    case .default: return "Privacy - Siri Usage Description"
                }
            }
        }
        
        enum Speech: String {
            case `default` = "NSSpeechRecognitionUsageDescription"
            
            func name() -> String {
                switch self {
                    case .default: return "Privacy - Speech Recognition Usage Description"
                }
            }
        }
        
        enum TV: String {
            case videoSubscriberAccount = "NSVideoSubscriberAccountUsageDescription"
            
            func name() -> String {
                switch self {
                    case .videoSubscriberAccount: return "Privacy - Video Subscriber Account Usage Description"
                }
            }
        }
        
        enum WiFi: String {
            case requiresPersistantWiFi = "UIRequiresPersistentWiFi"
            
            func name() -> String {
                switch self {
                    case .requiresPersistantWiFi: return "Application uses Wi-Fi"
                }
            }
        }
        
        static func allKeys() -> [String] {
            return [
                Bluetooth.default.rawValue,
                Bluetooth.peripheral.rawValue,
                
                CalendarReminders.calendars.rawValue,
                CalendarReminders.reminder.rawValue,
                
                CameraMicrophone.camera.rawValue,
                CameraMicrophone.microphone.rawValue,
                
                Contacts.default.rawValue,
                
                FaceID.default.rawValue,
                
                FilesFolders.desktop.rawValue,
                FilesFolders.documents.rawValue,
                FilesFolders.downloads.rawValue,
                FilesFolders.networkVolumes.rawValue,
                FilesFolders.removableVolumes.rawValue,
                FilesFolders.fileProvider.rawValue,
                
                GameCenter.default.rawValue,
                
                Health.clinical.rawValue,
                Health.share.rawValue,
                Health.update.rawValue,
                Health.requiredRead.rawValue,
                
                Home.homeKit.rawValue,
                
                Location.default.rawValue,
                Location.always.rawValue,
                Location.alwaysWhenInUse.rawValue,
                Location.accuracyReduced.rawValue,
                Location.widget.rawValue,
                Location.temporary.rawValue,
                Location.whenInUse.rawValue,
                
                MediaPlayer.appleMusic.rawValue,
                
                Motion.default.rawValue,
                Motion.fallDetection.rawValue,
                
                Networking.nearbyOnce.rawValue,
                Networking.nearby.rawValue,
                Networking.local.rawValue,
                
                NFC.default.rawValue,
                
                Photos.library.rawValue,
                Photos.libraryAdd.rawValue,
                
                Scripting.appleScript.rawValue,
                
                Security.encryptionExport.rawValue,
                Security.nonExemptEncryption.rawValue,
                Security.systemAdmin.rawValue,
                Security.appleEvents.rawValue,
                Security.userTracking.rawValue,
                
                Sensors.privacyPolicyURL.rawValue,
                Sensors.detail.rawValue,
                Sensors.description.rawValue,
                
                Siri.default.rawValue,
                
                Speech.default.rawValue,
                
                TV.videoSubscriberAccount.rawValue,
                
                WiFi.requiresPersistantWiFi.rawValue
            ]
        }
    }
    
    private var _path: String
    
    var privacyInfo: [String]?
    var minOSVersion: String?
    var bundleID: String?
    var version: String?
    var build: String?
    
    init?(_ path: String) {
        _path = path
        
        print(_path)
        
        let url = URL(fileURLWithPath: _path)
        do {
            let data = try Data(contentsOf: url)
            if let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String: Any] {
//                print(plist)
                bundleID = plist["CFBundleIdentifier"] as? String
                version = plist["CFBundleShortVersionString"] as? String
                build = plist["CFBundleVersion"] as? String
                minOSVersion = plist["LSMinimumSystemVersion"] as? String
                
            } else {
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
