#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint sentry_flutter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sentry_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Sentry SDK for Flutter.'
  s.description      = <<-DESC
Sentry SDK for Flutter with support to native through sentry-cocoa.
                       DESC
  s.homepage         = 'https://github.com/getsentry/sentry-flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Sentry' => 'oss@sentry.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Sentry', '~> 6.0.0-alpha.0'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
