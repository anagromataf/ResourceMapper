//
//  RMMappingStepTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 22.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMManagedObjectModelTestCase.h"

#import "RMMappingStep.h"
#import "RMDependency.h"

@interface RMMappingStepTests : RMManagedObjectModelTestCase

@end

@implementation RMMappingStepTests

- (void)test1
{
    NSMutableSet *entites = [[NSMutableSet alloc] init];
    RMDependency *dependency = [[RMDependency alloc] init];
    
    [entites addObject:[self entityWithName:@"A"]];
    
    NSArray *steps = [RMMappingStep mappingStepsWithEntities:entites dependency:dependency];
    XCTAssertNotNil(steps);

    XCTAssertEqual([steps count], (NSUInteger)1);
    XCTAssertEqualObjects([[steps firstObject] entity], [self entityWithName:@"A"]);
    XCTAssertEqualObjects([[steps firstObject] relationshipsToOmit], [NSSet set]);
}

- (void)test2
{
    NSMutableSet *entites = [[NSMutableSet alloc] init];
    RMDependency *dependency = [[RMDependency alloc] init];
    
    [entites addObject:[self entityWithName:@"A"]];
    [dependency pushRelationship:(NSRelationshipDescription *)[self propertyWithName:@"children" ofEntity:@"A"]];
    
    NSArray *steps = [RMMappingStep mappingStepsWithEntities:entites dependency:dependency];
    XCTAssertNotNil(steps);
    
    
    XCTAssertEqual([steps count], (NSUInteger)1);
    XCTAssertEqualObjects([[steps firstObject] entity],
                          [self entityWithName:@"A"]);
    
    RMRelationshipPath *path = [[RMRelationshipPath alloc] init];
    [path push:(NSRelationshipDescription *)[self propertyWithName:@"children" ofEntity:@"A"]];
    XCTAssertEqualObjects([[steps firstObject] relationshipsToOmit],
                          [NSSet setWithObject:path]);
}

- (void)test3
{
    NSMutableSet *entites = [[NSMutableSet alloc] init];
    RMDependency *dependency = [[RMDependency alloc] init];
    
    [entites addObject:[self entityWithName:@"A"]];
    [entites addObject:[self entityWithName:@"B"]];
    
    [dependency pushRelationship:(NSRelationshipDescription *)[self propertyWithName:@"toB" ofEntity:@"A"]];
    
    NSArray *steps = [RMMappingStep mappingStepsWithEntities:entites dependency:dependency];
    XCTAssertNotNil(steps);
    
    XCTAssertEqual([steps count], (NSUInteger)2);
    XCTAssertEqualObjects([[steps objectAtIndex:0] entity], [self entityWithName:@"B"]);
    XCTAssertEqualObjects([[steps objectAtIndex:0] relationshipsToOmit], [NSSet set]);
    
    XCTAssertEqualObjects([[steps objectAtIndex:1] entity], [self entityWithName:@"A"]);
    XCTAssertEqualObjects([[steps objectAtIndex:1] relationshipsToOmit], [NSSet set]);
}

- (void)test4
{
    NSMutableSet *entites = [[NSMutableSet alloc] init];
    RMDependency *dependency = [[RMDependency alloc] init];
    
    [entites addObject:[self entityWithName:@"A"]];
    [entites addObject:[self entityWithName:@"B"]];
    
    [dependency pushRelationship:(NSRelationshipDescription *)[self propertyWithName:@"toB" ofEntity:@"A"]];
    [dependency union:[RMDependency dependencyWithRelationship:(NSRelationshipDescription *)[self propertyWithName:@"children" ofEntity:@"A"]]];
    
    NSArray *steps = [RMMappingStep mappingStepsWithEntities:entites dependency:dependency];
    XCTAssertNotNil(steps);
    
    XCTAssertEqual([steps count], (NSUInteger)2);
    XCTAssertEqualObjects([[steps objectAtIndex:0] entity], [self entityWithName:@"B"]);
    XCTAssertEqualObjects([[steps objectAtIndex:0] relationshipsToOmit], [NSSet set]);
    
    RMRelationshipPath *path = [[RMRelationshipPath alloc] init];
    [path push:(NSRelationshipDescription *)[self propertyWithName:@"children" ofEntity:@"A"]];
    XCTAssertEqualObjects([[steps objectAtIndex:1] entity], [self entityWithName:@"A"]);
    XCTAssertEqualObjects([[steps objectAtIndex:1] relationshipsToOmit], [NSSet setWithObject:path]);
}

- (void)test5
{
    NSMutableSet *entites = [[NSMutableSet alloc] init];
    RMDependency *dependency = [[RMDependency alloc] init];
    
    [entites addObject:[self entityWithName:@"A"]];
    [entites addObject:[self entityWithName:@"B"]];
    
    [dependency pushRelationship:(NSRelationshipDescription *)[self propertyWithName:@"toB" ofEntity:@"A"]];
    [dependency union:[RMDependency dependencyWithRelationship:(NSRelationshipDescription *)[self propertyWithName:@"toA" ofEntity:@"B"]]];
    
    NSArray *steps = [RMMappingStep mappingStepsWithEntities:entites dependency:dependency];
    XCTAssertNotNil(steps);
    
    XCTAssertEqual([steps count], (NSUInteger)2);
    XCTAssertEqualObjects([[steps objectAtIndex:0] entity], [self entityWithName:@"A"]);
    XCTAssertEqualObjects([[steps objectAtIndex:1] entity], [self entityWithName:@"B"]);
    
    RMRelationshipPath *path = [[RMRelationshipPath alloc] init];
    [path push:(NSRelationshipDescription *)[self propertyWithName:@"toB" ofEntity:@"A"]];
    XCTAssertEqualObjects([[steps objectAtIndex:0] relationshipsToOmit], [NSSet setWithObject:path]);
    
    XCTAssertEqualObjects([[steps objectAtIndex:1] relationshipsToOmit], [NSSet set]);
}

- (void)test6
{
    NSMutableSet *entites = [[NSMutableSet alloc] init];
    RMDependency *dependency = [[RMDependency alloc] init];
    
    [entites addObject:[self entityWithName:@"A"]];
    [entites addObject:[self entityWithName:@"B"]];
    [entites addObject:[self entityWithName:@"C"]];
    
    [dependency pushRelationship:(NSRelationshipDescription *)[self propertyWithName:@"toB" ofEntity:@"A"]];
    [dependency union:[RMDependency dependencyWithRelationship:(NSRelationshipDescription *)[self propertyWithName:@"toC" ofEntity:@"A"]]];
    [dependency union:[RMDependency dependencyWithRelationship:(NSRelationshipDescription *)[self propertyWithName:@"toC" ofEntity:@"B"]]];
    
    NSArray *steps = [RMMappingStep mappingStepsWithEntities:entites dependency:dependency];
    XCTAssertNotNil(steps);
    
    XCTAssertEqual([steps count], (NSUInteger)3);
    XCTAssertEqualObjects([[steps objectAtIndex:0] entity], [self entityWithName:@"C"]);
    XCTAssertEqualObjects([[steps objectAtIndex:1] entity], [self entityWithName:@"B"]);
    XCTAssertEqualObjects([[steps objectAtIndex:2] entity], [self entityWithName:@"A"]);
    
    XCTAssertEqualObjects([[steps objectAtIndex:0] relationshipsToOmit], [NSSet set]);
    XCTAssertEqualObjects([[steps objectAtIndex:1] relationshipsToOmit], [NSSet set]);
    XCTAssertEqualObjects([[steps objectAtIndex:2] relationshipsToOmit], [NSSet set]);
}

- (void)test7
{
    NSMutableSet *entites = [[NSMutableSet alloc] init];
    RMDependency *dependency = [[RMDependency alloc] init];
    
    [entites addObject:[self entityWithName:@"A"]];
    [entites addObject:[self entityWithName:@"B"]];
    [entites addObject:[self entityWithName:@"C"]];
    
    [dependency pushRelationship:(NSRelationshipDescription *)[self propertyWithName:@"toB" ofEntity:@"A"]];
    [dependency union:[RMDependency dependencyWithRelationship:(NSRelationshipDescription *)[self propertyWithName:@"toC" ofEntity:@"B"]]];
    [dependency union:[RMDependency dependencyWithRelationship:(NSRelationshipDescription *)[self propertyWithName:@"toA" ofEntity:@"C"]]];
    
    NSArray *steps = [RMMappingStep mappingStepsWithEntities:entites dependency:dependency];
    XCTAssertNotNil(steps);
    
    XCTAssertEqual([steps count], (NSUInteger)3);
    XCTAssertEqualObjects([[steps objectAtIndex:0] entity], [self entityWithName:@"A"]);
    XCTAssertEqualObjects([[steps objectAtIndex:1] entity], [self entityWithName:@"C"]);
    XCTAssertEqualObjects([[steps objectAtIndex:2] entity], [self entityWithName:@"B"]);
    
    RMRelationshipPath *path = [[RMRelationshipPath alloc] init];
    [path push:(NSRelationshipDescription *)[self propertyWithName:@"toB" ofEntity:@"A"]];
    XCTAssertEqualObjects([[steps objectAtIndex:0] relationshipsToOmit], [NSSet setWithObject:path]);
    
    XCTAssertEqualObjects([[steps objectAtIndex:1] relationshipsToOmit], [NSSet set]);
    XCTAssertEqualObjects([[steps objectAtIndex:2] relationshipsToOmit], [NSSet set]);
}

- (void)test8
{
    NSMutableSet *entites = [[NSMutableSet alloc] init];
    RMDependency *dependency = [[RMDependency alloc] init];
    
    [entites addObject:[self entityWithName:@"A"]];
    [entites addObject:[self entityWithName:@"B"]];
    
    [dependency pushRelationship:(NSRelationshipDescription *)[self propertyWithName:@"toB" ofEntity:@"A"]];
    [dependency union:[RMDependency dependencyWithRelationship:(NSRelationshipDescription *)[self propertyWithName:@"children" ofEntity:@"A"]]];
    [dependency union:[RMDependency dependencyWithRelationship:(NSRelationshipDescription *)[self propertyWithName:@"children" ofEntity:@"B"]]];
    
    NSArray *steps = [RMMappingStep mappingStepsWithEntities:entites dependency:dependency];
    XCTAssertNotNil(steps);
    
    XCTAssertEqual([steps count], (NSUInteger)2);
    XCTAssertEqualObjects([[steps objectAtIndex:0] entity], [self entityWithName:@"B"]);
    XCTAssertEqualObjects([[steps objectAtIndex:1] entity], [self entityWithName:@"A"]);
    
    RMRelationshipPath *path1 = [[RMRelationshipPath alloc] init];
    [path1 push:(NSRelationshipDescription *)[self propertyWithName:@"children" ofEntity:@"B"]];
    XCTAssertEqualObjects([[steps objectAtIndex:0] relationshipsToOmit], [NSSet setWithObject:path1]);
    
    RMRelationshipPath *path2 = [[RMRelationshipPath alloc] init];
    [path2 push:(NSRelationshipDescription *)[self propertyWithName:@"children" ofEntity:@"A"]];
    XCTAssertEqualObjects([[steps objectAtIndex:1] relationshipsToOmit], [NSSet setWithObject:path2]);
}

@end
