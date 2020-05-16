#
# Be sure to run `pod lib lint RetroSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RetroSwift'
  s.version          = '0.1.0'
  s.summary          = 'Type-safe HTTP client for the  iOS, iPadOS, macOS, watchOS, tvOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Type-safe HTTP client for the  iOS, iPadOS, macOS, watchOS, tvOS platform inspired by https://github.com/square/retrofit
                       DESC

  s.homepage         = 'https://github.com/dubeboy/RetroSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dubeboy' => 'dubedivine@gmail.com' }
  s.source           = { :git => 'https://github.com/dubeboy/RetroSwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_versions = ['5.1', '5.2']
  s.ios.deployment_target = '10.0'
#  s.osx.deployment_target = '10.12'
#  s.tvos.deployment_target = '10.0'
#  s.watchos.deployment_target = '3.0'
  s.default_subspec = "Core"

  # s.resource_bundles = {
  #   'RetroSwift' => ['RetroSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.subspec "Core" do |core|
    core.source_files  = 'Sources/**/*'
    core.dependency "Alamofire", "~> 5.0"
    core.framework  = "Foundation"
  end

  s.test_spec 'Tests' do |test_spec|
   test_spec.source_files = 'Tests/**/*'
   test_spec.dependency 'Mocker', '~> 2.0.0' # This dependency will only be linked with your tests.
 end

end
