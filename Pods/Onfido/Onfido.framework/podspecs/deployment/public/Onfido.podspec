#
# Be sure to run `pod lib lint Onfido.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'Onfido'
  s.version          = "#{ENV['IOS_SDK_VERSION']}"
  s.summary          = 'A Swift client for the Onfido API and a collection of UI elements to capture photos of documents.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This library aims to help mobile apps developers integrating with the Onfido Background Checks API
by providing a Swift wrapper to the API and a collection of UI screens and elements to capture
photos of documents and faces for further facial recognition.
DESC

  s.homepage         = 'https://github.com/onfido/onfido-ios-sdk'
  s.license          = {
    type: 'Copyright',
    text: <<-LICENSE
Copyright 2018 Onfido, Ltd. All rights reserved.
LICENSE
  }
  s.author           = { 'Onfido, Ltd' => 'engineering@onfido.com' }
  s.source           = { 'http' => "https://s3-eu-west-1.amazonaws.com/onfido-sdks/ios/Onfido-Debug-v#{s.version}.zip" }

  s.ios.deployment_target = '8.0'

  s.vendored_frameworks = "Onfido.framework"
  s.preserve_paths = "Onfido.framework"
  s.source_files = "Onfido.framework/Headers/*.h"
  s.public_header_files = "Onfido.framework/Headers/*.h"

  # Apple frameworks dependencies

  s.frameworks = 'Foundation', 'UIKit', 'AVFoundation'

  # External dependencies

  s.dependency 'Swinject', '< 2.3'
  s.dependency 'SwiftyJSON', '~> 3.1'
  s.dependency 'ZSWTaggedString', '4.0'
  s.dependency 'ZSWTappableLabel', '2.0'

end
