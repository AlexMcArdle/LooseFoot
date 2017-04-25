# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

target 'LooseFoot' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for LooseFoot
  pod 'AsyncDisplayKit'
  pod 'ActiveLabel'
  pod 'reddift'
  pod 'Kingfisher'
  pod 'FontAwesome.swift', :git => 'https://github.com/thii/FontAwesome.swift.git'
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
  pod 'SwiftyJSON'
  pod 'Toaster'
  pod 'Cartography'
  pod 'UIColor_Hex_Swift'
  pod 'FPSCounter'
  pod 'SwiftyMarkdown'
  pod 'Popover'
  pod 'PopupDialog'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  #pod 'Realm', :git => 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
  pod 'RealmSwift'
  #pod 'RealmSearchViewController'
  pod 'BonMot'

  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.1' # or '3.0'
          end
      end
  end
end
