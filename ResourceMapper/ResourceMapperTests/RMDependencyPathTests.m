//
//  RMDependencyPathTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 18.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMManagedObjectModelTestCase.h"

@interface RMDependencyPathTests : RMManagedObjectModelTestCase

@end

@implementation RMDependencyPathTests

- (void)testPushRelationship
{
    NSEntityDescription *A = [self entityWithName:@"A"];
    NSEntityDescription *B = [self entityWithName:@"B"];
    
    NSRelationshipDescription *fromBtoX = [[B relationshipsByName] valueForKey:@"toX"];
    NSRelationshipDescription *fromAtoB = [[A relationshipsByName] valueForKey:@"toB"];
 
    RMRelationshipPath *path = [[RMRelationshipPath alloc] init];
    
    [path push:fromBtoX];
    
    XCTAssertEqual([path.allRelationships count], 1);
    XCTAssertEqualObjects([path.allRelationships objectAtIndex:0], fromBtoX);
    
    [path push:fromAtoB];
    
    XCTAssertEqual([path.allRelationships count], 2);
    XCTAssertEqualObjects([path.allRelationships objectAtIndex:0], fromAtoB);
    XCTAssertEqualObjects([path.allRelationships objectAtIndex:1], fromBtoX);
}

- (void)testPathEquality
{
    NSEntityDescription *A = [self entityWithName:@"A"];
    NSEntityDescription *B = [self entityWithName:@"B"];
    
    NSRelationshipDescription *fromBtoX = [[B relationshipsByName] valueForKey:@"toX"];
    NSRelationshipDescription *fromAtoB = [[A relationshipsByName] valueForKey:@"toB"];
    
    RMRelationshipPath *path1 = [[RMRelationshipPath alloc] init];
    [path1 push:fromBtoX];
    [path1 push:fromAtoB];
    
    RMRelationshipPath *path2 = [[RMRelationshipPath alloc] init];
    [path2 push:fromBtoX];
    [path2 push:fromAtoB];
    
    XCTAssertEqualObjects(path1, path2);
}

- (void)testAddDifferentPathToSet
{
    NSMutableSet *pathSet = [[NSMutableSet alloc] init];
    
    NSEntityDescription *A = [self entityWithName:@"A"];
    NSEntityDescription *B = [self entityWithName:@"B"];
    
    NSRelationshipDescription *fromBtoX = [[B relationshipsByName] valueForKey:@"toX"];
    NSRelationshipDescription *fromBtoY = [[B relationshipsByName] valueForKey:@"toY"];
    NSRelationshipDescription *fromAtoB = [[A relationshipsByName] valueForKey:@"toB"];
    
    RMRelationshipPath *path1 = [[RMRelationshipPath alloc] init];
    [path1 push:fromBtoY];
    [path1 push:fromAtoB];
    
    RMRelationshipPath *path2 = [[RMRelationshipPath alloc] init];
    [path2 push:fromBtoX];
    [path2 push:fromAtoB];
    
    [pathSet addObject:path1];
    [pathSet addObject:path2];
    
    XCTAssertEqual([pathSet count], 2);
}

- (void)testAddSamePath
{
    NSMutableSet *pathSet = [[NSMutableSet alloc] init];
    
    NSEntityDescription *A = [self entityWithName:@"A"];
    NSEntityDescription *B = [self entityWithName:@"B"];
    
    NSRelationshipDescription *fromBtoX = [[B relationshipsByName] valueForKey:@"toX"];
    NSRelationshipDescription *fromAtoB = [[A relationshipsByName] valueForKey:@"toB"];
    
    RMRelationshipPath *path1 = [[RMRelationshipPath alloc] init];
    [path1 push:fromBtoX];
    [path1 push:fromAtoB];
    
    RMRelationshipPath *path2 = [[RMRelationshipPath alloc] init];
    [path2 push:fromBtoX];
    [path2 push:fromAtoB];
    
    [pathSet addObject:path1];
    [pathSet addObject:path2];
    
    XCTAssertEqual([pathSet count], 1);
}

- (void)testUnionPathsSets
{
    NSEntityDescription *A = [self entityWithName:@"A"];
    NSEntityDescription *B = [self entityWithName:@"B"];
    
    NSRelationshipDescription *fromBtoX = [[B relationshipsByName] valueForKey:@"toX"];
    NSRelationshipDescription *fromAtoB = [[A relationshipsByName] valueForKey:@"toB"];
    
    RMRelationshipPath *path1 = [[RMRelationshipPath alloc] init];
    [path1 push:fromBtoX];
    [path1 push:fromAtoB];
    
    NSMutableSet *pathSet1 = [[NSMutableSet alloc] init];
    NSMutableSet *pathSet2 = [[NSMutableSet alloc] init];

    [pathSet1 addObject:path1];
    
    [pathSet2 unionSet:pathSet1];
    
    XCTAssertTrue([pathSet2 containsObject:path1]);
}

- (void)testPushToDependency
{
    NSEntityDescription *A = [self entityWithName:@"A"];
    NSEntityDescription *B = [self entityWithName:@"B"];
    
    NSRelationshipDescription *fromBtoX = [[B relationshipsByName] valueForKey:@"toX"];
    NSRelationshipDescription *fromAtoB = [[A relationshipsByName] valueForKey:@"toB"];
    
    RMDependency *dependency = [[RMDependency alloc] init];
    
    [dependency pushRelationship:fromBtoX];
    [dependency pushRelationship:fromAtoB];
    
    RMRelationshipPath *path = [[RMRelationshipPath alloc] init];
    [path push:fromBtoX];
    [path push:fromAtoB];
    
    XCTAssertEqual([dependency.allPaths count], 1);
    XCTAssertEqualObjects([dependency.allPaths anyObject], path);
}

- (void)testCombineDependencies
{
    NSEntityDescription *A = [self entityWithName:@"A"];
    NSEntityDescription *B = [self entityWithName:@"B"];
    
    NSRelationshipDescription *fromBtoX = [[B relationshipsByName] valueForKey:@"toX"];
    NSRelationshipDescription *fromBtoY = [[B relationshipsByName] valueForKey:@"toY"];
    NSRelationshipDescription *fromAtoB = [[A relationshipsByName] valueForKey:@"toB"];
    
    RMDependency *dependency1 = [[RMDependency alloc] init];
    [dependency1 pushRelationship:fromBtoX];
    
    RMDependency *dependency2 = [[RMDependency alloc] init];
    [dependency2 pushRelationship:fromBtoY];
    
    RMDependency *dependency3 = [[RMDependency alloc] init];
    [dependency3 pushRelationship:fromBtoY];
    
    [dependency1 union:dependency2];
    [dependency1 union:dependency3];
    XCTAssertEqual([dependency1.allPaths count], 2);
    
    [dependency1 pushRelationship:fromAtoB];
    XCTAssertEqual([dependency1.allPaths count], 2);
    
    RMRelationshipPath *path1 = [[RMRelationshipPath alloc] init];
    [path1 push:fromBtoY];
    [path1 push:fromAtoB];
    
    RMRelationshipPath *path2 = [[RMRelationshipPath alloc] init];
    [path2 push:fromBtoX];
    [path2 push:fromAtoB];
    
    XCTAssertTrue([dependency1.allPaths containsObject:path1]);
    XCTAssertTrue([dependency1.allPaths containsObject:path2]);
}

@end
