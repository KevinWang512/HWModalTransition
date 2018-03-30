#
# Be sure to run `pod lib lint HWModalTransition.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'HWModalTransition'
    s.version          = '1.0.1'
    s.summary          = '轻松实现自定义转场'
    s.homepage         = 'https://github.com/wanghouwen/HWModalTransition'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'wanghouwen' => 'wanghouwen123@126.com' }
    s.source           = { :git => 'https://github.com/wanghouwen/HWModalTransition.git', :tag => s.version }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.requires_arc = true
    s.ios.deployment_target = '8.0'
    
    s.source_files = 'HWModalTransition/*.{h,m}'
    s.public_header_files = 'HWModalTransition/*.h'
    s.dependency 'HWExtension/Category'
    
    # s.frameworks = 'UIKit', 'MapKit'
    
end
