//
//  RMOperationApplyNullTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 05.09.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMMangedObjectContextTestCase.h"

@interface RMOperationApplyNullTests : RMMangedObjectContextTestCase

@end

@implementation RMOperationApplyNullTests

- (void)test
{
    NSMutableArray *resources = [[NSMutableArray alloc] init];
    
    [resources addObject:@{@"id":@"1",
                           @"value": [NSNull null]}];
    
    RMMappingContext *mappingContext = [[RMMappingContext alloc] init];
    [mappingContext addResources:resources usingEntity:[self entityWithName:@"Object"]];
    
    RMUpdateOrInsertOperation *operation = [[RMUpdateOrInsertOperation alloc] initWithMappingContext:mappingContext];
    
    NSError *error = nil;
    RMMappingSession *session = [operation applyToManagedObjectContext:self.managedObjectContext
                                                                 error:&error];
    XCTAssertNotNil(session);
    
    NSManagedObject *object1 = [session managedObjectForResource:@{@"id":@"1"} usingEntity:[self entityWithName:@"Object"]];
    XCTAssertEqualObjects([object1 valueForKey:@"id"], @"1");
    XCTAssertNil([object1 valueForKeyPath:@"value"]);
    
    XCTAssertEqual([[self.managedObjectContext insertedObjects] count], (NSUInteger)1);
}

@end
