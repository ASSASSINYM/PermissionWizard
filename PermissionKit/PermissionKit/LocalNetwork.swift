//
//  LocalNetwork.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 31.10.2020.
//

import Network

public extension Permission {
    
    final class localNetwork: Base {
        
        public class override var contextName: String { return "local network" }
        public class override var usageDescriptionPlistKey: String? { "NSLocalNetworkUsageDescription" }
        
        // MARK: - Public Functions
        
        public class func requestAccess(servicePlistKey: String) {
            guard Utils.checkIsAppConfiguredForLocalNetworkAccess(servicePlistKey: servicePlistKey) else {
                return
            }
            
            let serviceDescriptor = NWBrowser.Descriptor.bonjour(type: servicePlistKey, domain: nil)
            let parameters = NWParameters()
            
            let browser = NWBrowser(for: serviceDescriptor, using: parameters)
            browser.stateUpdateHandler = { _ in }
            
            browser.start(queue: .main)
        }
        
    }
    
}
