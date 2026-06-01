Pod::Spec.new do |s|
  s.name             = 'image_saver'
  s.version          = '0.0.1'
  s.summary          = 'Image saver'
  s.description      = <<-DESC
Plugin for save images
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'image_saver/Sources/image_saver/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.resource_bundles = {'image_saver_privacy' => ['image_saver/Sources/image_saver/PrivacyInfo.xcprivacy']}
end
