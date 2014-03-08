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


- (BOOL)rm_combineManagedObjectsOfEntity:(NSEntityDescription *)entity
                    usingSortDescriptors:(NSArray *)sortDescriptors
                            sortInMemory:(BOOL)sortInMemory
                               predicate:(NSPredicate *)predicate
                             withObjects:(NSArray *)objects
                        newObjectHandler:(void(^)(id newObject))newObjectHandler
                   matchingObjectHandler:(void(^)(NSManagedObject *currentObject, id newObject))matchingObjectHandler
                  remainingObjectHandler:(void(^)(NSManagedObject *remainingObject))remainingObjectHandler
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
    
    // Fetch existing Objects
    // ----------------------
    
    NSArray *existingObjects = [self executeFetchRequest:request error:error];
    if (!existingObjects) {
        return NO;
    }
    
    // If the Primary key contains a relation ship, the sorting in SQLite and in memory results
    // into a different ordering, as CoreData uses in SQL the primary key of the record
    // in the table which is more or less random.
    if (sortInMemory) {
        existingObjects = [existingObjects sortedArrayUsingDescriptors:sortDescriptors];
    }
    
    // Sort new Objects
    // ----------------
    
    objects = [objects sortedArrayUsingDescriptors:sortDescriptors];
    
    // Setup the comperator
    // --------------------
    
    NSComparator comparator = [NSSortDescriptor rm_comperatorUsingSortDescriptors:sortDescriptors];
    
    // Prepare Enumerators for the new and existing objects and
    // combine both lists according the the operation bitmask
    // --------------------------------------------------------
    
    NSEnumerator *existingObjectEnumerator = [existingObjects objectEnumerator];
    NSEnumerator *newObjectEnumerator = [objects objectEnumerator];
    
    __block id existingObject = nil;
    void(^nextExistingObject)() = ^{
        id _previous = existingObject;
        do {
            existingObject = [existingObjectEnumerator nextObject];
        } while (_previous != nil &&
                 existingObject != nil &&
                 comparator(_previous, existingObject) == NSOrderedSame);
    };
    
    __block id newObject = nil;
    void(^nextNewObject)() = ^{
        id _previous = newObject;
        do {
            newObject = [newObjectEnumerator nextObject];
        } while (_previous != nil &&
                 newObject != nil &&
                 comparator(_previous, newObject) == NSOrderedSame);
    };
    
    // Merge the existing with the new Objects
    // ---------------------------------------
    
    nextExistingObject();
    nextNewObject();
    
    while (existingObject != nil || newObject != nil) {
        
        if (existingObject != nil && newObject != nil) {
            switch (comparator(existingObject, newObject)) {
                case NSOrderedAscending:
                    if (remainingObjectHandler) {
                        remainingObjectHandler(existingObject);
                    }
                    nextExistingObject();
                    break;
                    
                case NSOrderedDescending:
                    if (newObjectHandler) {
                        newObjectHandler(newObject);
                    }
                    nextNewObject();
                    break;
                    
                default:
                    if (matchingObjectHandler) {
                        matchingObjectHandler(existingObject, newObject);
                    };
                    nextExistingObject();
                    nextNewObject();
                    break;
            }
        } else if (existingObject != nil) {
            if (remainingObjectHandler) {
                remainingObjectHandler(existingObject);
                nextExistingObject();
            } else {
                break;
            }
        } else if (newObject != nil) {
            if (newObjectHandler) {
                newObjectHandler(newObject);
                nextNewObject();
            } else {
                break;
            }
        }
    }
    
    return success;
}

@end
