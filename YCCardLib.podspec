Pod::Spec.new do |s|

  s.name         = "YCCardLib"
  s.version      = "0.1.2"
  s.summary      = "YComplex Card Library."

  s.description  = <<-DESC
                    YComplex Card Library for developing swipe-card based applications.
                   DESC

  s.homepage     = "http://github.com/ycomplex/YCCardLib"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "akshayrangnekar" => "akshay@ycomplex.com" }
  s.social_media_url   = "http://twitter.com/akshayr"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform = :ios
  s.ios.deployment_target = '8.0'


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/ycomplex/YCCardLib.git", :tag => "#{s.version}" }
  s.source_files = "YCCardLib/**/*.{swift}"
 
  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.resources = "YCCardLib/**/*.{png,jpeg,jpg,storyboard,xib}"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.framework = "UIKit"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true
  # s.dependency 'Alamofire', '~> 2.0'
  # s.dependency 'MBProgressHUD', '~> 0.9.0'
  # s.dependency "JSONKit", "~> 1.4"

end
