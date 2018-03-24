//
//  Scene.swift
//  ChikaAvatarUploader
//
//  Created by Mounir Ybanez on 2/24/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import ChikaCore
import Kingfisher

public final class Scene: UIViewController {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var selectedAvatarView: UIImageView!
    
    var theme: Theme!
    
    var imageUploader: (() -> (ImageUploader & Cancelable & Resumable & Pauseable))!
    var imageUploaderOperator: ImageUploaderOperator!
    
    var currentImageUploader: (ImageUploader & Cancelable & Resumable & Pauseable)?
    
    var imageFileURL: URL?
    
    var output: ((Result<URL>) -> Void)?
    var onProgress: ((Progress?) -> Void)?
    
    var state: State = .neutral {
        didSet {
            guard state != oldValue || state == .progressing(nil) else {
                return
            }
            
            switch state {
            case .neutral:
                break
            
            case .uploading(let uploader):
                currentImageUploader = uploader
            
            case .progressing(let progress):
                progressLabel.text = "\(Int((progress?.fractionCompleted ?? 0) * 100)) %"
                progressLabel.isHidden = false
                
                onProgress?(progress)
                
            case .completed(let result):
                switch result {
                case .ok:
                    avatarView.image = selectedAvatarView.image
                    
                case .err:
                    break
                }
                
                imageFileURL = nil
                progressLabel.isHidden = true
                currentImageUploader = nil
                
                clearSelectedAvatar()
                
                output?(result)
                
                state = .neutral
            }
        }
    }
    
    public override func loadView() {
        super.loadView()
        
        avatarView.layer.borderWidth = 1
        avatarView.layer.masksToBounds = true
        
        progressLabel.layer.masksToBounds = true
        
        selectedAvatarView.layer.borderWidth = 1
        selectedAvatarView.layer.masksToBounds = true
        
        let theme = Theme()
        
        progressLabel.font = theme.progressFont
        
        avatarView.layer.borderColor = theme.borderColor?.cgColor
        selectedAvatarView.layer.borderColor = theme.borderColor?.cgColor
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let font = theme?.progressFont {
            progressLabel.font = font
        }
        
        if let color = theme?.borderColor {
            avatarView.layer.borderColor = color.cgColor
            selectedAvatarView.layer.borderColor = color.cgColor
        }
    }
    
    public override func viewDidLayoutSubviews() {
        avatarView.layer.cornerRadius = min(avatarView.bounds.width, avatarView.bounds.height) / 2
        progressLabel.layer.cornerRadius = min(progressLabel.bounds.width, progressLabel.bounds.height) / 2
        selectedAvatarView.layer.cornerRadius = min(selectedAvatarView.bounds.width, selectedAvatarView.bounds.height) / 2
    }
    
    @discardableResult
    public func startUpload() -> Bool {
        guard state == .neutral, let image = getImageForUpload() else {
            return false
        }
        
        let uploader = imageUploader()
        state = .uploading(uploader)
        
        let ok = imageUploaderOperator.withImage({
            image
            
        }).onProgress({ [weak self] in
            self?.state = .progressing($0)
        
        }).withCompletion({ [weak self] in
            self?.state = .completed($0)
            
        }).uploadImage(using: uploader)
        
        return ok
    }
    
    @discardableResult
    public func cancelUpload() -> Bool {
        return currentImageUploader?.cancel() ?? false
    }
    
    @discardableResult
    public func resumeUpload() -> Bool {
        return currentImageUploader?.resume() ?? false
    }
    
    @discardableResult
    public func pauseUpload() -> Bool {
        return currentImageUploader?.pause() ?? false
    }
    
    @discardableResult
    public func clearSelectedAvatar() -> Bool {
        guard selectedAvatarView.image != nil else {
            return false
        }
        
        selectedAvatarView.image = nil
        return true
    }
    
    @discardableResult
    public func setAvatar(withDownloadURL url: URL?) -> Bool {
        guard url != nil else {
            return false
        }
        
        let resource = ImageResource(downloadURL: url!)
        avatarView.kf.setImage(
            with: resource,
            placeholder: #imageLiteral(resourceName: "avatar"),
            options: [ .cacheMemoryOnly ],
            progressBlock: nil,
            completionHandler: nil)
        
        return true
    }
    
    @IBAction func selectImage() {
        guard currentImageUploader == nil else {
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func getImageForUpload() -> UIImage? {
        guard state == .neutral,
            imageFileURL != nil,
            imageUploader != nil,
            currentImageUploader == nil,
            imageUploaderOperator != nil,
            let data = try? Data(contentsOf: imageFileURL!, options: []),
            let image = UIImage(data: data) else {
                return nil
        }
        
        return image
    }
    
    enum State: Equatable {
        
        case neutral
        case uploading(ImageUploader & Cancelable & Resumable & Pauseable)
        case completed(Result<URL>)
        case progressing(Progress?)
        
        var intValue: Int {
            switch self {
            case .neutral: return 0
            case .uploading: return 1
            case .completed: return 2
            case .progressing: return 3
            }
        }
        
        static func !=(lhs: Scene.State, rhs: Scene.State) -> Bool {
            return lhs.intValue != rhs.intValue
        }
        
        static func ==(lhs: Scene.State, rhs: Scene.State) -> Bool {
            return lhs.intValue == rhs.intValue
        }
        
    }
    
}

extension Scene: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true, completion: nil)
        }
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage, let url = info[UIImagePickerControllerImageURL] as? URL else {
            return
        }
        
        selectedAvatarView.image = image
        imageFileURL = url
    }
    
}
