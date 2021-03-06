//
//  RMDependency.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 19.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "NSEntityDescription+Private.h"

#import "RMRelationshipPath.h"

#import "RMDependency.h"

@interface RMDependency ()
@property (nonatomic, strong) NSSet *paths;
@end

@implementation RMDependency

+ (instancetype)dependencyWithRelationship:(NSRelationshipDescription *)relationship;
{
    RMDependency *dependency = [[self alloc] init];
    [dependency pushRelationship:relationship];
    return dependency;
}

#pragma mark Life-cylce

- (id)init
{
    return [self initWithPaths:nil];
}

- (id)initWithPaths:(NSSet *)paths
{
    self = [super init];
    if (self) {
        self.paths = paths;
    }
    return self;
}

#pragma mark Combine Dependencies

- (void)union:(RMDependency *)dependency
{
    if (dependency == nil)
        return;
    
    if (self.paths && dependency.allPaths) {
        self.paths = [self.paths setByAddingObjectsFromSet:dependency.allPaths];
    } else if (dependency.allPaths != nil) {
        self.paths = dependency.allPaths;
    }
}

#pragma mark Relationship Paths

- (NSSet *)allPaths
{
    return self.paths;
}

- (instancetype)pushRelationship:(NSRelationshipDescription *)relationship
{
    if ([self.paths count] > 0) {
        NSMutableSet *paths = [[NSMutableSet alloc] init];
        [self.paths enumerateObjectsUsingBlock:^(RMRelationshipPath *path, BOOL *stop) {
            [path push:relationship];
            [paths addObject:path];
        }];
        self.paths = [paths copy];
    } else {
        RMRelationshipPath *path = [[RMRelationshipPath alloc] init];
        [path push:relationship];
        self.paths = [NSSet setWithObject:path];
    }
    
    return self;
}

#pragma mark Entity Dependency

- (RMDependency *)dependencyOfEntity:(NSEntityDescription *)entity
{
    NSEntityDescription *rootEntity = [entity rm_rootEntity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"headEntity == %@", rootEntity];
    NSSet *paths = [self.paths filteredSetUsingPredicate:predicate];
    return [[RMDependency alloc] initWithPaths:paths];
}

#pragma mark NSObject

- (NSUInteger)hash
{
    return [self.paths hash];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[RMDependency class]]) {
        RMDependency *other = object;
        return [self.paths isEqual:other.paths];
    } else {
        return NO;
    }
}

- (NSString *)description
{
    return [self.allPaths description];
}

@end
