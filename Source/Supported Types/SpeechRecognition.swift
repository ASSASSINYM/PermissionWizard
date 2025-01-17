//
//  SpeechRecognition.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 15.10.2020.
//

#if SPEECH_RECOGNITION || !CUSTOM_SETTINGS

import Speech

public extension Permission {
    
    final class speechRecognition: SupportedType, Checkable, Requestable {
        
        public typealias Status = Permission.Status.Common
        
        // MARK: - Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSSpeechRecognitionUsageDescription" }
        
        override class var contextName: String { "speech recognition" }
        
        // MARK: - Public Functions
        
        public static func checkStatus(completion: @escaping (Status) -> Void) {
            let completion = Utils.linkToPreferredQueue(completion)
            
            switch SFSpeechRecognizer.authorizationStatus() {
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
            try Utils.checkIsAppConfigured(for: speechRecognition.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            SFSpeechRecognizer.requestAuthorization() { _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}

#endif
