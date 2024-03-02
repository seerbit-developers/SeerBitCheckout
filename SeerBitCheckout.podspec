
Pod::Spec.new do |spec|

  spec.name         = "SeerBitCheckout"
  spec.version      = "1.2.3"
  spec.summary      = "SeerBit Native ios sdk is used to seamlessly integrate SeerBit payment gateways into Native ios applications."

  spec.description  = <<-DESC
  SeerBit Native ios sdk is used to seamlessly integrate SeerBit payment gateways into Native ios applications. It is very simple and easy to integrate. It is completely built with SwiftUI, and also integrates with UIKKit projects.
                   DESC

  spec.homepage     = "https://github.com/seerbit-developers/SeerBitCheckout"

  spec.license      = "MIT"

     spec.author    = "SeerBit"
  
    spec.platform     = :ios, "16.0"

  spec.source       = { :git => "https://github.com/seerbit-developers/SeerBitCheckout.git", :tag => "#{spec.version}" }

  spec.source_files  = "Sources/SeerBitCheckout/**/*.swift"
  
  spec.resource = "Sources/Media.xcassets"

    spec.framework  = "SwiftUI"
    
    
    spec.swift_versions = "5.9"

  spec.requires_arc = false

    spec.dependency "SDWebImage", "~> 5.18.7"
    spec.dependency "SDWebImageSwiftUI", "~> 2.2.6"
end
