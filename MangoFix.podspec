Pod::Spec.new do |s|
s.name         = "MangoFix"
s.version      = "1.4.4"
s.summary      = "MangoFix"
s.description  = <<-DESC
  Mango is a DSL which syntax is very similar to Objective-C，Mango is also an iOS  App hotfix SDK. You can use Mango method replace any Objective-C method.
DESC
s.homepage     = "https://github.com/YPLiang19/Mango"
s.license      = "MIT"
s.author             = { "Yong PengLiang" => "yong_pliang@163.com" }
s.ios.deployment_target = "9.0"
s.source       = { :git => "https://github.com/YPLiang19/Mango.git", :tag => "#{s.version}" }
s.pod_target_xcconfig = { 'GCC_INPUT_FILETYPE' => 'sourcecode.c.objc' }
s.source_files  = "MangoFix/**/*.{h,m,c,y,l}"
s.vendored_libraries  = 'MangoFix/libffi/libffi.a'
s.dependency 'symdl'
end

