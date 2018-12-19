# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'HappyPathKit' do
  use_frameworks!
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'Siesta' || target.name == 'Cache'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end
