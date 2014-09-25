//
//  NSRelationshipDescription+Private.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 25.09.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <CoreData/CoreData.h>

extern NSString * const NSRelationshipDescriptionRMUpdateStrategyKey;
extern NSString * const NSRelationshipDescriptionRMUpdateStrategyReplace; // Default
extern NSString * const NSRelationshipDescriptionRMUpdateStrategyAppend;

@interface NSRelationshipDescription (Private)

- (NSString *)rm_updateStrategy;

@end
