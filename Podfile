source 'git@github.com:CocoaPods/Specs.git'
xcodeproj 'ResourceMapper/ResourceMapper.xcodeproj'

target :ResourceMapperiOS, :exclusive => true do
    platform :ios, '6.1'
    link_with 'ResourceMapperiOS'
end

target :ResourceMapperOSX, :exclusive => true do
    platform :osx, '10.9'
    link_with 'ResourceMapperOSX'
end


target :ResourceMapperiOSTests, :exclusive => true do
    platform :ios, '6.1'
    link_with 'ResourceMapperiOSTests'
	
	pod 'OCMockito', '~> 1.3.1'
end

target :ResourceMapperOSXTests, :exclusive => true do
    platform :osx, '10.9'
    link_with 'ResourceMapperOSXTests'
	
	pod 'OCMockito', '~> 1.3.1'
end
