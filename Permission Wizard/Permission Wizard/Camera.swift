//
//  Camera.swift
//  Permission Wizard
//
//  Created by Sergey Moskvin on 17.10.2020.
//

#if CAMERA || !CUSTOM_SETTINGS

import AVKit

public extension Permission {
    
    final class camera: Permission {
        
        public enum NarrowStatus: String {
            
            case granted
            case denied
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        public typealias CombinedStatus = (camera: NarrowStatus, microphone: microphone.Status?)
        
        public override class var usageDescriptionPlistKey: String? { "NSCameraUsageDescription" }
        
        // MARK: - Public Functions
        
        public class func checkStatus(withMicrophone: Bool, completion: @escaping (CombinedStatus) -> Void) {
            let narrow: NarrowStatus
            
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized:
                    narrow = .granted
                case .denied:
                    narrow = .denied
                case .notDetermined:
                    narrow = .notDetermined
                case .restricted:
                    narrow = .restrictedBySystem
                
                @unknown default:
                    narrow = .unknown
            }
            
            var combined = CombinedStatus(camera: narrow, microphone: nil)
            
            if withMicrophone {
                microphone.checkStatus { status in
                    combined.microphone = status
                    completion(combined)
                }
            } else {
                let completion = Utils.linkToPreferredQueue(completion)
                completion(combined)
            }
        }
        
        public class func requestAccess(withMicrophone: Bool, completion: ((CombinedStatus) -> Void)? = nil) {
            var checklist: [Permission.Type] = [camera.self]
            
            if withMicrophone {
                checklist.append(microphone.self)
            }
            
            guard checklist.allSatisfy({ Utils.checkIsAppConfigured(for: $0) }) else {
                return
            }
            
            AVCaptureDevice.requestAccess(for: .video) { _ in
                guard completion != nil || withMicrophone else {
                    return
                }
                
                checkStatus(withMicrophone: false) { combined in
                    if withMicrophone {
                        microphone.requestAccess { status in
                            var combined = combined
                            combined.microphone = status
                            
                            completion?(combined)
                        }
                    } else {
                        completion?(combined)
                    }
                }
            }
        }
        
    }
    
}

#endif