//
//  Theme.swift
//  ChikaAvatarUploader
//
//  Created by Mounir Ybanez on 2/24/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

public final class Theme {

    public var borderColor: UIColor?
    public var progressFont: UIFont?
    
    public init() {
        self.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.progressFont = UIFont.boldSystemFont(ofSize: 20.0)
    }
    
}
