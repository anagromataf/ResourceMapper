//
//  NSEntityDescription+Private.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "NSObject+Private.h"
#import "NSSortDescriptor+Private.h"

#import "NSEntityDescription+Private.h"

NSString * const NSEntityDescriptionPrimaryKeyUserInfoKey = @"RM_PK";

@implementation NSEntityDescription (Private)

#pragma mark Entity Hierarchy

- (NSEntityDescription *)rm_rootEntity
{
    if (self.superentity) {
        return [self.superentity rm_rootEntity];
    } else {
        return self;
    }
}

#pragma mark Primary Key Properties

- (BOOL)rm_hasPrimaryKeyProperties
{
    if (self.superentity) {
        return [self.superentity rm_hasPrimaryKeyProperties];
    } else {
        return [[self rm_primaryKeyPropertyNames] count] > 0;
    }
}

- (NSArray *)rm_primaryKeyPropertyNames
{
    if (self.superentity) {
        return [self.superentity rm_primaryKeyPropertyNames];
    } else {
        NSString *primaryKeyUserInfo = [self.userInfo valueForKey:NSEntityDescriptionPrimaryKeyUserInfoKey];
        NSMutableArray *primaryKeyNames = [[NSMutableArray alloc] init];
        [[primaryKeyUserInfo componentsSeparatedByString:@","] enumerateObjectsUsingBlock:^(NSString *primaryKeyName, NSUInteger idx, BOOL *stop) {
            [primaryKeyNames addObject:[primaryKeyName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        }];
        
#if DEBUG
        NSArray *propertyNames = [self.propertiesByName allKeys];
        for (NSString *primaryKeyName in primaryKeyNames) {
            NSAssert([propertyNames containsObject:primaryKeyName],
                     @"Entity '%@' does not has a property named '%@'. Used in primary key definition ().",
                     self.name,
                     primaryKeyName,
                     primaryKeyUserInfo);
        }
#endif
        return primaryKeyNames;
    }
}

- (NSArray *)rm_primaryKeyProperties
{
    if (self.superentity) {
        return [self.superentity rm_primaryKeyProperties];
    } else {
        NSArray *primaryKeyPropertyNames = [self rm_primaryKeyPropertyNames];
        if (primaryKeyPropertyNames == nil) {
            return nil;
        } else {
            NSMutableArray *primaryKeyProperties = [[NSMutableArray alloc] init];
            NSDictionary *properties = self.propertiesByName;
            for (NSString *propertyName in primaryKeyPropertyNames) {
                [primaryKeyProperties addObject:[properties objectForKey:propertyName]];
            }
            return [primaryKeyProperties count] == 0 ? nil : primaryKeyProperties;
        }
    }
}

#pragma mark Primary Key of Object

- (NSDictionary *)rm_primaryKeyOfResource:(id)resource
{
    NSArray *propertyNames = [self rm_primaryKeyPropertyNames];
    return [resource dictionaryWithValuesForKeys:propertyNames];
}

#pragma mark Sort Descriptor & Comparator

- (NSArray *)rm_primaryKeySortDescriptors
{
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    [[self rm_primaryKeyProperties] enumerateObjectsUsingBlock:
        ^(NSPropertyDescription *propertyDescription, NSUInteger idx, BOOL *stop) {
        [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:propertyDescription.name
                                                                 ascending:YES]];
    }];
    return sortDescriptors;
}

- (NSComparator)rm_primaryKeyComparator
{
    return [NSSortDescriptor rm_comperatorUsingSortDescriptors:[self rm_primaryKeySortDescriptors]];
}

@end
