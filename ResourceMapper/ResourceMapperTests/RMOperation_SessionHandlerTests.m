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
    id<RMMappingSession> session = mockProtocol(@protocol(RMMappingSession));
    
    RMOperation *op = [[RMUpdateOrInsertOperation alloc] initWithMappingContext:nil];

    id resource = @"r";
    id managedObject = @"mo";
    
    // Test new Object Handler
    void(^newObjectHandler)(id newObject) = [op newObjectHandlerWithSession:session];
    XCTAssertNotNil(newObjectHandler);
    
    [given([session insertResource:resource]) willReturn:managedObject];
    newObjectHandler(resource);
    
    [verifyCount(session, times(1)) insertResource:resource];
    [verifyCount(session, times(1)) setManagedObject:managedObject forResource:resource];
}

- (void)testUpdateSessionHandler_matchingObjectHandler
{
    id<RMMappingSession> session = mockProtocol(@protocol(RMMappingSession));
    
    RMOperation *op = [[RMUpdateOrInsertOperation alloc] initWithMappingContext:nil];
    
    id resource = @"r";
    id managedObject = @"mo";
    
    // Test matching Object Handler
    void(^matchingObjectHandler)(NSManagedObject *managedObject, id resource) = [op matchingObjectHandlerWithSession:session];
    XCTAssertNotNil(matchingObjectHandler);
    
    [given([session insertResource:resource]) willReturn:managedObject];
    matchingObjectHandler(managedObject, resource);
    
    [verifyCount(session, times(1)) updateManagedObject:managedObject withResource:resource];
    [verifyCount(session, times(1)) setManagedObject:managedObject forResource:resource];
}

- (void)testUpdateSessionHandler_remainingObjectHandler
{
    id<RMMappingSession> session = mockProtocol(@protocol(RMMappingSession));
    
    RMOperation *op = [[RMUpdateOrInsertOperation alloc] initWithMappingContext:nil];
    
    // Test remaining Object Handler
    void(^remainingObjectHandler)(NSManagedObject *managedObject) = [op remainingObjectHandlerWithSession:session];
    XCTAssertNil(remainingObjectHandler);
}

#pragma mark Tests | Delete

- (void)testDeleteSessionHandler_newObjectHandler
{
    id<RMMappingSession> session = mockProtocol(@protocol(RMMappingSession));
    
    RMOperation *op = [[RMDeleteOperation alloc] initWithMappingContext:nil];
    
    // Test new Object Handler
    void(^newObjectHandler)(id newObject) = [op newObjectHandlerWithSession:session];
    XCTAssertNil(newObjectHandler);
}

- (void)testDeleteSessionHandler_matchingObjectHandler
{
    id<RMMappingSession> session = mockProtocol(@protocol(RMMappingSession));
    
    RMOperation *op = [[RMDeleteOperation alloc] initWithMappingContext:nil];
    
    id resource = @"r";
    id managedObject = @"mo";
    
    // Test matching Object Handler
    void(^matchingObjectHandler)(NSManagedObject *managedObject, id resource) = [op matchingObjectHandlerWithSession:session];
    XCTAssertNotNil(matchingObjectHandler);
    
    matchingObjectHandler(managedObject, resource);
    
    [verifyCount(session, times(1)) deleteManagedObject:managedObject];
}

- (void)testDeleteSessionHandler_remainingObjectHandler
{
    id<RMMappingSession> session = mockProtocol(@protocol(RMMappingSession));
    
    RMOperation *op = [[RMDeleteOperation alloc] initWithMappingContext:nil];
    
    // Test remaining Object Handler
    void(^remainingObjectHandler)(NSManagedObject *managedObject) = [op remainingObjectHandlerWithSession:session];
    XCTAssertNil(remainingObjectHandler);
}

#pragma mark Tests | Fetch

- (void)testFetchSessionHandler_newObjectHandler
{
    id<RMMappingSession> session = mockProtocol(@protocol(RMMappingSession));
    
    RMOperation *op = [[RMFetchOperation alloc] initWithMappingContext:nil];
    
    // Test new Object Handler
    void(^newObjectHandler)(id newObject) = [op newObjectHandlerWithSession:session];
    XCTAssertNil(newObjectHandler);
}

- (void)testFetchSessionHandler_matchingObjectHandler
{
    id<RMMappingSession> session = mockProtocol(@protocol(RMMappingSession));
    
    RMOperation *op = [[RMFetchOperation alloc] initWithMappingContext:nil];
    
    id resource = @"r";
    id managedObject = @"mo";
    
    // Test matching Object Handler
    void(^matchingObjectHandler)(NSManagedObject *managedObject, id resource) = [op matchingObjectHandlerWithSession:session];
    XCTAssertNotNil(matchingObjectHandler);
    
    matchingObjectHandler(managedObject, resource);
    [verifyCount(session, times(1)) setManagedObject:managedObject forResource:resource];
}

- (void)testFetchSessionHandler_remainingObjectHandler
{
    id<RMMappingSession> session = mockProtocol(@protocol(RMMappingSession));
    
    RMOperation *op = [[RMFetchOperation alloc] initWithMappingContext:nil];
    
    // Test remaining Object Handler
    void(^remainingObjectHandler)(NSManagedObject *managedObject) = [op remainingObjectHandlerWithSession:session];
    XCTAssertNil(remainingObjectHandler);
}

@end
