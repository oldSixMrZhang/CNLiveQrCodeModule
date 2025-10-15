#
# Be sure to run `pod lib lint CNLiveQrCodeModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CNLiveQrCodeModule'
  s.version          = '0.0.1'
  s.summary          = 'CNLiveQrCodeModule.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: 网家家-二维码模块.
                       DESC

  s.homepage         = 'http://bj.gitlab.cnlive.com/ios-team/CNLiveQrCodeModule'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '153993236@qq.com' => 'zhangxiaowen@cnlive.com' }
  s.source           = { :git => 'http://bj.gitlab.cnlive.com/ios-team/CNLiveQrCodeModule.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  
#  s.source_files = 'CNLiveQrCodeModule/Classes/**/*'
  
  s.resource_bundles = {
    'CNLiveQrCodeModule' => ['CNLiveQrCodeModule/Assets/CNLiveQrCodeModule.xcassets']
  }
  
  # Module
  s.subspec 'Module' do |ss|
      ss.source_files = 'CNLiveQrCodeModule/Classes/Module/*.{h,m}'
      ss.dependency 'CNLiveQrCodeModule/Controller'
  end
  
  # Controller
  s.subspec 'Controller' do |ss|
      ss.source_files = 'CNLiveQrCodeModule/Classes/Controller/*.{h,m}'
      ss.dependency 'CNLiveQrCodeModule/View'
  end
  
  # View
  s.subspec 'View' do |ss|
      ss.source_files = 'CNLiveQrCodeModule/Classes/View/*.{h,m}'
  end
   
  # Model
  s.subspec 'Model' do |ss|
      ss.source_files = 'CNLiveQrCodeModule/Classes/Model/*.{h,m}'
  end
  
  # s.resource_bundles = {
  #   'CNLiveQrCodeModule' => ['CNLiveQrCodeModule/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  # pod
  s.dependency 'CNLiveTripartiteManagement/QMUIKit'
  s.dependency 'CNLiveTripartiteManagement/SDWebImage'
  s.dependency 'CNLiveTripartiteManagement/Masonry'
  s.dependency 'CNLiveTripartiteManagement/MJExtension'
  s.dependency 'SGQRCode', '3.0.1'

  # 服务层
  s.dependency 'CNLiveServices'
  
  # 基类
  s.dependency 'CNLiveCommonClass'
  
  # 环境
  s.dependency 'CNLiveEnvironment'

  # 数据请求
  s.dependency 'CNLiveRequestBastKit'
   
  # 用户信息本地化
  s.dependency 'CNLiveUserManagement'
  
  # 管理类
  s.dependency 'CNLiveManager'
  
  #IM
  s.dependency 'CNLiveIMBaseSDK'
  
  # 分类
  s.dependency 'CNLiveCategory'

  # 自定义控件
  s.dependency 'CNLiveCustomControl'
  
  s.static_framework = true

end
