//
//  RMDependencyPath.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 19.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RMRelationshipPath : NSObject

#pragma mark Push Relationship
- (void)push:(NSRelationshipDescription *)relationship;

#pragma mark Accessing Path Properties
@property (nonatomic, readonly) NSEntityDescription *headEntity;
@property (nonatomic, readonly) NSEntityDescription *tailEntity;
@property (nonatomic, readonly) NSArray *allRelationships;

@end
