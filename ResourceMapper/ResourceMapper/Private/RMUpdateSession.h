//
//  RMUpdateSession.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RMUpdateSession : NSObject

#pragma mark Life-cycle
- (id)initWithEntity:(NSEntityDescription *)entity context:(NSManagedObjectContext *)context;

#pragma mark Accessors
@property (nonatomic, readonly) NSEntityDescription *entity;
@property (nonatomic, readonly) NSManagedObjectContext *context;

#pragma mark Manipulate Context
- (NSManagedObject *)insertObject:(id)newObject;
- (void)updateManagedObject:(NSManagedObject *)managedObject withObject:(id)newObject;
- (void)deleteManagedObject:(NSManagedObject *)managedObject;

#pragma mark Internal Methods
- (void)updatePropertiesOfManagedObject:(NSManagedObject *)managedObject usingObject:(id)newObject;
- (void)updateAttributesOfManagedObject:(NSManagedObject *)managedObject usingObject:(id)newObject;
- (void)updateRelationshipsOfManagedObject:(NSManagedObject *)managedObject usingObject:(id)newObject;

@end
