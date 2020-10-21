//
//  Notifications.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 18.10.2020.
//

import UserNotifications

public extension Permission {
    
    final class notifications: Base {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            
            case provisionalOnly
            case ephemeralOnly
            
            case unknown
            
        }
        
        public static let usageDescriptionPlistKey: String? = nil
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: @escaping (Status) -> Void) {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                    case .authorized:
                        completion(.granted)
                    case .denied:
                        completion(.denied)
                    case .notDetermined:
                        completion(.notDetermined)
                    case .provisional:
                        completion(.provisionalOnly)
                    case .ephemeral:
                        completion(.ephemeralOnly)
                    
                    @unknown default:
                        completion(.unknown)
                }
            }
        }
        
        public class func requestAccess(options: UNAuthorizationOptions, completion: ((Status) -> Void)? = nil) {
            guard Utils.checkIsAppConfigured(for: notifications.self) else {
                return
            }
            
            UNUserNotificationCenter.current().requestAuthorization(options: options) { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}