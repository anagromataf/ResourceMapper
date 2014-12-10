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
#import "RMRelationshipPath.h"

#import "RMUpdateOrInsertOperation.h"
#import "RMDeleteOperation.h"
#import "RMFetchOperation.h"

#import "RMOperation.h"

@interface RMOperation ()

@end

@implementation RMOperation

#pragma mark Life-cycle

- (id)initWithMappingContext:(RMMappingContext *)mappingContext
{
    self = [super init];
    if (self) {
        _mappingContext = mappingContext;
    }
    return self;
}

#pragma mark Apply Operation

- (RMMappingSession *)applyToManagedObjectContext:(NSManagedObjectContext *)context
                                            error:(NSError **)error
{
    __block BOOL _success = YES;
    
    RMMappingSession *session = [[RMMappingSession alloc] initWithManagedObjectContext:context];
    
    if ([self.mappingContext.entities count] > 0) {
        NSArray *steps = [RMMappingStep mappingStepsWithEntities:[NSSet setWithArray:self.mappingContext.entities]
                                                      dependency:self.mappingContext.dependency];
        
        [steps enumerateObjectsUsingBlock:^(RMMappingStep *step, NSUInteger idx, BOOL *stop) {
            
            NSEntityDescription *entity = step.entity;
            
            // Relationships to Omit
            
            NSMutableSet *relationshipsToOmit = [[NSMutableSet alloc] init];
            [step.relationshipPathsToOmit enumerateObjectsUsingBlock:^(RMRelationshipPath *path, BOOL *stop) {
                [relationshipsToOmit addObject:[path.allRelationships firstObject]];
            }];
            
            NSDictionary *resources = [self.mappingContext resourcesByPrimaryKeyOfEntity:entity];
            
            // Create filter predicate
            
            // Create predicate matching at least the objects with the primary keys of the resources.
            // If the primary key consists of more than one property, the result may contain more objects.
            NSMutableArray *predicates = [[NSMutableArray alloc] init];
            [[entity rm_primaryKeyPropertyNames] enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
                NSArray *values = [[resources allKeys] valueForKeyPath:propertyName];
                NSPredicate *keyPredicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:propertyName]
                                                                               rightExpression:[NSExpression expressionForConstantValue:values]
                                                                                      modifier:NSDirectPredicateModifier
                                                                                          type:NSInPredicateOperatorType
                                                                                       options:0];
                
                [predicates addObject:keyPredicate];
            }];
            NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
            
            // Combine Resources
            
            BOOL success = [context rm_combineResources:[resources allValues]
                                    withObjectsOfEntity:entity
                                      matchingPredicate:predicate
                                   usingSortDescriptors:[entity rm_primaryKeySortDescriptors]
                                           sortInMemory:NO
                                       newObjectHandler:[self newObjectHandlerWithSession:session omit:relationshipsToOmit]
                                  matchingObjectHandler:[self matchingObjectHandlerWithSession:session omit:relationshipsToOmit]
                                 remainingObjectHandler:[self remainingObjectHandlerWithSession:session omit:relationshipsToOmit]
                                                  error:error];
            
            if (!success) {
                _success = NO;
                *stop = YES;
            }
            
        }];
        
        if (_success) {
            [session invokePendingUpdates];
        }
    }
    
    return _success ? session : nil;
}

#pragma mark Session Handler

- (void(^)(id resource, NSEntityDescription *entity))newObjectHandlerWithSession:(RMMappingSession *)session omit:(NSSet *)omit
{
    return nil;
}

- (void(^)(NSManagedObject *managedObject, id resource))matchingObjectHandlerWithSession:(RMMappingSession *)session omit:(NSSet *)omit
{
    return nil;
}

- (void(^)(NSManagedObject *managedObject))remainingObjectHandlerWithSession:(RMMappingSession *)session omit:(NSSet *)omit
{
    return nil;
}

@end
