//
//  RMMappingSessionContextManipulationTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 23.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMMangedObjectContextTestCase.h"

@interface RMMappingSessionContextManipulationTests : RMMangedObjectContextTestCase

@end

@implementation RMMappingSessionContextManipulationTests

- (void)testCreateSession
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    XCTAssertEqualObjects(session.context, self.managedObjectContext);
}

#pragma mark Tests | Insertion

- (void)testInsertResource
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *resource = @{@"identifier": @"123", @"name":@"Foo"};
    
    NSManagedObject *managedObject = [session insertResource:resource usingEntity:entity];
    XCTAssertNotNil(managedObject);
    XCTAssertEqualObjects(managedObject.entity, entity);
    
    XCTAssertEqual([[self.managedObjectContext insertedObjects] count], (NSUInteger)1);
    XCTAssertEqualObjects([[self.managedObjectContext insertedObjects] anyObject], managedObject);
}

- (void)testInsertResourceWithSubEntity
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *resource = @{@"entity":[self entityWithName:@"SubEntity"]};
    
    NSManagedObject *managedObject = [session insertResource:resource usingEntity:entity];
    XCTAssertNotNil(managedObject);
    XCTAssertEqualObjects(managedObject.entity, [self entityWithName:@"SubEntity"]);
}

- (void)testInsertResourceWithWrongSubEntity
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *resource = @{@"entity":[self entityWithName:@"Item"]};
    
    XCTAssertThrowsSpecificNamed([session insertResource:resource usingEntity:entity],
                                 NSException,
                                 NSInternalInconsistencyException);
}

#pragma mark Tests | Update

- (void)testUpdateAttributes
{
    NSEntityDescription *entity = [self entityWithName:@"Item"];
    
    NSManagedObject *managedObject = [[NSManagedObject alloc] initWithEntity:entity
                                              insertIntoManagedObjectContext:self.managedObjectContext];
    
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *resource = @{@"x": @(1), @"y":@(2), @"z":@(3)};
    
    [session updatePropertiesOfManagedObject:managedObject usingResource:resource omit:nil];
    
    XCTAssertEqualObjects([managedObject valueForKey:@"x"], @(1));
    XCTAssertEqualObjects([managedObject valueForKey:@"y"], @(2));
    XCTAssertEqualObjects([managedObject valueForKey:@"z"], @(3));
    
    resource = @{@"x": @(5), @"y":[NSNull null]};
    
    [session updatePropertiesOfManagedObject:managedObject usingResource:resource omit:nil];
    
    XCTAssertEqualObjects([managedObject valueForKey:@"x"], @(5));
    XCTAssertNil([managedObject valueForKey:@"y"]);
    XCTAssertEqualObjects([managedObject valueForKey:@"z"], @(3));
}

#pragma mark Tests | Deletion

- (void)testDeleteResource
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    
    NSManagedObject *resource = [[NSManagedObject alloc] initWithEntity:entity
                                         insertIntoManagedObjectContext:self.managedObjectContext];
    
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    [session deleteManagedObject:resource];
    
    XCTAssertTrue([resource isDeleted]);
    XCTAssertEqual([[self.managedObjectContext deletedObjects] count], (NSUInteger)1);
    XCTAssertEqualObjects([[self.managedObjectContext deletedObjects] anyObject], resource);
}

@end
