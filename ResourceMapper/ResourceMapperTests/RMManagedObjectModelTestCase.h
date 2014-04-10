//
//  RMManagedObjectModelTestCase.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>

#import "ResourceMapper.h"
#import "ResourceMapper+Private.h"

@interface RMManagedObjectModelTestCase : XCTestCase

#pragma mark Test Model
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

#pragma mark Helpers
- (NSEntityDescription *)entityWithName:(NSString *)name;
- (NSPropertyDescription *)propertyWithName:(NSString *)propertyName ofEntity:(id)entity;
- (NSRelationshipDescription *)relationshipWithName:(NSString *)relationshipName ofEntity:(id)entity;

@end
