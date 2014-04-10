//
//  RMMappingContext_AddResourcesTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 09.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMManagedObjectModelTestCase.h"

@interface RMMappingContext_AddResourcesTests : RMManagedObjectModelTestCase

@end

@implementation RMMappingContext_AddResourcesTests

- (void)testAddResources
{
    NSMutableArray *resources = [[NSMutableArray alloc] init];
    
    [resources addObject:@{@"identifier":@"1", @"name":@"A"}];
    [resources addObject:@{@"identifier":@"2", @"name":@"B"}];
    [resources addObject:@{@"identifier":@"3", @"name":@"C"}];
    [resources addObject:@{@"identifier":@"4", @"name":@"D"}];
    [resources addObject:@{@"identifier":@"5", @"name":@"E"}];
    [resources addObject:@{@"identifier":@"6", @"name":@"F"}];
    
    RMMappingContext *mappingContext = [[RMMappingContext alloc] init];
    
    [mappingContext addResources:resources usingEntity:[self entityWithName:@"Object"]];
    
    NSArray *entities = mappingContext.entities;
    XCTAssertEqualObjects(entities, @[[self entityWithName:@"Object"]]);
    
    NSDictionary *resourcesByPrimaryKey = [mappingContext resourcesByPrimaryKeyOfEntity:[self entityWithName:@"Object"]];
    XCTAssertNotNil(resourcesByPrimaryKey);
    
    XCTAssertEqual([resourcesByPrimaryKey count], (NSUInteger)6);
}

- (void)testAddResourceTree
{
    NSMutableArray *resources = [[NSMutableArray alloc] init];
    
    [resources addObject:@{@"identifier":@"1",
                         @"name":@"A",
                         @"subjectOf": @[
                                 @{@"object": @{@"identifier":@"3"}, @"type":@(3)},
                                 @{@"object": @{@"identifier":@"10"}, @"type":@(10)}
                                 ]}];
    [resources addObject:@{@"identifier":@"2",
                         @"name":@"B"}];
    [resources addObject:@{@"identifier":@"3",
                         @"name":@"C",
                         @"subjectOf" : @[
                                @{@"object": @{
                                          @"identifier":@"4",
                                          @"subjectOf":@[
                                                  @{@"object": @{
                                                            @"identifier":@"5"
                                                            }, @"type":@(5)}]
                                          }, @"type":@(4)}
                                ]
                         }];
    
    RMMappingContext *mappingContext = [[RMMappingContext alloc] init];
    
    [mappingContext addResources:resources usingEntity:[self entityWithName:@"Object"]];
    
    NSArray *entities = mappingContext.entities;
    XCTAssertEqualObjects(entities, @[[self entityWithName:@"Object"]]);
    
    NSDictionary *resourcesByPrimaryKey = [mappingContext resourcesByPrimaryKeyOfEntity:[self entityWithName:@"Object"]];
    XCTAssertNotNil(resourcesByPrimaryKey);
    
    XCTAssertEqual([resourcesByPrimaryKey count], (NSUInteger)6);
    
    RMDependency *dependency = [mappingContext dependencyOfEntity:[self entityWithName:@"Object"]];
    XCTAssertEqual([dependency.allPaths count], 1);
    XCTAssertEqualObjects([dependency.allPaths valueForKeyPath:@"tailEntity"],
                          [NSSet setWithObject:[self entityWithName:@"Object"]]);
}

- (void)testAddDuplicateResource
{
    NSDictionary *resourcesByPrimaryKey;
    NSDictionary *resource;
    NSArray *keys = @[@"identifier", @"name", @"summary"];

    RMMappingContext *mappingContext = [[RMMappingContext alloc] init];
    
    resource = @{@"identifier":@"1", @"name":@"A", @"summary": @"Foo Bar Baz"};
    [mappingContext addResource:resource
                    usingEntity:[self entityWithName:@"Object"]];
    
    resourcesByPrimaryKey = [mappingContext resourcesByPrimaryKeyOfEntity:[self entityWithName:@"Object"]];
    XCTAssertEqualObjects([resourcesByPrimaryKey allKeys], @[@{@"identifier":@"1"}]);
    XCTAssertEqualObjects([[[resourcesByPrimaryKey allValues] firstObject] dictionaryWithValuesForKeys:keys], resource);
    
    [mappingContext addResource:@{@"identifier":@"1", @"name":@"B"}
                    usingEntity:[self entityWithName:@"Object"]];
    
    resource = @{@"identifier":@"1", @"name":@"B", @"summary": @"Foo Bar Baz"};
    
    resourcesByPrimaryKey = [mappingContext resourcesByPrimaryKeyOfEntity:[self entityWithName:@"Object"]];
    XCTAssertEqualObjects([resourcesByPrimaryKey allKeys], @[@{@"identifier":@"1"}]);
    XCTAssertEqualObjects([[[resourcesByPrimaryKey allValues] firstObject] dictionaryWithValuesForKeys:keys], resource);
}

@end
