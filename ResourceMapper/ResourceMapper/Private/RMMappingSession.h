//
//  RMMappingSession.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "RMMapper.h"

@interface RMMappingSession : NSObject <RMResult>

#pragma mark Life-cycle
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

#pragma mark Accessors
@property (nonatomic, readonly) NSManagedObjectContext *context;

#pragma mark Managed Object for Resource
- (void)setManagedObject:(NSManagedObject *)managedObject forResource:(id)resource;
- (NSManagedObject *)managedObjectForResource:(id)resource usingEntity:(NSEntityDescription *)entity;

#pragma mark Insert or Delete a Managed Object
- (NSManagedObject *)insertResource:(id)resource usingEntity:(NSEntityDescription *)entity;
- (void)deleteManagedObject:(NSManagedObject *)managedObject;

#pragma mark Update a Managed Object
- (void)updatePropertiesOfManagedObject:(NSManagedObject *)managedObject
                           withResource:(id)resource
                      omitRelationships:(NSSet *)relationshipsToOmit;

- (void)updateRelationshipsOfManagedObject:(NSManagedObject *)managedObject
                              withResource:(id)resource
                         omitRelationships:(NSSet *)relationshipsToOmit;

- (void)updateAttributesOfManagedObject:(NSManagedObject *)managedObject
                           withResource:(id)resource;

- (void)updateRelationship:(NSRelationshipDescription *)relationship
           ofManagedObject:(NSManagedObject *)managedObject
              withResource:(id)resource;

#pragma mark Pending Updates
- (void)invokePendingUpdates;

@end
