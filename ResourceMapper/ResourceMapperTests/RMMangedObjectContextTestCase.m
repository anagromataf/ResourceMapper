//
//  RMMangedObjectContextTestCase.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//


#import "RMMangedObjectContextTestCase.h"

@interface RMMangedObjectContextTestCase ()
@property (nonatomic, strong) NSString *databaseFolder;
@end

@implementation RMMangedObjectContextTestCase

- (void)setUp
{
    NSError *error = nil;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    // Model
    self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    
    // Store Coordinator
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    self.databaseFolder = [NSTemporaryDirectory() stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]];
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:self.databaseFolder
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:&error];
    NSAssert(success, [error localizedDescription]);
    
    NSURL *storeURL = [[NSURL alloc] initFileURLWithPath:[self.databaseFolder stringByAppendingPathComponent:@"db.sqlite"]];
    
    NSPersistentStore *store = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                             configuration:nil
                                                                                       URL:storeURL
                                                                                   options:nil
                                                                                     error:&error];
    NSAssert(store, [error localizedDescription]);
    
    // Context
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
}

- (void)tearDown
{
    self.managedObjectContext = nil;
    self.persistentStoreCoordinator = nil;
    
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:self.databaseFolder
                                                              error:&error];
    NSAssert(success, [error localizedDescription]);
    
    [super tearDown];
}

#pragma mark Helpers

- (NSEntityDescription *)entityWithName:(NSString *)name
{
    return [[self.managedObjectModel entitiesByName] valueForKey:name];
}

- (NSPropertyDescription *)propertyWithName:(NSString *)propertyName ofEntity:(id)entity
{
    if ([entity isKindOfClass:[NSString class]]) {
        entity = [self entityWithName:entity];
    }
    return [[(NSEntityDescription *)entity propertiesByName] valueForKey:propertyName];
}

@end
