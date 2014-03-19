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
    
    NSMutableArray *path = [[NSMutableArray alloc] init];
    
    [path rm_push:fromBtoX];
    
    XCTAssertEqual([path count], 1);
    XCTAssertEqualObjects([path objectAtIndex:0], fromBtoX);
    
    [path rm_push:fromAtoB];
    
    XCTAssertEqual([path count], 2);
    XCTAssertEqualObjects([path objectAtIndex:0], fromAtoB);
    XCTAssertEqualObjects([path objectAtIndex:1], fromBtoX);
}

- (void)testPathEquality
{
    NSEntityDescription *A = [self entityWithName:@"A"];
    NSEntityDescription *B = [self entityWithName:@"B"];
    
    NSRelationshipDescription *fromBtoX = [[B relationshipsByName] valueForKey:@"toX"];
    NSRelationshipDescription *fromAtoB = [[A relationshipsByName] valueForKey:@"toB"];
    
    NSMutableArray *path1 = [[NSMutableArray alloc] init];
    [path1 rm_push:fromBtoX];
    [path1 rm_push:fromAtoB];
    
    NSMutableArray *path2 = [[NSMutableArray alloc] init];
    [path2 rm_push:fromBtoX];
    [path2 rm_push:fromAtoB];
    
    XCTAssertEqualObjects(path1, path2);
}

- (void)testAddDifferentPath
{
    NSMutableSet *pathSet = [[NSMutableSet alloc] init];
    
    NSEntityDescription *A = [self entityWithName:@"A"];
    NSEntityDescription *B = [self entityWithName:@"B"];
    
    NSRelationshipDescription *fromBtoX = [[B relationshipsByName] valueForKey:@"toX"];
    NSRelationshipDescription *fromBtoY = [[B relationshipsByName] valueForKey:@"toY"];
    NSRelationshipDescription *fromAtoB = [[A relationshipsByName] valueForKey:@"toB"];
    
    NSMutableArray *path1 = [[NSMutableArray alloc] init];
    [path1 rm_push:fromBtoY];
    [path1 rm_push:fromAtoB];
    
    NSMutableArray *path2 = [[NSMutableArray alloc] init];
    [path2 rm_push:fromBtoX];
    [path2 rm_push:fromAtoB];
    
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
    
    NSMutableArray *path1 = [[NSMutableArray alloc] init];
    [path1 rm_push:fromBtoX];
    [path1 rm_push:fromAtoB];
    
    NSMutableArray *path2 = [[NSMutableArray alloc] init];
    [path2 rm_push:fromBtoX];
    [path2 rm_push:fromAtoB];
    
    [pathSet addObject:path1];
    [pathSet addObject:path2];
    
    XCTAssertEqual([pathSet count], 1);
}

- (void)testPerformSelectorOnPaths
{
    NSMutableSet *pathSet = [[NSMutableSet alloc] init];
    
    NSEntityDescription *A = [self entityWithName:@"A"];
    NSEntityDescription *B = [self entityWithName:@"B"];
    
    NSRelationshipDescription *fromBtoX = [[B relationshipsByName] valueForKey:@"toX"];
    NSRelationshipDescription *fromBtoY = [[B relationshipsByName] valueForKey:@"toY"];
    NSRelationshipDescription *fromAtoB = [[A relationshipsByName] valueForKey:@"toB"];
    
    NSMutableArray *path1 = [[NSMutableArray alloc] init];
    [path1 rm_push:fromBtoX];
    
    NSMutableArray *path2 = [[NSMutableArray alloc] init];
    [path2 rm_push:fromBtoY];
    
    [pathSet addObject:path1];
    [pathSet addObject:path2];
    
    XCTAssertEqual([pathSet count], 2);
    
    [pathSet makeObjectsPerformSelector:@selector(rm_push:) withObject:fromAtoB];

    XCTAssertEqual([pathSet count], 2);
    
    XCTAssertEqual([path1 count], 2);
    XCTAssertEqualObjects([path1 objectAtIndex:0], fromAtoB);
    XCTAssertEqualObjects([path1 objectAtIndex:1], fromBtoX);
    
    XCTAssertEqual([path2 count], 2);
    XCTAssertEqualObjects([path2 objectAtIndex:0], fromAtoB);
    XCTAssertEqualObjects([path2 objectAtIndex:1], fromBtoY);
}

- (void)testUnionPathsSets
{
    NSEntityDescription *A = [self entityWithName:@"A"];
    NSEntityDescription *B = [self entityWithName:@"B"];
    
    NSRelationshipDescription *fromBtoX = [[B relationshipsByName] valueForKey:@"toX"];
    NSRelationshipDescription *fromBtoY = [[B relationshipsByName] valueForKey:@"toY"];
    NSRelationshipDescription *fromAtoB = [[A relationshipsByName] valueForKey:@"toB"];
    
    NSMutableArray *path1 = [[NSMutableArray alloc] init];
    [path1 rm_push:fromBtoX];
    [path1 rm_push:fromAtoB];
    
    NSMutableSet *pathSet1 = [[NSMutableSet alloc] init];
    NSMutableSet *pathSet2 = [[NSMutableSet alloc] init];

    [pathSet1 addObject:path1];
    
    [pathSet2 unionSet:pathSet1];
    
    XCTAssertTrue([pathSet2 containsObject:path1]);
}

@end
