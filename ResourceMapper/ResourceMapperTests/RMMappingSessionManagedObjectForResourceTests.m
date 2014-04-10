//
//  RMMappingSessionManagedObjectForResourceTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 23.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMMangedObjectContextTestCase.h"

@interface RMMappingSessionManagedObjectForResourceTests : RMMangedObjectContextTestCase

@end

@implementation RMMappingSessionManagedObjectForResourceTests

- (void)testManagedObjectForResource
{
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:[self entityWithName:@"Entity"]
                                       insertIntoManagedObjectContext:self.managedObjectContext];

    NSDictionary *resource = @{@"type":@"xy", @"identifier":@"123", @"name":@"foo"};
    
    [session setManagedObject:object forResource:resource];
    
    NSDictionary *pk = @{@"type":@"xy", @"identifier":@"123"};
    NSManagedObject *object2 = [session managedObjectForResource:pk
                                                     usingEntity:[self entityWithName:@"Entity"]];
    XCTAssertEqualObjects(object, object2);
}

@end
