//
//  RMMappingStep.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 22.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMDependency.h"
#import "RMRelationshipPath.h"

#import "RMMappingStep.h"

@implementation RMMappingStep

+ (NSArray *)mappingStepsWithEntities:(NSSet *)entities dependency:(RMDependency *)dependency
{
    NSParameterAssert([entities count] > 0);
    
    NSMapTable *table = [NSMapTable strongToStrongObjectsMapTable];
    for (NSEntityDescription *entity in entities) {
        [table setObject:[NSMutableSet set] forKey:entity];
    }
    
    for (RMRelationshipPath *path in dependency.allPaths) {
        [[table objectForKey:path.headEntity] addObject:path];
    }
    
    NSMutableOrderedSet *remainingEntities = [[NSMutableOrderedSet alloc] initWithSet:entities];
    
    NSComparator _com = ^NSComparisonResult(NSEntityDescription *entity1,
                                            NSEntityDescription *entity2) {
        
        NSMutableSet *dependency1 = [[[table objectForKey:entity1] valueForKeyPath:@"tailEntity"] mutableCopy];
        NSMutableSet *dependency2 = [[[table objectForKey:entity2] valueForKeyPath:@"tailEntity"] mutableCopy];
        
        [dependency1 intersectSet:[remainingEntities set]];
        [dependency2 intersectSet:[remainingEntities set]];
        
        NSUInteger count1 = [dependency1 count];
        NSUInteger count2 = [dependency2 count];
        
        if (count1 == count2) {
            return NSOrderedSame;
        } else if (count1 < count2) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    };
    
    NSMutableArray *steps = [[NSMutableArray alloc] init];
    NSMutableSet *postUpdateRelationships = [[NSMutableSet alloc] init];
    
    do {
        
        // Sort the remaining entities and take the one with the
        // lowest number of dependencies.
        
        [remainingEntities sortUsingComparator:_com];
        NSEntityDescription *entity = [remainingEntities firstObject];
        
        // Get the dependency paths of the entity.
        
        NSMutableSet *paths = [table objectForKey:entity];
        
        if ([paths count] == 0) {
            
            // The entity does not depend on other entities.
            
            RMMappingStep *step = [[RMMappingStep alloc] initWithEntity:entity relationshipsToOmit:[NSSet set]];
            [steps addObject:step];
            
        } else {
            
            // The entity depends on other entities.
            // Omit the relationship paths to entities
            // that need to be updated first.
            
            NSPredicate *omitFilter = [NSPredicate predicateWithBlock:
                                       ^BOOL(RMRelationshipPath *path, NSDictionary *bindings) {
                                           return [remainingEntities containsObject:path.tailEntity];
                                       }];
            NSSet *omit = [paths filteredSetUsingPredicate:omitFilter];
            
            RMMappingStep *step = [[RMMappingStep alloc] initWithEntity:entity relationshipsToOmit:omit];
            [steps addObject:step];
            [postUpdateRelationships addObjectsFromArray:[omit allObjects]];
        }
        
        [remainingEntities removeObject:entity];
        
    } while ([remainingEntities count]);

    
    return steps;
}

#pragma mark Life-cycle

- (id)initWithEntity:(NSEntityDescription *)entity relationshipsToOmit:(NSSet *)relationshipsToOmit
{
    self = [super init];
    if (self) {
        _entity = entity;
        _relationshipPathsToOmit = relationshipsToOmit;
    }
    return self;
}

@end
