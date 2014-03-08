//
//  RMObjectProxy.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMObjectProxy.h"

@interface RMObjectProxy () {
    id _rm_object;
    NSMutableDictionary *_rm_values;
}

@end

@implementation RMObjectProxy

#pragma mark Life-cycle

- (id)initWithObject:(id)object
{
    self = [super init];
    if (self) {
        _rm_object = object;
        _rm_values = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark Key-Value Coding

- (void)setValue:(id)value forKey:(NSString *)key
{
    [_rm_values setObject:value forKey:key];
}

- (void)setNilValueForKey:(NSString *)key
{
    [_rm_values removeObjectForKey:key];
}

- (id)valueForKey:(NSString *)key
{
    id value = [_rm_values objectForKey:key];
    if (value == nil) {
        value = [_rm_object valueForKey:key];
    }
    return value;
}

@end
