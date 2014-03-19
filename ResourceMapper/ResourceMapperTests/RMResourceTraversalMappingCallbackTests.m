//
//  RMResourceTraversalMappingCallbackTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 18.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMManagedObjectModelTestCase.h"

@interface RMResourceTraversalMappingCallbackTests : RMManagedObjectModelTestCase

@end

@implementation RMResourceTraversalMappingCallbackTests

- (void)testMappingOfEntityWithPK
{
    NSEntityDescription *entity = [self entityWithName:@"PKEntity"];
    NSDictionary *resource = @{@"identifier":@"1",
                               @"foo":@"bar"};
    
    __block NSUInteger callCount = 0;
    __block NSEntityDescription *mappedEntity = nil;
    __block NSDictionary *mappedPK = nil;
    __block id mappedResource = nil;
    
    void(^mapping)(NSEntityDescription *, NSDictionary *, id) = ^(NSEntityDescription *entity, NSDictionary *pk, id resource) {
        callCount++;
        mappedEntity = entity;
        mappedPK = pk;
        mappedResource = resource;
    };
    
    [entity rm_traverseResource:resource
                      recursive:YES
        usingDependencyCallback:nil
                mappingCallback:mapping];

    XCTAssertEqual(callCount, 1);
 
    XCTAssertEqualObjects(mappedEntity, entity);
    XCTAssertEqualObjects(mappedPK, @{@"identifier":@"1"});
    XCTAssertEqual(mappedResource, resource);
}

- (void)testMappingOfEntityWithouPK
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    NSDictionary *resource = @{@"identifier":@"1", @"foo":@"bar"};
    
    __block NSUInteger callCount = 0;
    
    void(^mapping)(NSEntityDescription *, NSDictionary *, id) = ^(NSEntityDescription *entity, NSDictionary *pk, id resource) {
        callCount++;
    };
    
    [entity rm_traverseResource:resource
                      recursive:YES
        usingDependencyCallback:nil
                mappingCallback:mapping];
    
    XCTAssertEqual(callCount, 0);
}

- (void)testMappingOfSubEntity
{
    NSEntityDescription *entity = [self entityWithName:@"PKEntity"];
    NSEntityDescription *subEntity = [self entityWithName:@"SubEntity"];
    
    NSDictionary *resource = @{@"identifier":@"1",
                               @"foo":@"bar",
                               @"entity":subEntity};
    
    __block NSUInteger callCount = 0;
    __block NSEntityDescription *mappedEntity = nil;
    __block NSDictionary *mappedPK = nil;
    __block id mappedResource = nil;
    
    void(^mapping)(NSEntityDescription *, NSDictionary *, id) = ^(NSEntityDescription *entity, NSDictionary *pk, id resource) {
        callCount++;
        mappedEntity = entity;
        mappedPK = pk;
        mappedResource = resource;
    };
    
    [entity rm_traverseResource:resource
                      recursive:YES
        usingDependencyCallback:nil
                mappingCallback:mapping];
    
    XCTAssertEqual(callCount, 1);
    
    XCTAssertEqualObjects(mappedEntity, subEntity);
    XCTAssertEqualObjects(mappedPK, @{@"identifier":@"1"});
    XCTAssertEqual(mappedResource, resource);
}

@end
