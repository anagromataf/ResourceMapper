//
//  RMMappingContext.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 09.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMCombiningProxy.h"
#import "NSEntityDescription+Private.h"
#import "RMDependency.h"

#import "RMMappingContext.h"

@interface RMMappingContext ()
@property (nonatomic, readonly) NSMapTable *resourcesByEntity;
@end

@implementation RMMappingContext

#pragma mark Life-cycle

- (id)init
{
    self = [super init];
    if (self) {
        _dependency = [[RMDependency alloc] init];
        _resourcesByEntity = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

#pragma mark Add Resources

- (void)addResources:(NSArray *)resources usingEntity:(NSEntityDescription *)entity
{
    for (id resource in resources) {
       [self addResource:resource usingEntity:entity];
    }
}

- (void)addResource:(id)resource usingEntity:(NSEntityDescription *)entity
{
    [entity rm_traverseResource:resource
                      recursive:YES
        usingDependencyCallback:^(RMDependency *dependency) {
            [self.dependency union:dependency];
        } mappingCallback:^(NSEntityDescription *entity, NSDictionary *pk, id resource) {
            [self setResource:resource ofEntity:entity forPrimaryKey:pk];
        }];
}

- (void)setResource:(id)resource ofEntity:(NSEntityDescription *)entity forPrimaryKey:(NSDictionary *)primaryKey
{
    NSEntityDescription *rootEntity = [entity rm_rootEntity];
    
    NSMutableDictionary *resourcesByPrimaryKey = [self.resourcesByEntity objectForKey:rootEntity];
    if (resourcesByPrimaryKey == nil) {
        resourcesByPrimaryKey = [[NSMutableDictionary alloc] init];
        [self.resourcesByEntity setObject:resourcesByPrimaryKey forKey:rootEntity];
    }
    
    RMCombiningProxy *proxy = [resourcesByPrimaryKey objectForKey:primaryKey];
    if (proxy == nil) {
        proxy = [[RMCombiningProxy alloc] init];
        [resourcesByPrimaryKey setObject:proxy forKey:primaryKey];
    }
    [proxy addObject:resource];
}

#pragma mark Dependencies

- (RMDependency *)dependencyOfEntity:(NSEntityDescription *)entity
{
    return [self.dependency dependencyOfEntity:entity];
}

#pragma mark Access Resources

- (NSArray *)entities
{
    return [[self.resourcesByEntity keyEnumerator] allObjects];
}

- (NSDictionary *)resourcesByPrimaryKeyOfEntity:(NSEntityDescription *)entity
{
    NSMutableDictionary *resourcesByPrimaryKey = [self.resourcesByEntity objectForKey:entity];
    return resourcesByPrimaryKey;
}

@end
