//
//  NSManagedObjectContext+Private.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "NSSortDescriptor+Private.h"

#import "NSManagedObjectContext+Private.h"

@implementation NSManagedObjectContext (Private)

- (BOOL)rm_combineResources:(NSArray *)resources
        withObjectsOfEntity:(NSEntityDescription *)entity
          matchingPredicate:(NSPredicate *)predicate
       usingSortDescriptors:(NSArray *)sortDescriptors
               sortInMemory:(BOOL)sortInMemory
           newObjectHandler:(void(^)(id resource, NSEntityDescription *entity))newObjectHandler
      matchingObjectHandler:(void(^)(NSManagedObject *managedObject, id resource))matchingObjectHandler
     remainingObjectHandler:(void(^)(NSManagedObject *managedObject))remainingObjectHandler
                      error:(NSError **)error
{
    BOOL success = YES;
    
    NSParameterAssert(entity != nil);
    NSParameterAssert(sortDescriptors != nil);
    
    // Prepare Fetch Request
    // ---------------------
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.predicate = predicate;
    request.sortDescriptors = sortInMemory ? nil : sortDescriptors;
    
    // Fetch managed Objects
    // ---------------------
    
    NSArray *managedObjects = [self executeFetchRequest:request error:error];
    if (!managedObjects) {
        return NO;
    }
    
    // If the Primary key contains a relation ship, the sorting in SQLite and in memory results
    // into a different ordering, as CoreData uses in SQL the primary key of the record
    // in the table which is more or less random.
    if (sortInMemory) {
        managedObjects = [managedObjects sortedArrayUsingDescriptors:sortDescriptors];
    }
    
    // Sort Resources
    // --------------
    
    resources = [resources sortedArrayUsingDescriptors:sortDescriptors];
    
    // Setup the Comperator
    // --------------------
    
    NSComparator comparator = [NSSortDescriptor rm_comperatorUsingSortDescriptors:sortDescriptors];
    
    // Prepare Enumerators for managed objects and the resources
    // ----------------------------------------------------------
    
    NSEnumerator *managedObjectEnumerator = [managedObjects objectEnumerator];
    NSEnumerator *resourceEnumerator = [resources objectEnumerator];
    
    __block id managedObject = nil;
    void(^nextManagedObject)() = ^{
        id _previous = managedObject;
        do {
            managedObject = [managedObjectEnumerator nextObject];
        } while (_previous != nil &&
                 managedObject != nil &&
                 comparator(_previous, managedObject) == NSOrderedSame);
    };
    
    __block id resource = nil;
    void(^nextResource)() = ^{
        id _previous = resource;
        do {
            resource = [resourceEnumerator nextObject];
        } while (_previous != nil &&
                 resource != nil &&
                 comparator(_previous, resource) == NSOrderedSame);
    };
    
    // Combine managed Objects with Resources
    // --------------------------------------
    
    nextManagedObject();
    nextResource();
    
    while (managedObject != nil || resource != nil) {
        
        if (managedObject != nil && resource != nil) {
            switch (comparator(managedObject, resource)) {
                case NSOrderedAscending:
                    if (remainingObjectHandler) {
                        remainingObjectHandler(managedObject);
                    }
                    nextManagedObject();
                    break;
                    
                case NSOrderedDescending:
                    if (newObjectHandler) {
                        newObjectHandler(resource, entity);
                    }
                    nextResource();
                    break;
                    
                default:
                    if (matchingObjectHandler) {
                        matchingObjectHandler(managedObject, resource);
                    };
                    nextManagedObject();
                    nextResource();
                    break;
            }
        } else if (managedObject != nil) {
            if (remainingObjectHandler) {
                remainingObjectHandler(managedObject);
                nextManagedObject();
            } else {
                break;
            }
        } else if (resource != nil) {
            if (newObjectHandler) {
                newObjectHandler(resource, entity);
                nextResource();
            } else {
                break;
            }
        }
    }
    
    return success;
}

@end
