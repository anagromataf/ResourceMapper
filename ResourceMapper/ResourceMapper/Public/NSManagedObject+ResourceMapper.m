//
//  NSManagedObject+ResourceMapper.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 14.08.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "NSEntityDescription+Private.h"

#import "NSManagedObject+ResourceMapper.h"

@implementation NSManagedObject (ResourceMapper)

- (BOOL)rm_objectIsGarbage
{
    NSPredicate *garbagePredicate = [self.entity rm_garbagePredicate];
    if (garbagePredicate) {
        return [garbagePredicate evaluateWithObject:self];
    } else {
        return NO;
    }
}

@end
