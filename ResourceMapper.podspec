Pod::Spec.new do |s|
  s.name                = "ResourceMapper"
  s.version             = "0.1"
  s.summary			    = "Mapps resources with its primary key to managed obejcts in CoreData."
  s.authors			    = { "Tobias Kräntzer" => "info@tobias-kranetzer.de" }
  s.social_media_url 	= 'https://twitter.com/anagrom_ataf'
  s.license             = { :type => 'BSD', :file => 'LICENSE.md' }
  s.homepage			= "https://github.com/anagromataf/ResourceMapper"
  s.source			    = { :git => "https://github.com/anagromataf/ResourceMapper.git",
  
  s.ios.deployment_target = '6.1'
  s.osx.deployment_target = '10.8'
  
  s.requires_arc = true
  
  s.source_files 		= 'ResourceMapper/ResourceMapper/**/*.{h,m}'
  s.public_header_files = 'ResourceMapper/ResourceMapper/Public/*.h'
  
  s.frameworks = 'CoreData'
end
