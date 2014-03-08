//
//  RMMangedObjectContextTestCase.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>

#import "ResourceMapper.h"

@interface RMMangedObjectContextTestCase : XCTestCase

#pragma mark Core Data Stack
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

#pragma mark Helpers
- (NSEntityDescription *)entityWithName:(NSString *)name;
- (NSPropertyDescription *)propertyWithName:(NSString *)propertyName ofEntity:(id)entity;

@end
