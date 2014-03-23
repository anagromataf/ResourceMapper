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

@implementation RMMappingSession

#pragma mark Life-cycle

- (id)initWithEntity:(NSEntityDescription *)entity
             context:(NSManagedObjectContext *)context
{
    self = [super init];
    if (self) {
        _entity = entity;
        _context = context;
    }
    return self;
}

#pragma mark Set Object for Resource

- (void)setManagedObject:(NSManagedObject *)managedObject forResource:(id)resource
{
    
}

#pragma mark Manipulate Context

- (NSManagedObject *)insertResource:(id)resource
{
    NSEntityDescription *entity = [resource valueForKey:@"entity"];
    entity = entity ?: self.entity;
    NSAssert([entity isKindOfEntity:self.entity], @"Entity (%@) specified by the object to insert is not a subentity of (%@)", entity.name, self.entity.name);
    
    NSManagedObject *managedObject = [[NSManagedObject alloc] initWithEntity:entity
                                              insertIntoManagedObjectContext:self.context];
    return managedObject;
}

- (void)updateManagedObject:(NSManagedObject *)managedObject withResource:(id)resource
{
    
}

- (void)deleteManagedObject:(NSManagedObject *)managedObject
{
    [self.context deleteObject:managedObject];
}

#pragma mark Internal Methods

- (void)updatePropertiesOfManagedObject:(NSManagedObject *)managedObject
                          usingResource:(id)resource
{
    // Update Properties
    // -----------------
    
    [self updateAttributesOfManagedObject:managedObject
                            usingResource:resource];
    
    // Update Relatonships
    // -------------------
    
    [self updateRelationshipsOfManagedObject:managedObject
                               usingResource:resource];
}

- (void)updateAttributesOfManagedObject:(NSManagedObject *)managedObject
                          usingResource:(id)resource
{
    NSDictionary *values = [resource rm_dictionaryWithValuesForKeys:[[self.entity attributesByName] allKeys]
                                                  omittingNilValues:YES];
    [managedObject setValuesForKeysWithDictionary:values];
}

- (void)updateRelationshipsOfManagedObject:(NSManagedObject *)managedObject
                             usingResource:(id)resource
{
    NSDictionary *relationships = managedObject.entity.relationshipsByName;
    [relationships enumerateKeysAndObjectsUsingBlock:
     ^(NSString *name, NSRelationshipDescription *relationship, BOOL *stop) {
         id destinationObject = [resource valueForKey:name];
         if (destinationObject) {
             
         }
     }];
}

@end
