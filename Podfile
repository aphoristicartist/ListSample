# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ListSample' do
  use_frameworks!

  # Pods for ListSample
  pod 'Alamofire'
  pod 'Kingfisher'
  pod 'TinyConstraints'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SwiftLint'

  def testing_pods
  # Pods for testing
    pod 'RxBlocking'
    pod 'RxTest'
    pod 'Quick'
    pod 'Nimble'
  end

  target 'ListSampleTests' do
    inherit! :search_paths
    testing_pods
  end

  target 'ListSampleUITests' do
    inherit! :search_paths
    testing_pods
  end

end
