//
//  RMMappingSessionPropertyUpdateTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 23.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMMangedObjectContextTestCase.h"

@interface RMMappingSessionPropertyUpdateTests : RMMangedObjectContextTestCase

@end

@implementation RMMappingSessionPropertyUpdateTests

- (void)testUpdateAttributes
{
    
}

- (void)testUpdateToOneRelationship
{
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Entity"]
                                       insertIntoManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *resource = @{@"foo":@{@"name":@"1"}, @"bar":@{@"name":@"2"}};
    
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    [session updateRelationship:[self relationshipWithName:@"foo" ofEntity:@"Entity"]
                ofManagedObject:object
                  usingResource:resource];
    
    XCTAssertEqualObjects([object valueForKeyPath:@"foo.name"], @"1");
}

- (void)testUpdateToManyRelationship
{
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Entity"]
                                       insertIntoManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *resource = @{@"foos":@[@{@"name":@"1"},@{@"name":@"2"}]};
    
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    [session updateRelationship:[self relationshipWithName:@"foos" ofEntity:@"Entity"]
                ofManagedObject:object
                  usingResource:resource];
    
    NSSet *expectedValues = [NSSet setWithObjects:@"1", @"2", nil];
    XCTAssertEqualObjects([object valueForKeyPath:@"foos.name"], expectedValues);
}

- (void)testUpdateToOneRelationshipWithPK
{
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Entity"]
                                       insertIntoManagedObjectContext:self.managedObjectContext];
    
    NSManagedObject *bar = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Bar"]
                                    insertIntoManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *resource = @{@"foo":@{@"name":@"1"}, @"bar":@{@"name":@"2", @"identifier":@"bar1"}};
    
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    [session setManagedObject:bar forResource:@{@"identifier":@"bar1"}];
    
    [session updateRelationship:[self relationshipWithName:@"bar" ofEntity:@"Entity"]
                ofManagedObject:object
                  usingResource:resource];
    
    XCTAssertEqualObjects([object valueForKey:@"bar"], bar);
}

- (void)testUpdateToManyRelationshipWithPK
{
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Entity"]
                                       insertIntoManagedObjectContext:self.managedObjectContext];
    
    NSManagedObject *bar1 = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Bar"]
                                     insertIntoManagedObjectContext:self.managedObjectContext];
    
    NSManagedObject *bar2 = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Bar"]
                                     insertIntoManagedObjectContext:self.managedObjectContext];
    
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    [session setManagedObject:bar1 forResource:@{@"identifier":@"bar1"}];
    [session setManagedObject:bar2 forResource:@{@"identifier":@"bar2"}];
    
    NSDictionary *resource = @{@"bars":@[@{@"identifier":@"bar1"}, @{@"identifier":@"bar2"}]};
    
    [session updateRelationship:[self relationshipWithName:@"bars" ofEntity:@"Entity"]
                ofManagedObject:object
                  usingResource:resource];
    
    NSSet *expectedValues = [NSSet setWithObjects:bar1, bar2, nil];
    XCTAssertEqualObjects([object valueForKeyPath:@"bars"], expectedValues);
}

@end
