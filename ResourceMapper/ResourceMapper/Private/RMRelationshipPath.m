//
//  RMDependencyPath.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 19.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMRelationshipPath.h"

@interface RMRelationshipPath ()
@property (nonatomic, strong) NSArray *relationships;
@end

@implementation RMRelationshipPath

- (id)init
{
    self = [super init];
    if (self) {
        _relationships = @[];
    }
    return self;
}

#pragma mark Push Relationship

- (void)push:(NSRelationshipDescription *)relationship
{
    if (self.relationships) {
        self.relationships = [[NSArray arrayWithObject:relationship] arrayByAddingObjectsFromArray:self.relationships];
    } else {
        self.relationships = @[relationship];
    }
}

#pragma mark Accessing Path Properties

- (NSEntityDescription *)headEntity
{
    return [[self.relationships firstObject] entity];
}

- (NSEntityDescription *)tailEntity
{
    return [[self.relationships lastObject] destinationEntity];
}

- (NSArray *)allRelationships
{
    return self.relationships;
}

#pragma mark NSObject

- (NSUInteger)hash
{
    return [self.relationships hash];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[RMRelationshipPath class]]) {
        RMRelationshipPath *other = object;
        return [self.relationships isEqual:other.relationships];
    } else {
        return NO;
    }
}

@end
