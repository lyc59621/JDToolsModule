#
#  Be sure to run `pod spec lint BLAPIManagers.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "JDToolsModule"
  s.version      = "0.0.1"
  s.summary      = "JDToolsModule."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                    this is JDToolsModule
                   DESC

  s.homepage     = "https://github.com/lyc59621/JDToolsModule"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  # s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "JDToolsModule" => "lyc59621@icloud.com" }
  # Or just: s.author    = "JDToolsModule"
  # s.authors            = { "JDToolsModule" => "lyc59621@icloud.com" }
  # s.social_media_url   = "http://twitter.com/lyc59621"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  s.platform     = :ios, "9.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/lyc59621/JDToolsModule.git", :tag => s.version.to_s }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "JDToolsModule/JDToolsModuleHeader.h"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"
  s.resource = "JDToolsModule/**/*.{plist,bundle,xib}"



s.subspec 'JDTools' do |ss|

    ss.subspec 'JDAlert' do |sss|
    sss.source_files = 'JDToolsModule/JDTools/JDAlert/*.{h,m}'
    end

    ss.subspec 'JDBanner' do |sss|
    sss.source_files = 'JDToolsModule/JDTools/JDBanner/*.{h,m}'

    end

    ss.subspec 'JDBtnCountdown' do |sss|
    sss.source_files = 'JDToolsModule/JDTools/JDBtnCountdown/*.{h,m}'

    end

    ss.subspec 'JDCropImage' do |sss|
    sss.source_files = 'JDToolsModule/JDTools/JDCropImage/*.{h,m}'

    end

    ss.subspec 'JDDeleteTool' do |sss|
    sss.source_files = 'JDToolsModule/JDTools/JDDeleteTool/*.{h,m}'

    end

#    ss.subspec 'JDKeyBoard' do |sss|
#    sss.source_files = 'JDToolsModule/JDTools/JDKeyBoard/*.{h,m}'
#
#    end
    ss.subspec 'JDLogger' do |sss|
    sss.source_files = 'JDToolsModule/JDTools/JDLogger/*.{h,m}'

    end
#    ss.subspec 'JDPaySheet' do |sss|
#    sss.source_files = 'JDToolsModule/JDTools/JDPaySheet/*.{h,m}'

#    end
    ss.subspec 'JDDeleteTool' do |sss|
    sss.source_files = 'JDToolsModule/JDTools/JDDeleteTool/*.{h,m}'

    end
    ss.subspec 'JDPick' do |sss|
    sss.source_files = 'JDToolsModule/JDTools/JDPick/*.{h,m}'

    end
    ss.subspec 'JDTagsView' do |sss|
    sss.source_files = 'JDToolsModule/JDTools/JDTagsView/*.{h,m}'

    end
    ss.subspec 'JDTSMessage' do |sss|
    sss.source_files = 'JDToolsModule/JDTools/JDTSMessage/*.{h,m}'

    end
    ss.subspec 'JDTypeBtnView' do |sss|
    sss.source_files = 'JDToolsModule/JDTools/JDTypeBtnView/*.{h,m}'

    end
    ss.subspec 'JDVerifyCode' do |sss|
    sss.source_files = 'JDToolsModule/JDTools/JDVerifyCode/*.{h,m}'

    end
    ss.subspec 'JDStarView' do |sss|
    sss.source_files = 'JDToolsModule/JDTools/JDStarView/*.{h,m}'

    end

    

end

s.subspec 'SySafeCategory' do |ss|

    ss.source_files = 'JDToolsModule/SySafeCategory/*.{h,m}'
end
s.subspec 'Location' do |ss|

    ss.source_files = 'JDToolsModule/Location/*.{h,m}'
end
s.subspec 'UIImage+Blur' do |ss|

    ss.source_files = 'JDToolsModule/UIImage+Blur/*.{h,m}'
end
s.subspec 'YYFPSLabel' do |ss|

    ss.source_files = 'JDToolsModule/YYFPSLabel/*.{h,m}'
end
s.subspec 'OpenUDID' do |ss|

    ss.source_files = 'JDToolsModule/OpenUDID/*.{h,m}'
end
s.subspec 'GCDHelper' do |ss|

    ss.source_files = 'JDToolsModule/GCDHelper/*.{h,m}'
end

s.subspec 'Category' do |ss|

    ss.subspec 'UIKit' do |sss|
    sss.source_files = 'JDToolsModule/Category/UIKit/*.{h,m}'
    end
 ss.subspec 'UIFoundation' do |sss|
    sss.source_files = 'JDToolsModule/Category/UIFoundation/*.{h,m}'
    end
 ss.subspec 'RAC' do |sss|
    sss.source_files = 'JDToolsModule/Category/RAC/*.{h,m}'
    end
 ss.subspec 'JKCategories' do |sss|
    sss.source_files = 'JDToolsModule/Category/JKCategories/**/*.{h,m}'
   end
end


#s.subspec 'KeyBoard' do |ss|
#
#    ss.subspec 'KeyBoard' do |sss|
#    sss.source_files = 'JDToolsModule/KeyBoard/KeyBoard/*.{h,m}'
#    end
#    ss.subspec 'Cagegory' do |sss|
#    sss.source_files = 'JDToolsModule/KeyBoard/Cagegory/*.{h,m}'
#    end
#   ss.subspec 'Models' do |sss|
#    sss.source_files = 'JDToolsModule/KeyBoard/Models/*.{h,m}'
#    end
#   ss.subspec 'Views' do |sss|
#    sss.subspec 'FacePanel' do |ssss|
#    ssss.source_files = 'JDToolsModule/KeyBoard/Views/FacePanel/*.{h,m}'
#    end
#    sss.subspec 'MorePanel' do |ssss|
#    ssss.source_files = 'JDToolsModule/KeyBoard/Views/MorePanel/*.{h,m}'
#    end
#    sss.subspec 'ToolBarPanel' do |ssss|
#    ssss.source_files = 'JDToolsModule/KeyBoard/Views/ToolBarPanel/*.{h,m}'
#    end
#  end
#end





  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "BLNetworking"
  # s.dependency "BLAPIManagers"
  # s.dependency "BLMediator"
  s.dependency  'mob_sharesdk'
  s.dependency  'mob_sharesdk/ShareSDKPlatforms/QQ'
  s.dependency  'mob_sharesdk/ShareSDKPlatforms/SinaWeibo'
  #s.dependency  'mob_sharesdk/ShareSDKPlatforms/WeChat'
  s.dependency  'ICPaySDK/ICPayManager', '~> 1.5.0'
  s.dependency  'ICPaySDK/ICWxPay', '~> 1.5.0'
  s.dependency  'ICPaySDK/ICAliPay', '~> 1.5.0'#暂时取消支付宝

  s.dependency  'LSSafeProtector'

  s.dependency  'MBProgressHUD+JDragon','~> 0.0.4'
  s.dependency  'CocoaLumberjack'
  s.dependency  'OpenUDID', '~> 1.0.0'


  
  
end
