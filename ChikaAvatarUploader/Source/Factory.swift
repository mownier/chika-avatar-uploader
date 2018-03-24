//
//  Factory.swift
//  ChikaAvatarUploader
//
//  Created by Mounir Ybanez on 2/24/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import ChikaUI
import ChikaCore
import ChikaFirebase

public final class Factory {

    var theme: Theme?
    var output: ((Result<URL>) -> Void)?
    var onProgress: ((Progress?) -> Void)?
    
    var style: Style
    
    public init(style: Style) {
        self.style = style
        self.theme = Theme()
    }
    
    public func withTheme(_ block: @escaping () -> Theme) -> Factory {
        theme = block()
        return self
    }
    
    public func withOutput(_ block: @escaping (Result<URL>) -> Void) -> Factory {
        output = block
        return self
    }
    
    public func onProgress(_ block: @escaping (Progress?) -> Void) -> Factory {
        onProgress = block
        return self
    }
    
    public func build() -> Scene {
        defer {
            theme = nil
            output = nil
            onProgress = nil
        }
        
        let bundle = Bundle(for: Factory.self)
        let storyboard = UIStoryboard(name: "AvatarUploader", bundle: bundle)
        let scene = storyboard.instantiateInitialViewController() as! Scene
        
        scene.theme = theme
        scene.output = output
        scene.onProgress = onProgress
        
        let imageUploaderStyle: ChikaFirebase.ImageUploader.Style
        
        switch style {
        case .chat(let chatID):
            imageUploaderStyle = .chatAvatar(chatID)
            
        case .person:
            imageUploaderStyle = .personAvatar
        }
        
        scene.imageUploader = { ImageUploader(style: imageUploaderStyle) }
        scene.imageUploaderOperator = ImageUploaderOperation()
        
        scene.avatarSelector = {
            AvatarSelectorContainerFactory().onDone({ container, image in
                scene.selectedAvatarView.image = image
                container.dismiss(animated: true, completion: nil)
                
            }).onCancel({ container in
                container.dismiss(animated: true, completion: nil)
            
            }).build()
        }
        
        return scene
    }
}
