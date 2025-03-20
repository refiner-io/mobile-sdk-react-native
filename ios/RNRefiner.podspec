
Pod::Spec.new do |s|
  s.name         = "RNRefiner"
  s.version      = "1.6.1"
  s.summary      = "Official React Native wrapper for the Refiner.io Mobile SDK"
  s.homepage     = "https://github.com/refiner-io/mobile-sdk-react-native"
  s.license      = "MIT"
  s.author       = { "Refiner" => "contact@refiner.io" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNRefiner.git", :tag => "master" }
  s.source_files  = "RNRefiner/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  s.dependency "RefinerSDK", "~> 1.5.5"
end

  
