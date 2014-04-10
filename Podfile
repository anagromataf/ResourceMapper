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
	
	pod 'OCMockito', '~> 1.1.0'
    pod 'XCTAsyncTestCase', '0.1.0'
end

target :ResourceMapperOSXTests, :exclusive => true do
    platform :osx, '10.9'
    link_with 'ResourceMapperOSXTests'
	
	pod 'OCMockito', '~> 1.1.0'
    pod 'XCTAsyncTestCase', '0.1.0'
end
