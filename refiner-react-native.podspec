require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "refiner-react-native"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = "https://github.com/refiner-io/mobile-sdk-react-native"
  s.license      = "MIT"
  s.author       = { package["author"]["name"] => package["author"]["email"] }
  s.platforms    = { :ios => "11.0" }
  s.source       = { :git => "https://github.com/refiner-io/mobile-sdk-react-native.git", :tag => "#{s.version}" }
  
  # Build as static library to support bridging headers
  s.static_framework = true

  # Source files configuration
  if ENV['RCT_NEW_ARCH_ENABLED'] == '1'
    s.source_files = "ios/**/*.{h,m,swift}", "ios/*.{h,m,swift}"
    # Do not exclude RefinerReactNativeSpec for New Architecture
    s.pod_target_xcconfig = {
      "DEFINES_MODULE" => "YES",
      "SWIFT_OBJC_INTERFACE_HEADER_NAME" => "RNRefiner-Swift.h",
      "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
      "CLANG_CXX_LIBRARY" => "libc++",
      "SWIFT_VERSION" => "5.0",
      # "SWIFT_OBJC_BRIDGING_HEADER" => "$(PODS_ROOT)/Headers/Public/refiner-react-native/RNRefiner-Bridging-Header.h",
      "SWIFT_INSTALL_OBJC_HEADER" => "YES"
    }
  else
    s.source_files = "ios/**/*.{h,m,swift}", "ios/*.{h,m,swift}"
    s.exclude_files = "ios/RefinerReactNativeSpec/**/*"
    s.pod_target_xcconfig = {
      "DEFINES_MODULE" => "YES",
      "SWIFT_OBJC_INTERFACE_HEADER_NAME" => "RNRefiner-Swift.h",
      "SWIFT_VERSION" => "5.0",
      # "SWIFT_OBJC_BRIDGING_HEADER" => "$(PODS_ROOT)/Headers/Public/refiner-react-native/RNRefiner-Bridging-Header.h",
      "SWIFT_INSTALL_OBJC_HEADER" => "YES"
    }
  end
  
  s.requires_arc = true

  # Conditionally compile for New Architecture
  # s.pod_target_xcconfig = {
  #   "DEFINES_MODULE" => "YES",
  #   "SWIFT_OBJC_INTERFACE_HEADER_NAME" => "RNRefiner-Swift.h",
  #   "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
  #   "CLANG_CXX_LIBRARY" => "libc++",
  #   "SWIFT_VERSION" => "5.0"
  # }

  # React Native dependency handling
  if respond_to?(:install_modules_dependencies, true)
    install_modules_dependencies(s)
  else
    s.dependency "React-Core"
    
    # The following line is only needed for the old architecture.
    # In the new architecture, this has been replaced by `install_modules_dependencies`.
    s.dependency "React-RCTEventEmitter"
    
    if ENV['RCT_NEW_ARCH_ENABLED'] == '1'
      s.dependency "React-Codegen"
      s.dependency "RCT-Folly"
      s.dependency "RCTRequired"
      s.dependency "RCTTypeSafety"
      s.dependency "ReactCommon/turbomodule/core"
    end
  end

  # RefinerSDK dependency
  s.dependency "RefinerSDK", "~> 1.5.10"
end

