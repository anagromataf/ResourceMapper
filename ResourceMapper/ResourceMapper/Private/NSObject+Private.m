//
//  NSObject+Private.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "NSObject+Private.h"

@implementation NSObject (Private)

- (NSDictionary *)rm_dictionaryWithValuesForKeys:(NSArray *)keys omittingNilValues:(BOOL)omittingNilValues
{
    if (omittingNilValues) {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        for (NSString *key in keys) {
            id value = [self valueForKey:key];
            if (value) {
                [result setObject:value forKey:key];
            }
        }
        return [result copy];
    } else {
        return [self dictionaryWithValuesForKeys:keys];
    }
}

@end
