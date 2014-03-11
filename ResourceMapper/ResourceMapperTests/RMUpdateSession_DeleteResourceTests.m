//
//  RMUpdateSession_DeleteResourceTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMMangedObjectContextTestCase.h"

@interface RMUpdateSession_DeleteResourceTests : RMMangedObjectContextTestCase

@end

@implementation RMUpdateSession_DeleteResourceTests

- (void)testDeleteResource
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    
    NSManagedObject *resource = [[NSManagedObject alloc] initWithEntity:entity
                                       insertIntoManagedObjectContext:self.managedObjectContext];
    
    RMUpdateSession *session = [[RMUpdateSession alloc] initWithEntity:entity
                                                               context:self.managedObjectContext];

    [session deleteManagedObject:resource];
    
    XCTAssertTrue([resource isDeleted]);
    XCTAssertEqual([[self.managedObjectContext deletedObjects] count], (NSUInteger)1);
    XCTAssertEqualObjects([[self.managedObjectContext deletedObjects] anyObject], resource);
}

@end
