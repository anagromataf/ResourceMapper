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
- (id)initWithEntity:(NSEntityDescription *)entity context:(NSManagedObjectContext *)context;

#pragma mark Accessors
@property (nonatomic, readonly) NSEntityDescription *entity;
@property (nonatomic, readonly) NSManagedObjectContext *context;

#pragma mark Manipulate Context
- (NSManagedObject *)insertResource:(id)resource;
- (void)updateManagedObject:(NSManagedObject *)managedObject withResource:(id)resource;
- (void)deleteManagedObject:(NSManagedObject *)managedObject;

#pragma mark Internal Methods
- (void)updatePropertiesOfManagedObject:(NSManagedObject *)managedObject usingResource:(id)resource;
- (void)updateAttributesOfManagedObject:(NSManagedObject *)managedObject usingResource:(id)resource;
- (void)updateRelationshipsOfManagedObject:(NSManagedObject *)managedObject usingResource:(id)resource;

@end
