//
//  RMMappingStep.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 22.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RMDependency;

@interface RMMappingStep : NSObject

+ (NSArray *)mappingStepsWithEntities:(NSSet *)entities
                           dependency:(RMDependency *)dependency;

#pragma mark Entity & Omitted Relationships
@property (nonatomic, readonly) NSEntityDescription *entity;
@property (nonatomic, readonly) NSSet *relationshipPathsToOmit;

@end
