//
//  NSManagedObjectContext+Private.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Private)

- (BOOL)rm_combineManagedObjectsOfEntity:(NSEntityDescription *)entity
                    usingSortDescriptors:(NSArray *)sortDescriptors
                            sortInMemory:(BOOL)sortInMemory
                               predicate:(NSPredicate *)predicate
                             withObjects:(NSArray *)objects
                        newObjectHandler:(void(^)(id newObject))newObjectHandler
                   matchingObjectHandler:(void(^)(NSManagedObject *currentObject, id newObject))matchingObjectHandler
                  remainingObjectHandler:(void(^)(NSManagedObject *remainingObject))remainingObjectHandler
                                   error:(NSError **)error;

@end
