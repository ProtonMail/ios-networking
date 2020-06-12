#
# Be sure to run `pod lib lint PMNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PMCommon'
  s.version          = '0.1.0'
  s.summary          = 'A short description of PMNetworking.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ProtonMail/ios-networking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'GPLv3', :file => 'LICENSE' }
  s.author           = { 'zhj4478' => 'feng@pm.me' }
  s.source           = { :git => 'git@gitlab.protontech.ch:apple/shared/pmnetworking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target  = '10.10'
  
#  s.source_files = 'PMNetworking/Sources/**/*'
  
  s.swift_versions = ['5.0']

  s.default_subspec = 'Default'
  # Default subspec that includes the most commonly-used components
  s.subspec 'Default' do |default|
    default.dependency 'PMCommon/Networking'
    # default.dependency 'PMCommon/NSURLSession'
    # default.dependency 'PMCommon/JSON'
    # default.dependency 'PMCommon/OHPathHelpers'
  end
  
  
  
  # Optional subspecs
  s.subspec 'Networking' do |networking|
    networking.source_files = "PMNetworking/Sources/Networking/**/*"
    networking.dependency 'AFNetworking', '~> 4.0'
  end

  # s.subspec 'JSON' do |json|
  #   json.dependency 'OHHTTPStubs/Core'
  #   json.source_files = "Sources/OHHTTPStubs/**/HTTPStubsResponse+JSON.{h,m}"
  # end
  
  
  # s.resource_bundles = {
  #   'PMNetworking' => ['PMNetworking/Assets/*.png']
  # }
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'PMNetworking/Tests/**/*'
    test_spec.dependency 'OHHTTPStubs/Swift' # This dependency will only be linked with your tests.
  end
end
