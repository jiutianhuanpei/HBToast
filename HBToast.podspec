Pod::Spec.new do |s|

  s.name         = "HBToast"
  s.version      = "0.0.6"
  s.summary      = "Swift 版的 Toast 控件"

  s.description  = <<-DESC
    Swift 版的 Toast 控件。
                   DESC

  s.homepage     = "https://www.shenhongbang.cc"

  s.license      = "MIT"
  s.author       = { "shenhongbang" => "shenhongbang@163.com" }

  s.platform     = :ios, "11.0"

  s.source       = { :git => "https://github.com/jiutianhuanpei/HBToast.git", :tag => s.version }

  s.source_files  = "HBToast.swift"

  s.frameworks = "UIKit"
  s.requires_arc = true
  s.swift_version = '5.0'
  s.dependency "SnapKit"

end
