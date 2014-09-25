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
    pod 'XCTAsyncTestCase', git: "https://github.com/iheartradio/xctest-additions.git", tag: '0.1.1'
end

target :ResourceMapperOSXTests, :exclusive => true do
    platform :osx, '10.9'
    link_with 'ResourceMapperOSXTests'
	
	pod 'OCMockito', '~> 1.1.0'
    pod 'XCTAsyncTestCase', git: "https://github.com/iheartradio/xctest-additions.git", tag: '0.1.1'
end

post_install do |installer_representation|
    installer_representation.project.targets.each do |target|
        target.build_configurations.each do |config|
            s = config.build_settings['FRAMEWORK_SEARCH_PATHS']
            s = [ '$(inherited)' ] if s == nil;
            s.push('$(PLATFORM_DIR)/Developer/Library/Frameworks')
            config.build_settings['FRAMEWORK_SEARCH_PATHS'] = s
        end
    end
end
