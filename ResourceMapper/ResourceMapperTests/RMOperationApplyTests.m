//
//  RMOperationApplyTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 23.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMMangedObjectContextTestCase.h"

@interface RMOperationApplyTests : RMMangedObjectContextTestCase

@end

@implementation RMOperationApplyTests

- (void)testApplyEmptyOperation
{
    NSMutableArray *resources = [[NSMutableArray alloc] init];
    
    RMMappingContext *mappingContext = [[RMMappingContext alloc] init];
    [mappingContext addResources:resources usingEntity:[self entityWithName:@"Object"]];
    
    RMUpdateOrInsertOperation *operation = [[RMUpdateOrInsertOperation alloc] initWithMappingContext:mappingContext];
    
    NSError *error = nil;
    RMMappingSession *session = [operation applyToManagedObjectContext:self.managedObjectContext
                                                                 error:&error];
    XCTAssertNotNil(session);
}

- (void)testApplyOperation
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

    RMUpdateOrInsertOperation *operation = [[RMUpdateOrInsertOperation alloc] initWithMappingContext:mappingContext];
    
    NSError *error = nil;
    RMMappingSession *session = [operation applyToManagedObjectContext:self.managedObjectContext
                                                                 error:&error];
    XCTAssertNotNil(session);
    
    NSManagedObject *object1 = [session managedObjectForResource:@{@"identifier":@"1"} usingEntity:[self entityWithName:@"Object"]];
    NSManagedObject *object2 = [session managedObjectForResource:@{@"identifier":@"2"} usingEntity:[self entityWithName:@"Object"]];
    NSManagedObject *object3 = [session managedObjectForResource:@{@"identifier":@"3"} usingEntity:[self entityWithName:@"Object"]];
    NSManagedObject *object4 = [session managedObjectForResource:@{@"identifier":@"4"} usingEntity:[self entityWithName:@"Object"]];
    NSManagedObject *object5 = [session managedObjectForResource:@{@"identifier":@"5"} usingEntity:[self entityWithName:@"Object"]];

    XCTAssertEqualObjects([object1 valueForKey:@"identifier"], @"1");
    XCTAssertEqualObjects([object2 valueForKey:@"identifier"], @"2");
    XCTAssertEqualObjects([object3 valueForKey:@"identifier"], @"3");
    XCTAssertEqualObjects([object4 valueForKey:@"identifier"], @"4");
    XCTAssertEqualObjects([object5 valueForKey:@"identifier"], @"5");
    
    XCTAssertEqual([[object1 valueForKeyPath:@"subjectOf"] count], (NSUInteger)2);
    XCTAssertEqual([[object2 valueForKeyPath:@"subjectOf"] count], (NSUInteger)0);
    XCTAssertEqual([[object3 valueForKeyPath:@"subjectOf"] count], (NSUInteger)1);
    
    XCTAssertEqual([[self.managedObjectContext insertedObjects] count], (NSUInteger)10);
}

@end
