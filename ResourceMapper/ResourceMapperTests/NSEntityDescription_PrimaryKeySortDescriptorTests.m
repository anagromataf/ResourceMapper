//
//  NSEntityDescription_PrimaryKeySortDescriptorTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMManagedObjectModelTestCase.h"

@interface NSEntityDescription_PrimaryKeySortDescriptorTests : RMManagedObjectModelTestCase

@end

@implementation NSEntityDescription_PrimaryKeySortDescriptorTests

- (void)testPrimaryKeySortDescriptor
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    
    NSArray *sortDescriptors = [entity rm_primaryKeySortDescriptors];
    
    NSArray *expectedSortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES],
                                        [NSSortDescriptor sortDescriptorWithKey:@"parent" ascending:YES]];
    
    XCTAssertEqualObjects(sortDescriptors, expectedSortDescriptors);
}

@end
