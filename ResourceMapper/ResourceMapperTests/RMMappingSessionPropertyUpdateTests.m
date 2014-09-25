//
//  RMMappingSessionPropertyUpdateTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 23.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMMangedObjectContextTestCase.h"
#import "NSRelationshipDescription+Private.h"

@interface RMMappingSessionPropertyUpdateTests : RMMangedObjectContextTestCase

@end

@implementation RMMappingSessionPropertyUpdateTests

- (void)testUpdateAttributes
{
    
}

- (void)testUpdateRelationships
{
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Entity"]
                                       insertIntoManagedObjectContext:self.managedObjectContext];
    
    NSManagedObject *bar = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Bar"]
                                    insertIntoManagedObjectContext:self.managedObjectContext];
    
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    [session setManagedObject:bar forResource:@{@"identifier":@"bar1"}];
    
    NSDictionary *resource = @{@"foo":@{@"name":@"1"}, @"bar":@{@"identifier":@"bar1"}};
    
    [session updateRelationshipsOfManagedObject:object
                                  withResource:resource
                                           omitRelationships:nil];
    
    XCTAssertEqualObjects([object valueForKeyPath:@"foo.name"], @"1");
    XCTAssertEqualObjects([object valueForKey:@"bar"], bar);
}

- (void)testUpdateRelationshipsOmittingRelationship
{
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Entity"]
                                       insertIntoManagedObjectContext:self.managedObjectContext];
    
    NSManagedObject *bar = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Bar"]
                                     insertIntoManagedObjectContext:self.managedObjectContext];
    
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    [session setManagedObject:bar forResource:@{@"identifier":@"bar1"}];

    NSDictionary *resource = @{@"foo":@{@"name":@"1"}, @"bar":@{@"identifier":@"bar1"}};
    
    [session updateRelationshipsOfManagedObject:object
                                  withResource:resource
                                           omitRelationships:[NSSet setWithObject:[self relationshipWithName:@"foo" ofEntity:@"Entity"]]];
    
    XCTAssertEqualObjects([object valueForKey:@"bar"], bar);
}

- (void)testUpdateToOneRelationship
{
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Entity"]
                                       insertIntoManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *resource = @{@"foo":@{@"name":@"1"}, @"bar":@{@"name":@"2"}};
    
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    [session updateRelationship:[self relationshipWithName:@"foo" ofEntity:@"Entity"]
                ofManagedObject:object
                  withResource:resource];
    
    XCTAssertEqualObjects([object valueForKeyPath:@"foo.name"], @"1");
}

- (void)testUpdateToOneRelationshipWithNull
{
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Entity"]
                                       insertIntoManagedObjectContext:self.managedObjectContext];
    
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    [session updateRelationship:[self relationshipWithName:@"foo" ofEntity:@"Entity"]
                ofManagedObject:object
                   withResource:[NSNull null]];
    
    XCTAssertNil([object valueForKeyPath:@"foo"]);
}

- (void)testUpdateToManyRelationship
{
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Entity"]
                                       insertIntoManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *resource = @{@"foos":@[@{@"name":@"1"},@{@"name":@"2"}]};
    
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    [session updateRelationship:[self relationshipWithName:@"foos" ofEntity:@"Entity"]
                ofManagedObject:object
                  withResource:resource];
    
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
                  withResource:resource];
    
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
                  withResource:resource];
    
    NSSet *expectedValues = [NSSet setWithObjects:bar1, bar2, nil];
    XCTAssertEqualObjects([object valueForKeyPath:@"bars"], expectedValues);
}

- (void)testUpdateToManyRelationshipWithAppendStrategy
{
    NSRelationshipDescription *relationship = [self relationshipWithName:@"append" ofEntity:@"Entity"];
    XCTAssertEqualObjects([relationship rm_updateStrategy], NSRelationshipDescriptionRMUpdateStrategyAppend);
    
    // Prepare the object to have two items
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Entity"] insertIntoManagedObjectContext:self.managedObjectContext];
    NSManagedObject *item1 = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Item"] insertIntoManagedObjectContext:self.managedObjectContext];
    NSManagedObject *item2 = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Item"] insertIntoManagedObjectContext:self.managedObjectContext];
    [item1 setValue:@"1" forKey:@"name"];
    [item2 setValue:@"2" forKey:@"name"];
    [item1 setValue:object forKey:@"newRelationship"];
    [item2 setValue:object forKey:@"newRelationship"];
    
    NSSet *preparedItems = [NSSet setWithObjects:item1, item2, nil];
    XCTAssertEqualObjects([object valueForKey:@"append"], preparedItems);
    
    NSDictionary *resource = @{@"append":@[@{@"name":@"A"},@{@"name":@"B"}]};
    
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    [session updateRelationship:[self relationshipWithName:@"append" ofEntity:@"Entity"]
                ofManagedObject:object
                   withResource:resource];
    
    NSSet *expectedItemNames = [NSSet setWithObjects:@"1", @"2", @"A", @"B", nil];
    XCTAssertEqualObjects([object valueForKeyPath:@"append.name"], expectedItemNames);
}

@end
