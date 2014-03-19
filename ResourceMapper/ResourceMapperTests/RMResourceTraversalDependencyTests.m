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

    RMDependency *dependency = [entity rm_traverseResource:resource
                                   usingDependencyCallback:nil
                                           mappingCallback:nil];
    XCTAssertNil(dependency);
}

- (void)testReturnValueOfLeafWithPK
{
    NSEntityDescription *entity = [self entityWithName:@"PKEntity"];
    NSDictionary *resource = @{@"identifier":@"1"};
    
    RMDependency *dependency = [entity rm_traverseResource:resource
                                   usingDependencyCallback:nil
                                           mappingCallback:nil];
    XCTAssertNotNil(dependency);
    XCTAssertEqual([dependency.allPaths count], 0);
}

- (void)testReturnValueOfNodeWithLeaf
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    NSDictionary *resource = @{@"foo":@"bar",
                               @"from":@{@"identifier":@"1"}};
    
    RMDependency *dependency = [entity rm_traverseResource:resource
                                   usingDependencyCallback:nil
                                           mappingCallback:nil];
    XCTAssertNotNil(dependency);
    
    RMDependency *expectedDependency = [[RMDependency alloc] init];
    [expectedDependency pushRelationship:(NSRelationshipDescription *)[self propertyWithName:@"from" ofEntity:@"Entity"]];
    
    XCTAssertEqualObjects(dependency, expectedDependency);
}

- (void)testReturnValueOfTree
{
    NSEntityDescription *entity = [self entityWithName:@"PKEntity"];
    NSDictionary *resource = @{@"identifier":@"1",
                               @"to":@[@{@"foo":@"bar"},
                                       @{@"foo":@"bar",
                                         @"from":@{@"identifier":@"2"}}]};
    
    RMDependency *collectedDependency = [[RMDependency alloc] init];
    
    RMDependency *dependency = [entity rm_traverseResource:resource
                                   usingDependencyCallback:^(RMDependency *dependency) {
                                       [collectedDependency union:dependency];
                                   }
                                           mappingCallback:nil];
    XCTAssertNotNil(dependency);
    XCTAssertEqual([dependency.allPaths count], 0);
    
    XCTAssertEqual([collectedDependency.allPaths count], 1);
    
    RMDependency *expectedCollectedDependency = [[RMDependency alloc] init];
    [expectedCollectedDependency pushRelationship:
     (NSRelationshipDescription *)[self propertyWithName:@"from" ofEntity:@"Entity"]];
    
    [expectedCollectedDependency pushRelationship:
     (NSRelationshipDescription *)[self propertyWithName:@"to" ofEntity:@"PKEntity"]];
    
    XCTAssertEqualObjects(collectedDependency, expectedCollectedDependency);
}

@end
