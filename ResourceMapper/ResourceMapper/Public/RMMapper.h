//
//  RMMapper.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 24.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@protocol RMResult <NSObject>

@end

typedef void(^RMMapperCompletionHandler)(id<RMResult> result, NSError *error);
typedef RMMapperCompletionHandler RMMapperComplitionHandler DEPRECATED_ATTRIBUTE;

@interface RMMapper : NSObject

#pragma mark Life-cycle
- (id)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (id)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator mergePolicy:(NSMergePolicy *)mergePolicy;

#pragma mark Persistent Store Coordinator
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark Model Properties
@property (nonatomic, readonly) NSDictionary *primaryKeyNamesByEntityName;
@property (nonatomic, readonly) NSDictionary *garbageColelctionPredicatesByEntityName DEPRECATED_ATTRIBUTE;
@property (nonatomic, readonly) NSDictionary *garbageCollectionPredicatesByEntityName;

#pragma mark Dependent Contexts
- (void)addDependentContext:(NSManagedObjectContext *)context;
- (void)removeDependentContext:(NSManagedObjectContext *)context;

#pragma mark Operations

- (void)insertOrUpdateResource:(NSArray *)resources
        usingEntityDescription:(NSEntityDescription *)entityDescription
                    completion:(RMMapperCompletionHandler)completion DEPRECATED_ATTRIBUTE;

- (void)insertOrUpdateResources:(NSArray *)resources
         usingEntityDescription:(NSEntityDescription *)entityDescription
                     completion:(RMMapperCompletionHandler)completion;

- (void)deleteResourcesWithPrimaryKeys:(NSArray *)primaryKeys
                usingEntityDescription:(NSEntityDescription *)entityDescription
                            completion:(RMMapperCompletionHandler)completion;

- (void)fetchResourcesWithPrimaryKeys:(NSArray *)primaryKeys
               usingEntityDescription:(NSEntityDescription *)entityDescription
                           completion:(RMMapperCompletionHandler)completion;

#pragma mark Garbage Collection

- (void)collectGarbage:(RMMapperCompletionHandler)completion;


@end
