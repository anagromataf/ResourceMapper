//
//  RMMappingSession_UpdatePropertiesTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMMangedObjectContextTestCase.h"

@interface RMMappingSession_UpdatePropertiesTests : RMMangedObjectContextTestCase

@end

@implementation RMMappingSession_UpdatePropertiesTests

- (void)testUpdateAttributes
{
    NSEntityDescription *entity = [self entityWithName:@"Item"];
    
    NSManagedObject *managedObject = [[NSManagedObject alloc] initWithEntity:entity
                                              insertIntoManagedObjectContext:self.managedObjectContext];
    
    RMMappingSession *session = [[RMMappingSession alloc] initWithEntity:entity
                                                               context:self.managedObjectContext];
    
    NSDictionary *resource = @{@"x": @(1), @"y":@(2), @"z":@(3)};
    
    [session updatePropertiesOfManagedObject:managedObject usingResource:resource];
    
    XCTAssertEqualObjects([managedObject valueForKey:@"x"], @(1));
    XCTAssertEqualObjects([managedObject valueForKey:@"y"], @(2));
    XCTAssertEqualObjects([managedObject valueForKey:@"z"], @(3));
    
    resource = @{@"x": @(5), @"y":[NSNull null]};

    [session updatePropertiesOfManagedObject:managedObject usingResource:resource];
    
    XCTAssertEqualObjects([managedObject valueForKey:@"x"], @(5));
    XCTAssertNil([managedObject valueForKey:@"y"]);
    XCTAssertEqualObjects([managedObject valueForKey:@"z"], @(3));
}

@end
