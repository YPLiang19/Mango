Pod::Spec.new do |s|
s.name         = "MangoFix"
s.version      = "1.0.1"
s.summary      = "Mango"
s.description  = <<-DESC
  Mango is a DSL which syntax is very similar to Objective-C，Mango is also an iOS  App hotfix SDK. You can use Mango method replace any Objective-C method.
DESC
s.homepage     = "https://github.com/YPLiang19/Mango"
s.license      = "MIT"
s.author             = { "Yong PengLiang" => "yong_pliang@163.com" }
s.ios.deployment_target = "8.0"
s.source       = { :git => "https://github.com/YPLiang19/Mango.git", :tag => "#{s.version}" }
s.source_files  = "Mango/**/*.{h,m,c}"
s.vendored_libraries  = 'Mango/libffi/libffi.a'
end

