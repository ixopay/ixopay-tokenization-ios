Pod::Spec.new do |s|
  s.name             = 'IxopayTokenizationSdk'
  s.version          = '1.0.3'
  s.summary          = 'IXOPAY iOS Tokenization SDK'
  s.description      = <<-DESC
                        This SDK enables your App to tokenize a user's card details to IXOPAY's PCI VAULT directly
                        without touching your server's to reduce your PCI DSS scope.
                       DESC

  s.homepage         = 'https://www.ixopay.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'IXOPAY' => 'support@ixopay.com' }
  s.source           = { :git => 'https://github.com/ixopay/ixopay-tokenization-ios.git', :tag => s.version.to_s }

  s.platform          = :ios, '9.0'
  s.requires_arc      = true

  s.source_files = 'IxopayTokenizationSdk/*.{h,m}'

  s.frameworks = 'Foundation'
end

