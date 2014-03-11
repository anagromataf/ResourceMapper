//
//  RMUpdateSession_InsertResourceTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMMangedObjectContextTestCase.h"

@interface RMUpdateSession_InsertResourceTests : RMMangedObjectContextTestCase

@end

@implementation RMUpdateSession_InsertResourceTests

- (void)testCreateSession
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    
    RMUpdateSession *session = [[RMUpdateSession alloc] initWithEntity:entity
                                                               context:self.managedObjectContext];
    
    XCTAssertEqualObjects(session.entity, entity);
    XCTAssertEqualObjects(session.context, self.managedObjectContext);
}

- (void)testInsertResource
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    RMUpdateSession *session = [[RMUpdateSession alloc] initWithEntity:entity
                                                               context:self.managedObjectContext];
    
    NSDictionary *resource = @{@"identifier": @"123", @"name":@"Foo"};
    
    NSManagedObject *managedObject = [session insertResource:resource];
    XCTAssertNotNil(managedObject);
    XCTAssertEqualObjects(managedObject.entity, entity);
    
    XCTAssertEqual([[self.managedObjectContext insertedObjects] count], (NSUInteger)1);
    XCTAssertEqualObjects([[self.managedObjectContext insertedObjects] anyObject], managedObject);
}

- (void)testInsertResourceWithSubEntity
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    RMUpdateSession *session = [[RMUpdateSession alloc] initWithEntity:entity
                                                               context:self.managedObjectContext];
    
    NSDictionary *resource = @{@"entity":[self entityWithName:@"SubEntity"]};
    
    NSManagedObject *managedObject = [session insertResource:resource];
    XCTAssertNotNil(managedObject);
    XCTAssertEqualObjects(managedObject.entity, [self entityWithName:@"SubEntity"]);
}

- (void)testInsertResourceWithWrongSubEntity
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    RMUpdateSession *session = [[RMUpdateSession alloc] initWithEntity:entity
                                                               context:self.managedObjectContext];
    
    NSDictionary *resource = @{@"entity":[self entityWithName:@"Item"]};
    
    XCTAssertThrowsSpecificNamed([session insertResource:resource],
                                 NSException,
                                 NSInternalInconsistencyException);
}

@end
