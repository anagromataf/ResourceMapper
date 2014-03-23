//
//  RMMappingSession.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RMMappingSession : NSObject

#pragma mark Life-cycle
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

#pragma mark Accessors
@property (nonatomic, readonly) NSManagedObjectContext *context;

#pragma mark Managed Object for Resource
- (void)setManagedObject:(NSManagedObject *)managedObject forResource:(id)resource;
- (NSManagedObject *)managedObjectForResource:(id)resource usingEntity:(NSEntityDescription *)entity;

#pragma mark Manipulate Context
- (NSManagedObject *)insertResource:(id)resource usingEntity:(NSEntityDescription *)entity;
- (void)updateManagedObject:(NSManagedObject *)managedObject withResource:(id)resource omit:(NSSet *)omit;
- (void)deleteManagedObject:(NSManagedObject *)managedObject;

#pragma mark Internal Methods
- (void)updatePropertiesOfManagedObject:(NSManagedObject *)managedObject
                          usingResource:(id)resource
                                   omit:(NSSet *)relationshipsToOmit;

- (void)updateAttributesOfManagedObject:(NSManagedObject *)managedObject
                          usingResource:(id)resource;

- (void)updateRelationshipsOfManagedObject:(NSManagedObject *)managedObject
                             usingResource:(id)resource
                                      omit:(NSSet *)relationshipsToOmit;

- (void)updateRelationship:(NSRelationshipDescription *)relationship
           ofManagedObject:(NSManagedObject *)managedObject
             usingResource:(id)resource;

@end
