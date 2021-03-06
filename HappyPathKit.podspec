Pod::Spec.new do |spec|
  spec.name = 'HappyPathKit'
  spec.version = '0.0.2'
  spec.license = 'Apache2.0'
  spec.summary = 'HappyPath runtime library.'
  spec.homepage = 'http://www.happypath.com'
  spec.author = {'Nick Bolton' => 'happypath@pixeol.com'}
  spec.source = {:git => 'https://github.com/nickbolton/HappyPathKit.git'}

  spec.ios.deployment_target = '11.0'
  spec.osx.deployment_target = '10.13'
  spec.ios.source_files = 'Source/Shared/**/*.swift'
  spec.osx.source_files = 'Source/Shared/**/*.swift'
  spec.dependency 'Cache', '~> 4.1'
  spec.requires_arc = true
end 
