//
//  RMUpdateOrInsertOperation.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 23.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMMappingStep.h"
#import "RMMappingSession.h"
#import "RMRelationshipPath.h"

#import "RMUpdateOrInsertOperation.h"

@implementation RMUpdateOrInsertOperation

#pragma mark Session Handler

- (void(^)(id resource, NSEntityDescription *entity))newObjectHandlerWithSession:(RMMappingSession *)session omit:(NSSet *)omit
{
    return ^(id resource, NSEntityDescription *entity) {
        NSManagedObject *managedObject = [session insertResource:resource usingEntity:entity];
        [session updatePropertiesOfManagedObject:managedObject usingResource:resource omit:omit];
        [session setManagedObject:managedObject forResource:resource];
    };
}

- (void(^)(NSManagedObject *managedObject, id resource))matchingObjectHandlerWithSession:(RMMappingSession *)session omit:(NSSet *)omit
{
    return ^(NSManagedObject *managedObject, id resource) {
        [session updateManagedObject:managedObject withResource:resource omit:omit];
        [session setManagedObject:managedObject forResource:resource];
    };
}

- (void(^)(NSManagedObject *managedObject))remainingObjectHandlerWithSession:(RMMappingSession *)session omit:(NSSet *)omit
{
    return nil;
}

@end
