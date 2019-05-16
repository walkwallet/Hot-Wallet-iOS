# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'VWallet' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for VWallet
  pod 'Masonry'
  pod 'AFNetwork'
  pod 'SAMKeychain'
  pod 'DZNEmptyDataSet'
  pod 'FlyImage', '~>1.0'
  pod 'Reveal-SDK', :configurations => ['Debug']
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 8.0
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
            end
        end
    end
end

