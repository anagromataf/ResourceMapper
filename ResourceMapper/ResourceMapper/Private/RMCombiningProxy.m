//
//  RMCombiningProxy.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 10.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMCombiningProxy.h"

@interface RMCombiningProxy () {
    NSMutableArray *_rm_objects;
}

@end

@implementation RMCombiningProxy

- (id)init
{
    self = [super init];
    if (self) {
        _rm_objects = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addObject:(id)object
{
    [_rm_objects addObject:object];
}

- (id)valueForKey:(NSString *)key
{
    id value = nil;
    for (id object in [_rm_objects reverseObjectEnumerator]) {
        value = [object valueForKey:key];
        if (value) {
            break;
        }
    }
    return value;
}

@end
