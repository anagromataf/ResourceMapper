Pod::Spec.new do |s|
  s.name = "ResourceMapper"
  s.version = "0.1"
  s.ios.deployment_target = '6.1'
  s.osx.deployment_target = '10.8'
  
  s.requires_arc = true
  
  s.source_files 		= 'ResourceMapper/ResourceMapper/**/*.{h,m}'
  s.public_header_files = 'ResourceMapper/ResourceMapper/Public/*.h'
  
  s.frameworks = 'CoreData'
end
