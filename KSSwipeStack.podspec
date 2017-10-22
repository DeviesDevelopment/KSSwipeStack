#
# Be sure to run `pod lib lint KSSwipeStack.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KSSwipeStack'
  s.version          = '0.2.0'
  s.summary          = 'A Swift card swiping library created by Kicksort Consulting AB'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
KSSwipeStack is a lightweight card swiping library for iOS written in Swift. 

KSSwipeStack handles any data model and the design/layout of the swipe cards are completely customizable.

Using the options provided you can customize the behavior and animations used in the swipe stack.

DOCS: https://github.com/Kicksort/KSSwipeStack
                       DESC

  s.homepage         = 'https://github.com/Kicksort/KSSwipeStack'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Simon Arneson' => 'arneson@kicksort.se' }
  s.source           = { :git => 'https://github.com/kicksort/KSSwipeStack.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'KSSwipeStack/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KSSwipeStack' => ['KSSwipeStack/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'RxSwift'
end
