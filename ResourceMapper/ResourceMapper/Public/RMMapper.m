//
//  RMMapper.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 24.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "NSEntityDescription+Private.h"

#import "RMMappingContext.h"
#import "RMUpdateOrInsertOperation.h"
#import "RMDeleteOperation.h"
#import "RMFetchOperation.h"

#import "RMMappingSession.h"

#import "RMMapper.h"

@interface RMMapper ()
@property (nonatomic, readonly) NSManagedObjectContext *operationContext;
@property (nonatomic, readonly) NSHashTable *dependentContexts;
@end

@implementation RMMapper

#pragma mark Life-cycle

- (id)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    return [self initWithPersistentStoreCoordinator:persistentStoreCoordinator
                                        mergePolicy:nil];
}

- (id)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator mergePolicy:(NSMergePolicy *)mergePolicy
{
    self = [super init];
    if (self) {
        
        _dependentContexts = [NSHashTable weakObjectsHashTable];
        
        _persistentStoreCoordinator = persistentStoreCoordinator;
        
        _operationContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _operationContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        if (mergePolicy) _operationContext.mergePolicy = mergePolicy;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(operationManagedObjectContextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:_operationContext];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dependentManagedObjectContextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Model Properties

- (NSDictionary *)primaryKeyNamesByEntityName
{
    NSMutableDictionary *primaryKeyNamesByEntityName = [[NSMutableDictionary alloc] init];
    
    [[self.persistentStoreCoordinator.managedObjectModel entities] enumerateObjectsUsingBlock:^(NSEntityDescription *entity, NSUInteger idx, BOOL *stop) {
        NSEntityDescription *rootEntity = [entity rm_rootEntity];
        if ([rootEntity rm_hasPrimaryKeyProperties]) {
            [primaryKeyNamesByEntityName setObject:[rootEntity rm_primaryKeyPropertyNames] forKey:rootEntity.name];
        }
    }];
    
    return primaryKeyNamesByEntityName;
}

- (NSDictionary *)garbageCollectionPredicatesByEntityName
{
    NSMutableDictionary *garbageCollectionPredicatesByEntityName = [[NSMutableDictionary alloc] init];
    
    [[self.persistentStoreCoordinator.managedObjectModel entities] enumerateObjectsUsingBlock:^(NSEntityDescription *entity, NSUInteger idx, BOOL *stop) {
        NSEntityDescription *rootEntity = [entity rm_rootEntity];
        NSPredicate *predicate = [rootEntity rm_garbagePredicate];
        if (predicate) {
            [garbageCollectionPredicatesByEntityName setObject:predicate forKey:rootEntity.name];
        }
    }];
    
    return garbageCollectionPredicatesByEntityName;
}

- (NSDictionary *)garbageColelctionPredicatesByEntityName
{
    return [self garbageCollectionPredicatesByEntityName];
}

#pragma mark Dependent Contexts

- (void)addDependentContext:(NSManagedObjectContext *)context
{
    [self.operationContext performBlock:^{
        [self.dependentContexts addObject:context];
    }];
}

- (void)removeDependentContext:(NSManagedObjectContext *)context
{
    [self.operationContext performBlock:^{
        [self.dependentContexts removeObject:context];
    }];
}

#pragma mark Operations

- (void)insertOrUpdateResource:(NSArray *)resources usingEntityDescription:(NSEntityDescription *)entityDescription completion:(RMMapperCompletionHandler)completion
{
    [self insertOrUpdateResources:resources
           usingEntityDescription:entityDescription
                       completion:completion];
}

- (void)insertOrUpdateResources:(NSArray *)resources
         usingEntityDescription:(NSEntityDescription *)entityDescription
                     completion:(RMMapperCompletionHandler)completion
{
    // Prepate Mapping Context
    
    RMMappingContext *mappingContext = [[RMMappingContext alloc] init];
    
    [mappingContext addResources:resources usingEntity:entityDescription];

    // Create Operation
    
    RMOperation *operation = [[RMUpdateOrInsertOperation alloc] initWithMappingContext:mappingContext];
    
    // Apply Operation
    
    [self applyOperation:operation completion:completion];
}

- (void)deleteResourcesWithPrimaryKeys:(NSArray *)primaryKeys
                usingEntityDescription:(NSEntityDescription *)entityDescription
                            completion:(RMMapperCompletionHandler)completion
{
    // Prepate Mapping Context
    
    RMMappingContext *mappingContext = [[RMMappingContext alloc] init];
    
    [mappingContext addResources:primaryKeys usingEntity:entityDescription];
    
    // Create Operation
    
    RMOperation *operation = [[RMDeleteOperation alloc] initWithMappingContext:mappingContext];
    
    // Apply Operation
    
    [self applyOperation:operation completion:completion];
}

- (void)fetchResourcesWithPrimaryKeys:(NSArray *)primaryKeys
               usingEntityDescription:(NSEntityDescription *)entityDescription
                           completion:(RMMapperCompletionHandler)completion
{
    // Prepate Mapping Context
    
    RMMappingContext *mappingContext = [[RMMappingContext alloc] init];
    
    [mappingContext addResources:primaryKeys usingEntity:entityDescription];
    
    // Create Operation
    
    RMOperation *operation = [[RMFetchOperation alloc] initWithMappingContext:mappingContext];
    
    // Apply Operation
    
    [self applyOperation:operation completion:completion];
}

- (void)applyOperation:(RMOperation *)operation
            completion:(RMMapperCompletionHandler)completion
{
    [self.operationContext performBlock:^{
        
        BOOL success = NO;
        NSError *error = nil;
        
        // Apply Operation to Context
        
        RMMappingSession *session = [operation applyToManagedObjectContext:self.operationContext
                                                                     error:&error];
        
        // Save Changes
        
        if (session) {
            success = [self.operationContext save:&error];
        }
        
        // Call Completion Handler
        
        if (completion) {
            completion(success ? session : nil, error);
        }
    }];
}

#pragma mark Garbage Collection

- (void)collectGarbage:(RMMapperCompletionHandler)completion
{
    [self.operationContext performBlock:^{
        
        BOOL success = NO;
        NSError *error = nil;
        
        for (NSEntityDescription *entity in [self.persistentStoreCoordinator.managedObjectModel entities]) {
            NSPredicate *predicate = [entity rm_garbagePredicate];
            if (predicate) {
                
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity.name];
                request.predicate = predicate;
                request.resultType = NSManagedObjectResultType;
                
                @autoreleasepool {
                    
                    NSArray *objects = [self.operationContext executeFetchRequest:request error:&error];
                    if (objects == nil) {
                        [self.operationContext rollback];
                        if (completion) {
                            completion(nil, error);
                        }
                        return;
                    }
                    
                    for (NSManagedObject *object in objects) {
                        [self.operationContext deleteObject:object];
                    }
                }
            }
        }
        
        // Save Changes
        
        success = [self.operationContext save:&error];
        
        // Call Completion Handler
        
        if (completion) {
            completion(nil, error);
        }
    }];
}

#pragma mark Notification Handling

- (void)operationManagedObjectContextDidSave:(NSNotification *)aNotification
{
    // Merge Changes into Dependent Contexts
    
    for (NSManagedObjectContext *context in self.dependentContexts) {
        [context performBlockAndWait:^{
            [context mergeChangesFromContextDidSaveNotification:aNotification];
        }];
    }
}

- (void)dependentManagedObjectContextDidSave:(NSNotification *)aNotification
{
    // Merge Changes from Dependent Contexts into the Operation Context
    [self.operationContext performBlock:^{
        if ([self.dependentContexts containsObject:aNotification.object]) {
            [self.operationContext mergeChangesFromContextDidSaveNotification:aNotification];
        }
    }];
}

@end
