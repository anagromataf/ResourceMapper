//
//  NSManagedObjectContext_CombineResourcesTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 03.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "ResourceMapper.h"
#import "ResourceMapper+Private.h"

#import "RMMangedObjectContextTestCase.h"

@interface NSManagedObjectContext_CombineResourcesTests : RMMangedObjectContextTestCase

@end

@implementation NSManagedObjectContext_CombineResourcesTests

- (void)setUp
{
    [super setUp];
    
    NSEntityDescription *entity = [self entityWithName:@"Item"];
    
    for (int x = 0; x < 10; x++) {
        for (int y = 0; y < 10; y++) {
            for (int z = 0; z < 10; z++) {
                NSManagedObject *item = [[NSManagedObject alloc] initWithEntity:entity
                                                 insertIntoManagedObjectContext:self.managedObjectContext];
                [item setValuesForKeysWithDictionary:@{@"x":@(x), @"y":@(y), @"z":@(z)}];
            }
        }
    }
    NSError *error = nil;
    BOOL success = [self.managedObjectContext save:&error];
    XCTAssertTrue(success, @"%@", [error localizedDescription]);
}

#pragma mark Tests

- (void)testCombineObjects
{
    NSEntityDescription *entity = [self entityWithName:@"Item"];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"x" ascending:YES],
                                 [NSSortDescriptor sortDescriptorWithKey:@"y" ascending:YES],
                                 [NSSortDescriptor sortDescriptorWithKey:@"z" ascending:YES]];
    
    NSArray *resources = @[@{@"x":@(10), @"y":@(5), @"z":@(0)},
                           @{@"x":@(8), @"y":@(5), @"z":@(2)},
                           @{@"x":@(4), @"y":@(3), @"z":@(2)},
                           @{@"x":@(6), @"y":@(7), @"z":@(1)},
                           @{@"x":@(3), @"y":@(2), @"z":@(10)},
                           @{@"x":@(1), @"y":@(10), @"z":@(10)}];
    
    __block NSMutableSet *newObjects = [[NSMutableSet alloc] init];
    __block NSMutableSet *matchingObjects = [[NSMutableSet alloc] init];
    __block NSMutableSet *remainingObjects = [[NSMutableSet alloc] init];
    
    void(^_newObjectHandler)(id newObject, NSEntityDescription *entity) = ^(id newObject, NSEntityDescription *entity) {
        [newObjects addObject:newObject];
    };
    
    void(^_matchingObjectHandler)(NSManagedObject *managedObject, id resource) = ^(NSManagedObject *managedObjects, id resource) {
        [matchingObjects addObject:resource];
    };
    
    void(^_remainingObjectHandler)(NSManagedObject *managedObject) = ^(NSManagedObject *managedObject) {
        [remainingObjects addObject:[managedObject dictionaryWithValuesForKeys:@[@"x", @"y", @"z"]]];
    };
    
    NSError *error = nil;
    
    BOOL success = [self.managedObjectContext rm_combineResources:resources
                                              withObjectsOfEntity:entity
                                                matchingPredicate:nil
                                             usingSortDescriptors:sortDescriptors
                                                     sortInMemory:YES
                                                 newObjectHandler:_newObjectHandler
                                            matchingObjectHandler:_matchingObjectHandler
                                           remainingObjectHandler:_remainingObjectHandler
                                                            error:&error];
    
    XCTAssertTrue(success, @"Failed to merge obejcts: %@", [error localizedDescription]);
    
    XCTAssertEqual([newObjects count], (NSUInteger)3);
    XCTAssertEqual([matchingObjects count], (NSUInteger)3);
    XCTAssertEqual([remainingObjects count], (NSUInteger)997);
    
    NSSet *expectedNewObjects = [NSSet setWithObjects:
                                 @{@"x":@(10), @"y":@(5), @"z":@(0)},
                                 @{@"x":@(3), @"y":@(2), @"z":@(10)},
                                 @{@"x":@(1), @"y":@(10), @"z":@(10)},
                                 nil];
    XCTAssertEqualObjects(newObjects, expectedNewObjects);
    
    NSSet *expectedMatchingObjects = [NSSet setWithObjects:
                                      @{@"x":@(8), @"y":@(5), @"z":@(2)},
                                      @{@"x":@(4), @"y":@(3), @"z":@(2)},
                                      @{@"x":@(6), @"y":@(7), @"z":@(1)},
                                      nil];
    XCTAssertEqualObjects(matchingObjects, expectedMatchingObjects);
    
    XCTAssertFalse([newObjects isSubsetOfSet:remainingObjects]);
    XCTAssertFalse([matchingObjects isSubsetOfSet:remainingObjects]);
}

@end
