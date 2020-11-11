//
//  MicrophonePanel.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 09.11.2020.
//

import PermissionWizard

final class MicrophonePanel: Panel<Permission.microphone> {
    
    override func configure() {
        super.configure()
        
        addDefaultButtons(checkStatusAction: {
            self.permission.checkStatus { self.notify($0.rawValue) }
        }, requestAccessAction: {
            self.permission.requestAccess { self.notify($0.rawValue) }
        })
    }
    
}