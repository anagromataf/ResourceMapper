//
//  RMUpdateSession_DeleteObjectTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMMangedObjectContextTestCase.h"

@interface RMUpdateSession_DeleteObjectTests : RMMangedObjectContextTestCase

@end

@implementation RMUpdateSession_DeleteObjectTests

- (void)testDeleteObject
{
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:entity
                                       insertIntoManagedObjectContext:self.managedObjectContext];
    
    RMUpdateSession *session = [[RMUpdateSession alloc] initWithEntity:entity
                                                               context:self.managedObjectContext];

    [session deleteManagedObject:object];
    
    XCTAssertTrue([object isDeleted]);
    XCTAssertEqual([[self.managedObjectContext deletedObjects] count], (NSUInteger)1);
    XCTAssertEqualObjects([[self.managedObjectContext deletedObjects] anyObject], object);
}

@end
