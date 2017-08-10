Pod::Spec.new do |s|
  s.name         = "FMLayouts"
  s.version      = "0.0.1"
  s.summary      = "A easy way to layout views in iOS using linear, flow etc., similar to layout mechanism in android."
  s.homepage     = "https://github.com/jacoli/FMLayouts"
  s.license      = "MIT"
  s.authors      = { "jacoli" => "jaco.lcg@gmail.com" }
  s.source       = { :git => "https://github.com/jacoli/FMLayouts.git", :tag => "1.0.0" }
  s.frameworks   = 'Foundation', 'UIKit'
  s.platform     = :ios, '7.0'
  s.source_files = 'FMLayouts/Sources/*.{h,m}'
  s.requires_arc = true
end
