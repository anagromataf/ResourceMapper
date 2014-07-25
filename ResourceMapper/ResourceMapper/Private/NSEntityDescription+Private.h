//
//  NSEntityDescription+Private.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <CoreData/CoreData.h>

@class RMDependency;

extern NSString * const NSEntityDescriptionPrimaryKeyUserInfoKey;
extern NSString * const NSEntityDescriptionGarbagePredicateUserInfoKey;

@interface NSEntityDescription (Private)

#pragma mark Entity Hierarchy
- (NSEntityDescription *)rm_rootEntity;

#pragma mark Primary Key Properties
- (BOOL)rm_hasPrimaryKeyProperties;
- (NSArray *)rm_primaryKeyPropertyNames;
- (NSArray *)rm_primaryKeyProperties;

#pragma mark Primary Key of Resource
- (NSDictionary *)rm_primaryKeyOfResource:(id)resource;

#pragma mark Sort Descriptor & Comparator
- (NSArray *)rm_primaryKeySortDescriptors;
- (NSComparator)rm_primaryKeyComparator;

#pragma mark Resource Traversal
- (RMDependency *)rm_traverseResource:(id)resource
                            recursive:(BOOL)recursive
              usingDependencyCallback:(void(^)(RMDependency *dependency))dependencyCallback
                      mappingCallback:(void(^)(NSEntityDescription *entity, NSDictionary *pk, id resource))mappingCallback;

#pragma mark Garbage Predicate
- (NSPredicate *)rm_garbagePredicate;

@end
