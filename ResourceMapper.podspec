Pod::Spec.new do |s|
  s.name                = "ResourceMapper"
  s.version             = "0.6.0"
  s.summary			    = "Maps resources with it's primary key to managed objects in CoreData."
  s.authors			    = { "Tobias Kräntzer" => "info@tobias-kraentzer.de" }
  s.social_media_url 	= 'https://twitter.com/anagrom_ataf'
  s.license             = { :type => 'BSD', :file => 'LICENSE.md' }
  s.homepage			= "https://github.com/anagromataf/ResourceMapper"
  s.source			    = { :git => "https://github.com/anagromataf/ResourceMapper.git", :tag => "#{s.version}" }
  
  s.ios.deployment_target = '6.1'
  s.osx.deployment_target = '10.8'
  
  s.requires_arc = true
  
  s.source_files 		= 'ResourceMapper/ResourceMapper/**/*.{h,m}'
  s.public_header_files = 'ResourceMapper/ResourceMapper/Public/*.h'
  
  s.frameworks = 'CoreData'
end
