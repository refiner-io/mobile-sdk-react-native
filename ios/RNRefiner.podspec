
Pod::Spec.new do |s|
  s.name         = "RNRefiner"
  s.version      = "1.7.0"
  s.summary      = "Official React Native wrapper for the Refiner Mobile SDK"
  s.homepage     = "https://github.com/refiner-io/mobile-sdk-react-native"
  s.license      = "MIT"
  s.author       = { "Refiner" => "contact@refiner.io" }
  s.platform     = :ios, "12.0"
  s.source       = { :git => "https://github.com/author/RNRefiner.git", :tag => "master" }
  s.source_files = "*.{h,m,swift}"
  s.requires_arc = true

  # Handle generated TurboModule spec files
  s.pod_target_xcconfig = {
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'CLANG_CXX_LIBRARY' => 'libc++',
    'SWIFT_OBJC_BRIDGING_HEADER' => '$(PODS_ROOT)/Headers/Public/refiner-react-native/RNRefiner-Bridging-Header.h'
  }

  s.dependency "React"
  s.dependency "RefinerSDK", "~> 1.5.8"
end

  
