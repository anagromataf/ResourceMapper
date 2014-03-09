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
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    
    [objects addObject:@{@"identifier":@"1", @"name":@"A"}];
    [objects addObject:@{@"identifier":@"2", @"name":@"B"}];
    [objects addObject:@{@"identifier":@"3", @"name":@"C"}];
    [objects addObject:@{@"identifier":@"4", @"name":@"D"}];
    [objects addObject:@{@"identifier":@"5", @"name":@"E"}];
    [objects addObject:@{@"identifier":@"6", @"name":@"F"}];

    RMMappingContext *mappingContext = [[RMMappingContext alloc] init];
    
    [mappingContext addResources:objects usingEntity:[self entityWithName:@"Object"]];
    
    NSArray *entities = mappingContext.entities;
    XCTAssertEqualObjects(entities, @[[self entityWithName:@"Object"]]);
    
    NSDictionary *objectsByPrimaryKey = [mappingContext resourcesByPrimaryKeyOfEntity:[self entityWithName:@"Object"]];
    XCTAssertNotNil(objectsByPrimaryKey);
    
    XCTAssertEqual([objectsByPrimaryKey count], (NSUInteger)6);
}

- (void)testAddResourceTree
{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    
    [objects addObject:@{@"identifier":@"1",
                         @"name":@"A",
                         @"subjectOf": @[
                                 @{@"object": @{@"identifier":@"3"}, @"type":@(3)},
                                 @{@"object": @{@"identifier":@"10"}, @"type":@(10)}
                                 ]}];
    [objects addObject:@{@"identifier":@"2",
                         @"name":@"B"}];
    [objects addObject:@{@"identifier":@"3",
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
    
    [mappingContext addResources:objects usingEntity:[self entityWithName:@"Object"]];
    
    NSArray *entities = mappingContext.entities;
    XCTAssertEqualObjects(entities, @[[self entityWithName:@"Object"]]);
    
    NSDictionary *objectsByPrimaryKey = [mappingContext resourcesByPrimaryKeyOfEntity:[self entityWithName:@"Object"]];
    XCTAssertNotNil(objectsByPrimaryKey);
    
    XCTAssertEqual([objectsByPrimaryKey count], (NSUInteger)6);
}

- (void)testAddDuplicateResource
{
    NSDictionary *resourcesByPrimaryKey;
    NSDictionary *object;
    NSArray *keys = @[@"identifier", @"name", @"summary"];

    RMMappingContext *mappingContext = [[RMMappingContext alloc] init];
    
    object = @{@"identifier":@"1", @"name":@"A", @"summary": @"Foo Bar Baz"};
    [mappingContext addResource:object
                    usingEntity:[self entityWithName:@"Object"]];
    
    resourcesByPrimaryKey = [mappingContext resourcesByPrimaryKeyOfEntity:[self entityWithName:@"Object"]];
    XCTAssertEqualObjects([resourcesByPrimaryKey allKeys], @[@{@"identifier":@"1"}]);
    XCTAssertEqualObjects([[[resourcesByPrimaryKey allValues] firstObject] dictionaryWithValuesForKeys:keys], object);
    
    [mappingContext addResource:@{@"identifier":@"1", @"name":@"B"}
                    usingEntity:[self entityWithName:@"Object"]];
    
    object = @{@"identifier":@"1", @"name":@"B", @"summary": @"Foo Bar Baz"};
    
    resourcesByPrimaryKey = [mappingContext resourcesByPrimaryKeyOfEntity:[self entityWithName:@"Object"]];
    XCTAssertEqualObjects([resourcesByPrimaryKey allKeys], @[@{@"identifier":@"1"}]);
    XCTAssertEqualObjects([[[resourcesByPrimaryKey allValues] firstObject] dictionaryWithValuesForKeys:keys], object);
}

@end
