//
//  RMUpdateSession_InsertObjectTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMMangedObjectContextTestCase.h"

@interface RMUpdateSession_InsertObjectTests : RMMangedObjectContextTestCase

@end

@implementation RMUpdateSession_InsertObjectTests

- (void)testCreateSession
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    
    RMUpdateSession *session = [[RMUpdateSession alloc] initWithEntity:entity
                                                               context:self.managedObjectContext];

    XCTAssertEqualObjects(session.entity, entity);
    XCTAssertEqualObjects(session.context, self.managedObjectContext);
}

- (void)testInsertObject
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    RMUpdateSession *session = [[RMUpdateSession alloc] initWithEntity:entity
                                                               context:self.managedObjectContext];
    
    NSDictionary *object = @{@"identifier": @"123", @"name":@"Foo"};
    
    NSManagedObject *managedObject = [session insertObject:object];
    XCTAssertNotNil(managedObject);
    XCTAssertEqualObjects(managedObject.entity, entity);
    
    XCTAssertEqual([[self.managedObjectContext insertedObjects] count], (NSUInteger)1);
    XCTAssertEqualObjects([[self.managedObjectContext insertedObjects] anyObject], managedObject);
}

- (void)testInsertObjectWithSubEntity
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    RMUpdateSession *session = [[RMUpdateSession alloc] initWithEntity:entity
                                                               context:self.managedObjectContext];
    
    NSDictionary *object = @{@"entity":[self entityWithName:@"SubEntity"]};
    
    NSManagedObject *managedObject = [session insertObject:object];
    XCTAssertNotNil(managedObject);
    XCTAssertEqualObjects(managedObject.entity, [self entityWithName:@"SubEntity"]);
}

- (void)testInsertObjectWithWrongSubEntity
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    RMUpdateSession *session = [[RMUpdateSession alloc] initWithEntity:entity
                                                               context:self.managedObjectContext];
    
    NSDictionary *object = @{@"entity":[self entityWithName:@"Item"]};
    
    XCTAssertThrowsSpecificNamed([session insertObject:object],
                                 NSException,
                                 NSInternalInconsistencyException);
}

@end
