#
# Be sure to run `pod lib lint Merchant.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Merchant'
  s.version          = '0.1.2'
  s.summary          = 'Type-safe HTTP client for iOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Type-safe Swift HTTP client for iOS and MacOS inspired by https://github.com/square/retrofit
                       DESC

  s.homepage         = 'https://github.com/dubeboy/Merchant'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dubeboy' => 'dubedivine@gmail.com' }
  s.source           = { :git => 'https://github.com/dubeboy/Merchant.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/divinedube'
  s.swift_versions = ['5.1', '5.2']
  s.ios.deployment_target = '10.0'
  s.default_subspec = "Core"

  s.subspec "Core" do |core|
    core.source_files  = 'Sources/**/*'
    core.dependency "Alamofire", "~> 5.0"
    core.framework  = "Foundation"
  end

  s.test_spec 'Tests' do |test_spec|
   test_spec.source_files = 'Tests/**/*'
   test_spec.dependency 'Mocker', '~> 2.0.0'
 end

end
