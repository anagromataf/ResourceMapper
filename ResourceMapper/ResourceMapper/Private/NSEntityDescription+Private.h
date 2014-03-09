//
//  NSEntityDescription+Private.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <CoreData/CoreData.h>

extern NSString * const NSEntityDescriptionPrimaryKeyUserInfoKey;

@interface NSEntityDescription (Private)

#pragma mark Entity Hierarchy
- (NSEntityDescription *)rm_rootEntity;

#pragma mark Primary Key
- (BOOL)rm_hasPrimaryKeyProperties;
- (NSArray *)rm_primaryKeyPropertyNames;
- (NSArray *)rm_primaryKeyProperties;

#pragma mark Sort Descriptor & Comparator
- (NSArray *)rm_primaryKeySortDescriptors;
- (NSComparator)rm_primaryKeyComparator;

@end
