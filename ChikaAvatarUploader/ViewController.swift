//
//  ViewController.swift
//  ChikaAvatarUploader
//
//  Created by Mounir Ybanez on 2/24/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import ChikaCore
import ChikaFirebase

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    var scene: Scene!
    
    override func loadView() {
        super.loadView()
        
        let factory = Factory(style: .person)
        scene = factory.onProgress({
            print($0?.fractionCompleted ?? 0)
            
        }).withOutput({
            print($0)
            
        }).build()
        
        containerView.addSubview(scene.view)
        addChildViewController(scene)
        scene.didMove(toParentViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene.setAvatar(withDownloadURL: URL(string: ""))
    }
    
    override func viewDidLayoutSubviews() {
        scene.view.frame = containerView.bounds
    }

    @IBAction func go(_ sender: UIBarButtonItem) {
        scene.startUpload()
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        let switcher = OfflinePresenceSwitcher()
        let _ = switcher.switchToOffline { result in
            print("[ChikaFirebase/Writer:OfflinePresenceSwitcher]", result)
        }
        
        let action = SignOut()
        let operation = SignOutOperation()
        let _ = operation.withCompletion({ result in
            switch result {
            case .ok(let ok):
                print("[ChikaFirebase/Auth:SignOut]", ok)
                showSignIn()
                
            case .err(let error):
                showAlert(withTitle: "Error", message: "\(error)", from: self)
            }
            
        }).signOut(using: action)
    }
    
}

