//
//  NSEntityDescriptionTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMManagedObjectModelTestCase.h"

@interface NSEntityDescriptionTests : RMManagedObjectModelTestCase

@end

@implementation NSEntityDescriptionTests

#pragma mark Tests | Root Entity

- (void)testGetRootEntity
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    NSEntityDescription *specialEntity = [self entityWithName:@"SpecialEntity"];

    XCTAssertEqualObjects([specialEntity rm_rootEntity], entity);
}

#pragma mark Tests | Primary Key

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

#pragma mark Tests | Sort Descriptor

- (void)testPrimaryKeySortDescriptor
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    
    NSArray *sortDescriptors = [entity rm_primaryKeySortDescriptors];
    
    NSArray *expectedSortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES],
                                         [NSSortDescriptor sortDescriptorWithKey:@"parent" ascending:YES]];
    
    XCTAssertEqualObjects(sortDescriptors, expectedSortDescriptors);
}

@end
