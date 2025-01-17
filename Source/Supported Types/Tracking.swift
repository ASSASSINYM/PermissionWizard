//
//  Tracking.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 03.12.2020.
//

#if TRACKING || !CUSTOM_SETTINGS

import AppTrackingTransparency

@available(iOS 14, *)
public extension Permission {
    
    final class tracking: SupportedType, Checkable, Requestable {
        
        public typealias Status = Permission.Status.Common
        
        // MARK: - Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSUserTrackingUsageDescription" }
        
        // MARK: - Public Functions
        
        public static func checkStatus(completion: @escaping (Status) -> Void) {
            let completion = Utils.linkToPreferredQueue(completion)
            
            switch ATTrackingManager.trackingAuthorizationStatus {
                case .authorized:
                    completion(.granted)
                case .denied:
                    completion(.denied)
                case .notDetermined:
                    completion(.notDetermined)
                case .restricted:
                    completion(.restrictedBySystem)
                
                @unknown default:
                    completion(.unknown)
            }
        }
        
        public static func requestAccess(completion: ((Status) -> Void)? = nil) throws {
            try Utils.checkIsAppConfigured(for: tracking.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            ATTrackingManager.requestTrackingAuthorization { _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}

#endif
