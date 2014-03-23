//
//  NSManagedObjectContext+Private.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Private)

- (BOOL)rm_combineResources:(NSArray *)resources
        withObjectsOfEntity:(NSEntityDescription *)entity
          matchingPredicate:(NSPredicate *)predicate
       usingSortDescriptors:(NSArray *)sortDescriptors
               sortInMemory:(BOOL)sortInMemory
           newObjectHandler:(void(^)(id resource, NSEntityDescription *entity))newObjectHandler
      matchingObjectHandler:(void(^)(NSManagedObject *managedObject, id resource))matchingObjectHandler
     remainingObjectHandler:(void(^)(NSManagedObject *managedObject))remainingObjectHandler
                      error:(NSError **)error;

@end
