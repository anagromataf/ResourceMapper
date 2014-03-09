//
//  RMMappingContext.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 09.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMCombiningProxy.h"
#import "NSEntityDescription+Private.h"

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
        _resourcesByEntity = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
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

#pragma mark Add Resources

- (void)addResources:(NSArray *)resources usingEntity:(NSEntityDescription *)entity
{
    for (id resource in resources) {
       [self addResource:resource usingEntity:entity];
    }
}

- (void)addResource:(id)resource usingEntity:(NSEntityDescription *)entity
{
    NSEntityDescription *rootEntity = [entity rm_rootEntity];
    if ([rootEntity rm_hasPrimaryKeyProperties]) {
        NSMutableDictionary *resourcesByPrimaryKey = [self.resourcesByEntity objectForKey:rootEntity];
        if (resourcesByPrimaryKey == nil) {
            resourcesByPrimaryKey = [[NSMutableDictionary alloc] init];
            [self.resourcesByEntity setObject:resourcesByPrimaryKey forKey:rootEntity];
        }
        
        NSDictionary *pk = [rootEntity rm_primaryKeyOfObject:resource];
        RMCombiningProxy *proxy = [resourcesByPrimaryKey objectForKey:pk];
        if (proxy == nil) {
            proxy = [[RMCombiningProxy alloc] init];
            [resourcesByPrimaryKey setObject:proxy forKey:pk];
        }
        [proxy addObject:resource];
    }
    
    NSEntityDescription *subentity = [resource valueForKey:@"entity"];
    subentity = subentity ?: entity;
    
    [[subentity relationshipsByName] enumerateKeysAndObjectsUsingBlock:
     ^(NSString *name, NSRelationshipDescription *relationship, BOOL *stop) {
         id relatedResource = [resource valueForKey:name];
         if (relatedResource) {
             if (relationship.isToMany) {
                 for (id resource in relatedResource) {
                     [self addResource:resource usingEntity:relationship.destinationEntity];
                 }
             } else {
                 [self addResource:relatedResource usingEntity:relationship.destinationEntity];
             }
         }
    }];
}

@end
