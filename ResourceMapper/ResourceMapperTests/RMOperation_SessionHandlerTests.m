//
//  RMOperationTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 23.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "ResourceMapper.h"
#import "ResourceMapper+Private.h"

@interface RMOperation_SessionHandlerTests : XCTestCase
@end

@implementation RMOperation_SessionHandlerTests

#pragma mark Tests | Update or Insert

- (void)testUpdateSessionHandler_newObjectHandler
{
    RMMappingSession * session = mock([RMMappingSession class]);
    
    RMOperation *op = [[RMUpdateOrInsertOperation alloc] initWithMappingContext:nil];

    id resource = @"r";
    id managedObject = @"mo";
    id entity = @"e";
    
    // Test new Object Handler
    void(^newObjectHandler)(id newObject, NSEntityDescription *entity) = [op newObjectHandlerWithSession:session step:nil];
    XCTAssertNotNil(newObjectHandler);
    
    [given([session insertResource:resource usingEntity:entity]) willReturn:managedObject];
    newObjectHandler(resource, entity);
    
    [verifyCount(session, times(1)) insertResource:resource usingEntity:entity];
    [verifyCount(session, times(1)) setManagedObject:managedObject forResource:resource];
}

- (void)testUpdateSessionHandler_matchingObjectHandler
{
    RMMappingSession * session = mock([RMMappingSession class]);
    
    RMOperation *op = [[RMUpdateOrInsertOperation alloc] initWithMappingContext:nil];
    
    id resource = @"r";
    id managedObject = @"mo";
    
    // Test matching Object Handler
    void(^matchingObjectHandler)(NSManagedObject *managedObject, id resource) = [op matchingObjectHandlerWithSession:session step:nil];
    XCTAssertNotNil(matchingObjectHandler);
    
    matchingObjectHandler(managedObject, resource);
    
    [verifyCount(session, times(1)) updateManagedObject:managedObject withResource:resource omit:nil];
    [verifyCount(session, times(1)) setManagedObject:managedObject forResource:resource];
}

- (void)testUpdateSessionHandler_remainingObjectHandler
{
    RMMappingSession * session = mock([RMMappingSession class]);
    
    RMOperation *op = [[RMUpdateOrInsertOperation alloc] initWithMappingContext:nil];
    
    // Test remaining Object Handler
    void(^remainingObjectHandler)(NSManagedObject *managedObject) = [op remainingObjectHandlerWithSession:session step:nil];
    XCTAssertNil(remainingObjectHandler);
}

#pragma mark Tests | Delete

- (void)testDeleteSessionHandler_newObjectHandler
{
    RMMappingSession * session = mock([RMMappingSession class]);
    
    RMOperation *op = [[RMDeleteOperation alloc] initWithMappingContext:nil];
    
    // Test new Object Handler
    void(^newObjectHandler)(id newObject, NSEntityDescription *entity) = [op newObjectHandlerWithSession:session step:nil];
    XCTAssertNil(newObjectHandler);
}

- (void)testDeleteSessionHandler_matchingObjectHandler
{
    RMMappingSession * session = mock([RMMappingSession class]);
    
    RMOperation *op = [[RMDeleteOperation alloc] initWithMappingContext:nil];
    
    id resource = @"r";
    id managedObject = @"mo";
    
    // Test matching Object Handler
    void(^matchingObjectHandler)(NSManagedObject *managedObject, id resource) = [op matchingObjectHandlerWithSession:session step:nil];
    XCTAssertNotNil(matchingObjectHandler);
    
    matchingObjectHandler(managedObject, resource);
    
    [verifyCount(session, times(1)) deleteManagedObject:managedObject];
}

- (void)testDeleteSessionHandler_remainingObjectHandler
{
    RMMappingSession * session = mock([RMMappingSession class]);
    
    RMOperation *op = [[RMDeleteOperation alloc] initWithMappingContext:nil];
    
    // Test remaining Object Handler
    void(^remainingObjectHandler)(NSManagedObject *managedObject) = [op remainingObjectHandlerWithSession:session step:nil];
    XCTAssertNil(remainingObjectHandler);
}

#pragma mark Tests | Fetch

- (void)testFetchSessionHandler_newObjectHandler
{
    RMMappingSession * session = mock([RMMappingSession class]);
    
    RMOperation *op = [[RMFetchOperation alloc] initWithMappingContext:nil];
    
    // Test new Object Handler
    void(^newObjectHandler)(id newObject, NSEntityDescription *entity) = [op newObjectHandlerWithSession:session step:nil];
    XCTAssertNil(newObjectHandler);
}

- (void)testFetchSessionHandler_matchingObjectHandler
{
    RMMappingSession * session = mock([RMMappingSession class]);
    
    RMOperation *op = [[RMFetchOperation alloc] initWithMappingContext:nil];
    
    id resource = @"r";
    id managedObject = @"mo";
    
    // Test matching Object Handler
    void(^matchingObjectHandler)(NSManagedObject *managedObject, id resource) = [op matchingObjectHandlerWithSession:session step:nil];
    XCTAssertNotNil(matchingObjectHandler);
    
    matchingObjectHandler(managedObject, resource);
    [verifyCount(session, times(1)) setManagedObject:managedObject forResource:resource];
}

- (void)testFetchSessionHandler_remainingObjectHandler
{
    RMMappingSession * session = mock([RMMappingSession class]);
    
    RMOperation *op = [[RMFetchOperation alloc] initWithMappingContext:nil];
    
    // Test remaining Object Handler
    void(^remainingObjectHandler)(NSManagedObject *managedObject) = [op remainingObjectHandlerWithSession:session step:nil];
    XCTAssertNil(remainingObjectHandler);
}

@end
