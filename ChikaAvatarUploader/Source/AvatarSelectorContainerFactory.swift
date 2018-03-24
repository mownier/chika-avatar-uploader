//
//  AvatarSelectorContainerFactory.swift
//  ChikaAvatarUploader
//
//  Created by Mounir Ybanez on 3/24/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import ChikaUI

class AvatarSelectorContainerFactory {

    private var onDone: ((AvatarSelectorContainer, UIImage?) -> Void)?
    private var onCancel: ((AvatarSelectorContainer) -> Void)?
    
    init() {
    }
    
    func onDone(_ block: @escaping (AvatarSelectorContainer, UIImage?) -> Void) -> AvatarSelectorContainerFactory {
        onDone = block
        return self
    }
    
    func onCancel(_ block: @escaping (AvatarSelectorContainer) -> Void) -> AvatarSelectorContainerFactory {
        onCancel = block
        return self
    }
    
    func build() -> AvatarSelectorContainer {
        defer {
            onDone = nil
            onCancel = nil
        }
        
        let bundle = Bundle(for: AvatarSelectorContainerFactory.self)
        let storyboard = UIStoryboard(name: "AvatarUploader", bundle: bundle)
        let container = storyboard.instantiateViewController(withIdentifier: "AvatarSelectorContainer") as! AvatarSelectorContainer
        
        container.selector = AvatarSelectorViewControllerFactory().build()
        
        container.onDone = onDone
        container.onCancel = onCancel
        
        return container
    }
    
}
