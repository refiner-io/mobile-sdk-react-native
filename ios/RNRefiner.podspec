
Pod::Spec.new do |s|
  s.name         = "RNRefiner"
  s.version      = "1.3.10"
  s.summary      = "RNRefiner"
  s.description  = <<-DESC
                  RNRefiner
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNRefiner.git", :tag => "master" }
  s.source_files  = "RNRefiner/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  s.dependency "RefinerSDK"
  #s.dependency "others"

end

  
