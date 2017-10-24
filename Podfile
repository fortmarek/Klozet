

platform :ios, '10.0'

use_frameworks!
inhibit_all_warnings!

def testing_pods
    pod 'Alamofire'
end

target 'Klozet' do
    testing_pods
    pod 'SwiftyJSON', ' ~> 3.1.0'
    pod 'ImageSlideshow'
    pod 'AlamofireImage', ' ~> 3.1'
    pod 'ReactiveCocoa'
    pod 'ReactiveSwift'
    target 'KlozetTests' do
        inherit! :search_paths
        testing_pods
    end

    target 'KlozetUITests' do
        inherit! :search_paths
        testing_pods
    end
end




post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.2'
    end
  end
end