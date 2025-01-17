//
//  LocalNetwork.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 31.10.2020.
//

#if (LOCAL_NETWORK || !CUSTOM_SETTINGS) && !targetEnvironment(macCatalyst)

import Network

@available(iOS 14, *)
public extension Permission {
    
    final class localNetwork: SupportedType {
        
        public typealias Status = Permission.Status.LocalNetwork
        
        private static var existingAgent: Agent?
        
        // MARK: - Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSLocalNetworkUsageDescription" }
        
        override class var contextName: String { "local network" }
        
        // MARK: - Public Functions
        
        /**
         Asks a user for access the permission type

         Due to limitations of default system API, you cannot wait for a user‘s decision, but you can get the current status of the permission at the time of the access request

         - Parameter servicePlistKey: A key of the Bonjour service, access to which you want to request. You must add a row with this key to your app‘s plist file, to a nested array with the key ”NSBonjourServices“.
         - Parameter completion: A block that will be invoked immidiately to return the current status of the permission. The invoke will occur in a dispatch queue that is set by ”Permission.preferredQueue“.
         - Throws: `Permission.Error`, if something went wrong. For example, your ”Info.plist“ is configured incorrectly.
        */
        public static func requestAccess(servicePlistKey: String, completion: ((Status) -> Void)? = nil) throws {
            try Utils.checkIsAppConfigured(for: localNetwork.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            let serviceArrayPlistKey = "NSBonjourServices"
            
            if let array = Bundle.main.object(forInfoDictionaryKey: serviceArrayPlistKey) as? [String], array.contains(servicePlistKey) { } else {
                let keyParent = (type: "array", ownKey: serviceArrayPlistKey)
                throw Utils.createInvalidAppConfigurationError(permissionName: contextName, missingPlistKey: servicePlistKey, keyParent: keyParent, isTechnicalKey: true)
            }
            
            if let existingAgent = existingAgent {
                if let completion = completion {
                    existingAgent.addCallback(completion)
                }
            } else {
                let manager = NetService(domain: "", type: servicePlistKey, name: "", port: 0)
                manager.publish()
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    manager.stop()
                }
                
                existingAgent = Agent(manager) { status in
                    completion?(status)
                    self.existingAgent = nil
                }
            }
        }
        
    }
    
}

#endif
