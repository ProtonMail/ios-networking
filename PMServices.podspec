#
# Be sure to run `pod lib lint PMNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PMServices'
  s.version          = '1.0.0'
  s.summary          = 'A short description of PMServices.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
all protonmail logical services are here for now
                       DESC

  s.homepage         = 'https://github.com/ProtonMail/ios-networking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'GPLv3', :file => 'LICENSE' }
  s.author           = { 'zhj4478' => 'feng@pm.me' }
  s.source           = { :git => 'https://github.com/ProtonMail/ios-networking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target  = '10.10'
  
  s.source_files = 'PMNetworking/Sources/Services/**/*'
  
  s.swift_versions = ['5.0']
  
  # s.resource_bundles = {
  #   'PMNetworking' => ['PMNetworking/Assets/*.png']
  # }
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 4.0'
  
  # s.test_spec 'Tests' do |test_spec|
  #   test_spec.source_files = 'PMNetworking/Tests/*'
  #   test_spec.dependency 'OHHTTPStubs/Swift' # This dependency will only be linked with your tests.
  # end
end
