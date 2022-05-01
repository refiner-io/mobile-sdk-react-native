require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "refiner-react-native"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  Refiner SDK React Native
                   DESC
  s.homepage     = "https://github.com/refiner-io/mobile-sdk-react-native"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.authors      = { "Refiner" => "" }
  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/refiner-io/mobile-sdk-react-native.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "RefinerSDK", "1.0.2"
  # ...
  # s.dependency "..."
end

