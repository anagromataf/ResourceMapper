//
//  NSEntityDescription_RootEntityTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMManagedObjectModelTestCase.h"

@interface NSEntityDescription_RootEntityTests : RMManagedObjectModelTestCase

@end

@implementation NSEntityDescription_RootEntityTests

- (void)testGetRootEntity
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    NSEntityDescription *specialEntity = [self entityWithName:@"SpecialEntity"];

    XCTAssertEqualObjects([specialEntity rm_rootEntity], entity);
}

@end
