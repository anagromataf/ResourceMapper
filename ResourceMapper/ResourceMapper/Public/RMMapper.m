//
//  RMMapper.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 24.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

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
    self = [super init];
    if (self) {
        
        _dependentContexts = [NSHashTable weakObjectsHashTable];
        
        _persistentStoreCoordinator = persistentStoreCoordinator;
        
        _operationContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _operationContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(operationManagedObjectContextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:_operationContext];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)insertOrUpdateResource:(NSArray *)resources
        usingEntityDescription:(NSEntityDescription *)entityDescription
                    completion:(RMMapperComplitionHandler)completion
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
                            completion:(RMMapperComplitionHandler)completion
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
                           completion:(RMMapperComplitionHandler)completion
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
            completion:(RMMapperComplitionHandler)completion
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

@end