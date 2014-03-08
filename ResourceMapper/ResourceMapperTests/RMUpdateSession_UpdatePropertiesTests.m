//
//  RMUpdateSession_UpdatePropertiesTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMMangedObjectContextTestCase.h"

@interface RMUpdateSession_UpdatePropertiesTests : RMMangedObjectContextTestCase

@end

@implementation RMUpdateSession_UpdatePropertiesTests

- (void)testUpdateAttributes
{
    NSEntityDescription *entity = [self entityWithName:@"Item"];
    
    NSManagedObject *managedObject = [[NSManagedObject alloc] initWithEntity:entity
                                              insertIntoManagedObjectContext:self.managedObjectContext];
    
    RMUpdateSession *session = [[RMUpdateSession alloc] initWithEntity:entity
                                                               context:self.managedObjectContext];
    
    NSDictionary *object = @{@"x": @(1), @"y":@(2), @"z":@(3)};
    
    [session updatePropertiesOfManagedObject:managedObject usingObject:object];
    
    XCTAssertEqualObjects([managedObject valueForKey:@"x"], @(1));
    XCTAssertEqualObjects([managedObject valueForKey:@"y"], @(2));
    XCTAssertEqualObjects([managedObject valueForKey:@"z"], @(3));
    
    object = @{@"x": @(5), @"y":[NSNull null]};

    [session updatePropertiesOfManagedObject:managedObject usingObject:object];
    
    XCTAssertEqualObjects([managedObject valueForKey:@"x"], @(5));
    XCTAssertNil([managedObject valueForKey:@"y"]);
    XCTAssertEqualObjects([managedObject valueForKey:@"z"], @(3));
}

@end
