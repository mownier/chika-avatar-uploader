Pod::Spec.new do |s|
  s.name     = 'ChikaAvatarUploader'
  s.version  = '0.0.1'
  s.summary  = 'Avatar uploader feature for Chika'
  s.platform = :ios, '11.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage = 'https://github.com/mownier/chika-avatar-uploader'
  s.author   = { 'Mounir Ybanez' => 'rinuom91@gmail.com' }
  s.source   = { :git => 'https://github.com/mownier/chika-avatar-uploader.git', :tag => s.version.to_s }
  s.source_files = 'ChikaAvatarUploader/Source/*.swift'
  s.resources = ['ChikaAvatarUploader/Source/AvatarUploader.storyboard']
  s.requires_arc = true
  
  s.swift_version = '4.0'

  s.dependency 'ChikaUI'
  s.dependency 'ChikaAssets'
  s.dependency 'ChikaFirebase/Writer:ImageUploader'

  s.dependency 'Kingfisher'
end
