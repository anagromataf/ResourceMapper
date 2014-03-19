//
//  RMResourceTraversalDependencyTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 18.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMManagedObjectModelTestCase.h"

@interface RMResourceTraversalDependencyTests : RMManagedObjectModelTestCase

@end

@implementation RMResourceTraversalDependencyTests

- (void)testReturnValueOfLeafWithOutPK
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    NSDictionary *resource = @{@"foo":@"bar"};

    NSMutableSet *dependency = [entity rm_traverseResource:resource
                                   usingDependencyCallback:nil
                                           mappingCallback:nil];
    XCTAssertNil(dependency);
}

- (void)testReturnValueOfLeafWithPK
{
    NSEntityDescription *entity = [self entityWithName:@"PKEntity"];
    NSDictionary *resource = @{@"identifier":@"1"};
    
    NSMutableSet *dependency = [entity rm_traverseResource:resource
                                   usingDependencyCallback:nil
                                           mappingCallback:nil];
    XCTAssertNotNil(dependency);
    XCTAssertEqualObjects(dependency, [NSSet set]);
}

- (void)testReturnValueOfNodeWithLeaf
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    NSDictionary *resource = @{@"foo":@"bar",
                               @"from":@{@"identifier":@"1"}};
    
    NSMutableSet *dependency = [entity rm_traverseResource:resource
                                   usingDependencyCallback:nil
                                           mappingCallback:nil];
    XCTAssertNotNil(dependency);
    
    NSSet *expectedDependency = [NSSet setWithObject:
         @[[self propertyWithName:@"from" ofEntity:@"Entity"]]];
    
    XCTAssertEqualObjects(dependency, expectedDependency);
}

- (void)testReturnValueOfTree
{
    NSEntityDescription *entity = [self entityWithName:@"PKEntity"];
    NSDictionary *resource = @{@"identifier":@"1",
                               @"to":@[@{@"foo":@"bar"},
                                       @{@"foo":@"bar",
                                         @"from":@{@"identifier":@"2"}}]};
    
    NSMutableSet *dependencies = [[NSMutableSet alloc] init];
    
    NSMutableSet *dependency = [entity rm_traverseResource:resource
                                   usingDependencyCallback:^(NSSet *paths) {
                                       [dependencies unionSet:paths];
                                   }
                                           mappingCallback:nil];
    XCTAssertNotNil(dependency);
    XCTAssertEqualObjects(dependency, [NSSet set]);

    XCTAssertEqual([dependencies count], 1);
    
    NSArray *expectedPath = @[@"to", @"from"];
    XCTAssertEqualObjects([dependencies valueForKeyPath:@"name"], [NSSet setWithObject:expectedPath]);
    
}

@end
