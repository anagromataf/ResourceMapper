//
//  RMDependency.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 19.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RMDependency : NSObject

#pragma mark Combine Dependencies
- (void)union:(RMDependency *)dependency;

#pragma mark Relationship Paths
@property (nonatomic, readonly) NSSet *allPaths;
- (void)pushRelationship:(NSRelationshipDescription *)relationship;

#pragma mark Entity Dependency
- (RMDependency *)dependencyOfEntity:(NSEntityDescription *)entity;

@end
