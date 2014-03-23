//
//  RMUpdateOrInsertOperation.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 23.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMMappingStep.h"
#import "RMMappingSession.h"

#import "RMUpdateOrInsertOperation.h"

@implementation RMUpdateOrInsertOperation

#pragma mark Session Handler

- (void(^)(id resource, NSEntityDescription *entity))newObjectHandlerWithSession:(RMMappingSession *)session step:(RMMappingStep *)step
{
    return ^(id resource, NSEntityDescription *entity) {
        NSManagedObject *managedObject = [session insertResource:resource usingEntity:entity];
        [session updatePropertiesOfManagedObject:managedObject usingResource:resource omit:[step relationshipsToOmit]];
        [session setManagedObject:managedObject forResource:resource];
    };
}

- (void(^)(NSManagedObject *managedObject, id resource))matchingObjectHandlerWithSession:(RMMappingSession *)session step:(RMMappingStep *)step
{
    return ^(NSManagedObject *managedObject, id resource) {
        [session updateManagedObject:managedObject withResource:resource omit:step.relationshipsToOmit];
        [session setManagedObject:managedObject forResource:resource];
    };
}

- (void(^)(NSManagedObject *managedObject))remainingObjectHandlerWithSession:(RMMappingSession *)session step:(RMMappingStep *)step
{
    return nil;
}

@end
