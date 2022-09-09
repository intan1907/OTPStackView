Pod::Spec.new do |spec|
  spec.name                   = "OTPStackView"
  spec.version                = "1.0.2"
  spec.summary                = "OTPStackView"
  spec.description            = <<-DESC
                                  Customizable UIStackView that consists custom UITextFields for OTP/Security code with AutoFill support.
                                DESC

  spec.homepage               = "https://github.com/intan1907/OTPStackView"
  spec.license                = { :type => "MIT", :file => "LICENSE" }
  spec.author                 = { "Intan Nurjanah" => "intan3951@gmail.com" }

  spec.platform               = :ios, "10.0"

  spec.source                 = { :git => "https://github.com/intan1907/OTPStackView.git", :tag => "#{spec.version}" }

  spec.source_files           = "OTPStackView/**/*.{h,m,swift,a}"

  spec.framework              = "UIKit"

  spec.swift_version          = "5.0"
end
