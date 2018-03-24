//
//  AvatarSelectorContainer.swift
//  ChikaAvatarUploader
//
//  Created by Mounir Ybanez on 3/24/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import ChikaUI

class AvatarSelectorContainer: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    var selector: AvatarSelectorViewController!
    
    var onDone: ((AvatarSelectorContainer, UIImage?) -> Void)?
    var onCancel: ((AvatarSelectorContainer) -> Void)?
    
    override func loadView() {
        super.loadView()
        
        guard selector != nil else {
            return
        }
        
        containerView.addSubview(selector.view)
        addChildViewController(selector)
        selector.didMove(toParentViewController: self)
    }
    
    override func viewDidLayoutSubviews() {
        guard selector != nil else {
            return
        }
        
        selector.view.frame = containerView.bounds
    }
    
    @IBAction func cancel() {
        onCancel?(self)
    }
    
    @IBAction func done() {
        onDone?(self, selector.avatarImage)
    }
    
}
