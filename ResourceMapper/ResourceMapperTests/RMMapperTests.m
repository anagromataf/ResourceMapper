//
//  RMMapperTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 15.08.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMManagedObjectModelTestCase.h"

@interface RMMapperTests : RMManagedObjectModelTestCase
@property (nonatomic, strong) RMMapper *mapper;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation RMMapperTests

- (void)setUp
{
    [super setUp];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    self.mapper = [[RMMapper alloc] initWithPersistentStoreCoordinator:self.persistentStoreCoordinator];
}

- (void)tearDown
{
    self.mapper = nil;
    self.persistentStoreCoordinator = nil;
    [super tearDown];
}

- (void)testMapper
{
    [self.mapper.primaryKeyNamesByEntityName enumerateKeysAndObjectsUsingBlock:^(NSString *entityName, NSArray *primaryKeyNames, BOOL *stop) {
        NSLog(@"%@ -> %@", entityName, [primaryKeyNames componentsJoinedByString:@", "]);
    }];

    [self.mapper.garbageCollectionPredicatesByEntityName enumerateKeysAndObjectsUsingBlock:^(NSString *entityName, NSPredicate *predicate, BOOL *stop) {
        NSLog(@"%@ -> %@", entityName, predicate);
    }];
}

@end
