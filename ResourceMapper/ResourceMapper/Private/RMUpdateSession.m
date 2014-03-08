//
//  RMUpdateSession.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "NSObject+Private.h"
#import "NSEntityDescription+Private.h"

#import "RMUpdateSession.h"

@implementation RMUpdateSession

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

#pragma mark Manipulate Context

- (NSManagedObject *)insertObject:(id)newObject
{
    NSEntityDescription *entity = [newObject valueForKey:@"entity"];
    entity = entity ?: self.entity;
    NSAssert([entity isKindOfEntity:self.entity], @"Entity (%@) specified by the object to insert is not a subentity of (%@)", entity.name, self.entity.name);
    
    NSManagedObject *managedObject = [[NSManagedObject alloc] initWithEntity:entity
                                              insertIntoManagedObjectContext:self.context];
    return managedObject;
}

- (void)updateManagedObject:(NSManagedObject *)managedObject withObject:(id)newObject
{

}

- (void)deleteManagedObject:(NSManagedObject *)managedObject
{
    [self.context deleteObject:managedObject];
}

#pragma mark Internal Methods

- (void)updatePropertiesOfManagedObject:(NSManagedObject *)managedObject
                            usingObject:(id)newObject
{
    // Update Properties
    // -----------------
    
    [self updateAttributesOfManagedObject:managedObject
                              usingObject:newObject];
    
    // Update Relatonships
    // -------------------
    
    [self updateRelationshipsOfManagedObject:managedObject
                                 usingObject:newObject];
}

- (void)updateAttributesOfManagedObject:(NSManagedObject *)managedObject
                            usingObject:(id)newObject
{
    NSDictionary *values = [newObject rm_dictionaryWithValuesForKeys:[[self.entity attributesByName] allKeys]
                                                   omittingNilValues:YES];
    [managedObject setValuesForKeysWithDictionary:values];
}

- (void)updateRelationshipsOfManagedObject:(NSManagedObject *)managedObject
                               usingObject:(id)newObject
{
    NSDictionary *relationships = managedObject.entity.relationshipsByName;
    [relationships enumerateKeysAndObjectsUsingBlock:
     ^(NSString *name, NSRelationshipDescription *relationship, BOOL *stop) {
         id destinationObject = [newObject valueForKey:name];
         if (destinationObject) {
             
         }
     }];
}

@end
