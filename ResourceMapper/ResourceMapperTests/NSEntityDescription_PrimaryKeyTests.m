//
//  NSEntityDescription_PrimaryKeyTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMManagedObjectModelTestCase.h"

@interface NSEntityDescription_PrimaryKeyTests : RMManagedObjectModelTestCase

@end

@implementation NSEntityDescription_PrimaryKeyTests

- (void)testPrimaryKeyPropertyNames
{
    NSEntityDescription *subEntity = [self entityWithName:@"SubEntity"];
    
    NSArray *primaryKeyPropertyNames = [subEntity rm_primaryKeyPropertyNames];
    NSArray *expectedPrimaryKeyPropertyNames = @[@"identifier", @"parent"];
    
    XCTAssertEqualObjects(primaryKeyPropertyNames, expectedPrimaryKeyPropertyNames);
}

- (void)testPrimaryKeyProperties
{
    NSEntityDescription *subEntity = [self entityWithName:@"SubEntity"];
    
    NSArray *primaryKeyProperties = [subEntity rm_primaryKeyProperties];
    
    NSArray *expectedPrimaryProperties = @[[self propertyWithName:@"identifier" ofEntity:@"Entity"],
                                           [self propertyWithName:@"parent" ofEntity:@"Entity"]];
    
    XCTAssertEqualObjects(primaryKeyProperties, expectedPrimaryProperties);
}

@end
