//
//  ListViewController.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 03.10.2020.
//

import PermissionWizard
import UIKit

final class ListViewController: UIViewController {
    
    @IBOutlet private weak var buttonsContainer: UIStackView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Private Functions
    
    private func configure() {
        if #available(iOS 13.1, *) {
            addButton(for: Permission.bluetooth.self)
        }
        
        addButton(for: Permission.calendars.self)
        addButton(for: Permission.camera.self)
        addButton(for: Permission.contacts.self)
        
        if #available(iOS 11, *) {
            addButton(for: Permission.faceID.self)
        }
        
#if !targetEnvironment(macCatalyst)
        addButton(for: Permission.health.self)
        
        if #available(iOS 13, *) {
            addButton(for: Permission.home.self)
        }
#endif
        
        if #available(iOS 14, *) {
            addButton(for: Permission.localNetwork.self)
        }
        
        addButton(for: Permission.location.self)
        addButton(for: Permission.microphone.self)
        
        if #available(iOS 11, *) {
            addButton(for: Permission.motion.self)
        }
        
        addButton(for: Permission.music.self)
        addButton(for: Permission.notifications.self)
        addButton(for: Permission.photos.self)
        addButton(for: Permission.reminders.self)
        addButton(for: Permission.speechRecognition.self)
    }
    
    private func addButton(for permission: Permission.Type) {
        let header = PWHeader()
        header.permission = permission
        
        let button = PWButton()
        button.contentView = header
        
        button.action = {
            guard let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "Selection") as? DetailViewController else {
                return
            }
            
            detailViewController.permission = permission
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
        
        buttonsContainer.addArrangedSubview(button)
    }
    
}