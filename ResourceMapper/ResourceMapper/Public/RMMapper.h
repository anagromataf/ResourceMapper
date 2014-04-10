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

typedef void(^RMMapperComplitionHandler)(id<RMResult> result, NSError *error);

@interface RMMapper : NSObject

#pragma mark Life-cycle
- (id)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator;

#pragma mark Persistent Store Coordinator
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark Dependent Contexts
- (void)addDependentContext:(NSManagedObjectContext *)context;
- (void)removeDependentContext:(NSManagedObjectContext *)context;

#pragma mark Operations

- (void)insertOrUpdateResource:(NSArray *)resources
        usingEntityDescription:(NSEntityDescription *)entityDescription
                    completion:(RMMapperComplitionHandler)completion;

- (void)deleteResourcesWithPrimaryKeys:(NSArray *)primaryKeys
                usingEntityDescription:(NSEntityDescription *)entityDescription
                            completion:(RMMapperComplitionHandler)completion;

- (void)fetchResourcesWithPrimaryKeys:(NSArray *)primaryKeys
               usingEntityDescription:(NSEntityDescription *)entityDescription
                           completion:(RMMapperComplitionHandler)completion;

@end
