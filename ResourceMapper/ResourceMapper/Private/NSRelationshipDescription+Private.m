//
//  NSRelationshipDescription+Private.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 25.09.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "NSRelationshipDescription+Private.h"

NSString * const NSRelationshipDescriptionRMUpdateStrategyKey       = @"RM_UPDATE_STRATEGY";
NSString * const NSRelationshipDescriptionRMUpdateStrategyReplace   = @"replace"; // Default
NSString * const NSRelationshipDescriptionRMUpdateStrategyAppend    = @"append";

@implementation NSRelationshipDescription (Private)

- (NSString *)rm_updateStrategy
{
    id value = [self.userInfo objectForKey:NSRelationshipDescriptionRMUpdateStrategyKey];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    return NSRelationshipDescriptionRMUpdateStrategyReplace;
}

@end
