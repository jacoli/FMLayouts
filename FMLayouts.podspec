Pod::Spec.new do |s|
  s.name         = "FMLayouts"
  s.version      = "0.0.2"
  s.summary      = "A easy way to layout views in iOS using linear, flow etc., similar to layout mechanism in android."
  s.homepage     = "https://github.com/jacoli/FMLayouts"
  s.license      = "MIT"
  s.authors      = { "jacoli" => "jaco.lcg@gmail.com" }
  s.source       = { :git => "https://github.com/jacoli/FMLayouts.git", :tag => "0.0.2" }
  s.frameworks   = 'Foundation', 'UIKit'
  s.platform     = :ios, '7.0'
  s.source_files = 'FMLayouts/*.{h,m}'
  s.requires_arc = true
end
