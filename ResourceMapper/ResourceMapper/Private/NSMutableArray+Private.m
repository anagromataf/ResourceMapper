//
//  NSMutableArray+Private.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 18.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "NSMutableArray+Private.h"

@implementation NSMutableArray (Private)

- (id)rm_head
{
    return [self firstObject];
}

- (void)rm_push:(id)object
{
    [self insertObject:object atIndex:0];
}

@end
