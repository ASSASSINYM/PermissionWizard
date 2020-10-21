//
//  Health.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 18.10.2020.
//

import HealthKit

public extension Permission {
    
    final class health: Base {
        
        public enum WritingStatus: String {
            
            case granted
            case denied
            
            case notDetermined
            case unknown
            
        }
        
        public static let usageDescriptionPlistKey: String? = "NSHealthUpdateUsageDescription"
        public static let writingUsageDescriptionPlistKey = "NSHealthShareUsageDescription"
        
        // MARK: - Public Functions
        
        public class func checkStatusForWriting(of dataType: HKObjectType, completion: (WritingStatus) -> Void) {
            switch HKHealthStore().authorizationStatus(for: dataType) {
                case .sharingAuthorized:
                    completion(.granted)
                case .sharingDenied:
                    completion(.denied)
                case .notDetermined:
                    completion(.notDetermined)
                
                @unknown default:
                    completion(.unknown)
            }
        }
        
        public class func requestAccess(forReading readingTypes: Set<HKObjectType>, writing writingTypes: Set<HKSampleType>, completion: (() -> Void)? = nil) {
            var plistKeys = !writingTypes.isEmpty ? [writingUsageDescriptionPlistKey] : []
            
            if !readingTypes.isEmpty, let plistKey = usageDescriptionPlistKey {
                plistKeys.append(plistKey)
            }
            
            guard Utils.checkIsAppConfigured(for: health.self, usageDescriptionsPlistKeys: plistKeys) else {
                return
            }
            
            HKHealthStore().requestAuthorization(toShare: writingTypes, read: readingTypes) { _, _ in
                completion?()
            }
        }
        
    }
    
}