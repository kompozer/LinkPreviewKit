#
# Be sure to run `pod lib lint LinkPreviewKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LinkPreviewKit"
  s.version          = "0.3.0"
  s.summary          = "Link preview kit"
  s.description      = <<-DESC
                       Library to fetch the social media meta tag information from a website URL. See [http://moz.com/blog/meta-data-templates-123](http://moz.com/blog/meta-data-templates-123)
                       DESC
  s.homepage         = "https://github.com/kompozer/LinkPreviewKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Andreas Kompanez" => "kompanez.andreas@gmail.com" }
  s.source           = { :git => "https://github.com/kompozer/LinkPreviewKit.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'LinkPreviewKit' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'HTMLReader'
end
