//
//  RMOperation.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 22.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "NSManagedObjectContext+Private.h"
#import "NSEntityDescription+Private.h"

#import "RMMappingStep.h"
#import "RMMappingContext.h"
#import "RMMappingSession.h"

#import "RMUpdateOrInsertOperation.h"
#import "RMDeleteOperation.h"
#import "RMFetchOperation.h"

#import "RMOperation.h"

@interface RMOperation ()
@property (nonatomic, readonly) NSMapTable *sessions;
@end

@implementation RMOperation

#pragma mark Life-cycle

- (id)initWithMappingContext:(RMMappingContext *)mappingContext
{
    self = [super init];
    if (self) {
        _mappingContext = mappingContext;
        _sessions = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

#pragma mark Apply Operation

- (BOOL)applyToManagedObjectContext:(NSManagedObjectContext *)context
                              error:(NSError **)error
{
    __block BOOL _success = YES;
    
    NSArray *steps = [RMMappingStep mappingStepsWithEntities:[NSSet setWithArray:self.mappingContext.entities]
                                                  dependency:self.mappingContext.dependency];
    
    [steps enumerateObjectsUsingBlock:^(RMMappingStep *step, NSUInteger idx, BOOL *stop) {
        
        // Create the Mapping Session
        
        NSEntityDescription *entity = step.entity;
        RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:context];
        [self.sessions setObject:session forKey:entity];

        
        // Combine Resources
        
        NSDictionary *resources = [self.mappingContext resourcesByPrimaryKeyOfEntity:entity];
        
        BOOL success = [context rm_combineResources:[resources allValues]
                                withObjectsOfEntity:entity
                                  matchingPredicate:nil
                               usingSortDescriptors:[entity rm_primaryKeySortDescriptors]
                                       sortInMemory:NO
                                   newObjectHandler:[self newObjectHandlerWithSession:session step:step]
                              matchingObjectHandler:[self matchingObjectHandlerWithSession:session step:step]
                             remainingObjectHandler:[self remainingObjectHandlerWithSession:session step:step]
                                              error:error];
        
        if (!success) {
            _success = NO;
            *stop = YES;
        }
        
    }];
    
    return _success;
}

#pragma mark Session Handler

- (void(^)(id resource, NSEntityDescription *entity))newObjectHandlerWithSession:(RMMappingSession *)session step:(RMMappingStep *)step
{
    return nil;
}

- (void(^)(NSManagedObject *managedObject, id resource))matchingObjectHandlerWithSession:(RMMappingSession *)session step:(RMMappingStep *)step
{
    return nil;
}

- (void(^)(NSManagedObject *managedObject))remainingObjectHandlerWithSession:(RMMappingSession *)session step:(RMMappingStep *)step
{
    return nil;
}

@end
