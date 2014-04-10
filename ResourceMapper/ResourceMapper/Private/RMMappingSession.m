//
//  RMMappingSession.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "NSObject+Private.h"
#import "NSEntityDescription+Private.h"

#import "RMMappingSession.h"

@interface RMMappingSession ()
@property (nonatomic, readonly) NSMapTable *managedObjectsByEntity;
@property (nonatomic, readonly) NSMutableArray *pendingUpdates;
@end

@implementation RMMappingSession

#pragma mark Life-cycle

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (self) {
        _context = context;
        _managedObjectsByEntity = [NSMapTable strongToStrongObjectsMapTable];
        _pendingUpdates = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark Managed Objects for Resource

- (void)setManagedObject:(NSManagedObject *)managedObject forResource:(id)resource
{
    NSParameterAssert([managedObject.entity rm_hasPrimaryKeyProperties]);
    
    NSEntityDescription *rootEntity = [managedObject.entity rm_rootEntity];
    
    NSMutableDictionary *managedObjects = [self.managedObjectsByEntity objectForKey:rootEntity];
    if (managedObjects == nil) {
        managedObjects = [[NSMutableDictionary alloc] init];
        [self.managedObjectsByEntity setObject:managedObjects forKey:rootEntity];
    }
    
    NSDictionary *pk = [rootEntity rm_primaryKeyOfResource:resource];
    [managedObjects setObject:managedObject forKey:pk];
}

- (NSManagedObject *)managedObjectForResource:(id)resource usingEntity:(NSEntityDescription *)entity
{
    NSParameterAssert([entity rm_hasPrimaryKeyProperties]);

    NSEntityDescription *rootEntity = [entity rm_rootEntity];
    
    NSMutableDictionary *managedObjects = [self.managedObjectsByEntity objectForKey:rootEntity];
    NSDictionary *pk = [rootEntity rm_primaryKeyOfResource:resource];
    
    return [managedObjects objectForKey:pk];
}

#pragma mark Manipulate Context

- (NSManagedObject *)insertResource:(id)resource usingEntity:(NSEntityDescription *)entity
{
    NSEntityDescription *resourceEntity = [resource valueForKey:@"entity"];
    if (resourceEntity) {
        NSAssert([resourceEntity isKindOfEntity:entity], @"Entity (%@) specified by the object to insert is not a subentity of (%@)", resourceEntity.name, entity.name);
    }
    
    NSManagedObject *managedObject = [[NSManagedObject alloc] initWithEntity:resourceEntity ? resourceEntity: entity
                                              insertIntoManagedObjectContext:self.context];
    return managedObject;
}

- (void)updateManagedObject:(NSManagedObject *)managedObject withResource:(id)resource omit:(NSSet *)omit
{
    [self updatePropertiesOfManagedObject:managedObject
                            withResource:resource
                                     omitRelationships:omit];
}

- (void)deleteManagedObject:(NSManagedObject *)managedObject
{
    [self.context deleteObject:managedObject];
}

#pragma mark Pending Updates

- (void)invokePendingUpdates
{
    for (void(^_pendingUpdate)() in self.pendingUpdates) {
        _pendingUpdate();
    }
    [self.pendingUpdates removeAllObjects];
}

#pragma mark Internal Methods

- (void)updatePropertiesOfManagedObject:(NSManagedObject *)managedObject
                          withResource:(id)resource
                      omitRelationships:(NSSet *)relationshipsToOmit
{
    // Update Properties
    // -----------------
    
    [self updateAttributesOfManagedObject:managedObject
                            withResource:resource];
    
    // Update Relatonships
    // -------------------
    
    [self updateRelationshipsOfManagedObject:managedObject
                               withResource:resource
                                        omitRelationships:relationshipsToOmit];
}

- (void)updateAttributesOfManagedObject:(NSManagedObject *)managedObject
                          withResource:(id)resource
{
    NSDictionary *values = [resource rm_dictionaryWithValuesForKeys:[[managedObject.entity attributesByName] allKeys]
                                                  omittingNilValues:YES];
    [managedObject setValuesForKeysWithDictionary:values];
}

- (void)updateRelationshipsOfManagedObject:(NSManagedObject *)managedObject
                             withResource:(id)resource
                         omitRelationships:(NSSet *)relationshipsToOmit
{
    NSDictionary *relationships = managedObject.entity.relationshipsByName;
    [relationships enumerateKeysAndObjectsUsingBlock:
     ^(NSString *name, NSRelationshipDescription *relationship, BOOL *stop) {
         if (![relationshipsToOmit containsObject:relationship]) {
             [self updateRelationship:relationship
                      ofManagedObject:managedObject
                        withResource:resource];
         } else if ([resource valueForKey:relationship.name]) {
             
             void(^_pendingUpdate)() = ^() {
                 [self updateRelationship:relationship
                          ofManagedObject:managedObject
                            withResource:resource];
             };
             [self.pendingUpdates addObject:_pendingUpdate];
         }
     }];
}

- (void)updateRelationship:(NSRelationshipDescription *)relationship
           ofManagedObject:(NSManagedObject *)managedObject
             withResource:(id)resource
{
    id _related = [resource valueForKey:relationship.name];
    if (_related) {
        
        NSEntityDescription *destinationEntity = relationship.destinationEntity;
        
        if (relationship.isToMany) {
            NSMutableSet *objects = [[NSMutableSet alloc] init];
            for (id relatedResource in _related) {
                NSManagedObject *object = nil;
                if ([destinationEntity rm_hasPrimaryKeyProperties]) {
                    object = [self managedObjectForResource:relatedResource usingEntity:destinationEntity];
                } else {
                    object = [self insertResource:relatedResource usingEntity:destinationEntity];
                    [self updatePropertiesOfManagedObject:object withResource:relatedResource omitRelationships:nil];
                }
                if (object) {
                    [objects addObject:object];
                }
            }
            [managedObject setValue:objects forKey:relationship.name];
        } else {
            NSManagedObject *object = nil;
            if ([destinationEntity rm_hasPrimaryKeyProperties]) {
                object = [self managedObjectForResource:_related usingEntity:destinationEntity];
            } else {
                object = [self insertResource:_related usingEntity:destinationEntity];
                [self updatePropertiesOfManagedObject:object withResource:_related omitRelationships:nil];
            }
            [managedObject setValue:object forKey:relationship.name];
        }
    }
}

@end
