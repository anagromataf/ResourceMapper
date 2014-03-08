//
//  RMUpdateSession.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

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
    
}

@end
