Pod::Spec.new do |spec|
  spec.name         = 'AnyCodable'
  spec.version      = '1.0.0'
  spec.swift_version = '4.0.3'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/asensei/AnyCodable'
  spec.authors      = { 'Asensei' => 'info@asensei.com' }
  spec.summary      = 'Generic Any? data encapsulation meant to facilitate the transformation of loosely typed objects using Codable.'
  spec.source       = { :git => "https://github.com/asensei/AnyCodable.git", :tag => "#{spec.version}" }
  spec.ios.deployment_target = "9.0"
  spec.osx.deployment_target = "10.11"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"
  spec.requires_arc = true
  spec.source_files = "Sources/**/*.{swift}"
  spec.framework = 'Foundation'
end
