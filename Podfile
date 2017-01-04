# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'LocoThings' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Lock', '~> 1.24'
  pod 'Auth0', '~> 1.0.0-beta.5'
  pod 'SimpleKeychain', '~> 0.7'
  pod 'Alamofire', '~> 3.5'
  pod 'AlamofireImage'
  pod 'SideMenu'
  pod 'Fuzi'
  pod 'Firebase'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'ASValueTrackingSlider'


  # Pods for LocoThings

  target 'LocoThingsTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'LocoThingsUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
