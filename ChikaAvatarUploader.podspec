Pod::Spec.new do |s|
  s.name     = 'ChikaSignIn'
  s.version  = '0.0.3'
  s.summary  = 'Sign In Module for Chika'
  s.platform = :ios, '11.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage = 'https://github.com/mownier/chika-signin'
  s.author   = { 'Mounir Ybanez' => 'rinuom91@gmail.com' }
  s.source   = { :git => 'https://github.com/mownier/chika-signin.git', :tag => s.version.to_s }
  s.source_files = 'ChikaSignIn/Source/*.swift'
  s.resources = ['ChikaSignIn/Source/SignIn.storyboard']
  s.requires_arc = true
  s.dependency 'ChikaFirebase/Auth:SignIn'
  s.dependency 'ChikaFirebase/Writer:OnlinePresenceSwitcher'
end
