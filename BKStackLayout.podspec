Pod::Spec.new do |s|
  s.name         = "BKStackLayout"
  s.version      = "1.0.0"
  s.summary      = "BKStackLayout is a tiny utility library wrapping UIStackView or NSStackView."
  s.homepage     = "https://github.com/ReactComponentKit/BKStackLayout"
  s.license      = "MIT"
  s.author             = { "Burt.K" => "skyfe79@gmail.com" }
  s.social_media_url   = "http://twitter.com/skyfe79"
  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.10"
  s.swift_version         = "4.2"
  s.source       = { :git => "https://github.com/ReactComponentKit/BKStackLayout.git", :tag => "#{s.version}" }
  s.source_files  = "BKStackLayout/**/{*.swift}"
  s.requires_arc = true
end