//
//  NSEntityDescription+Private.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "NSEntityDescription+Private.h"

@implementation NSEntityDescription (Private)

- (NSEntityDescription *)rm_rootEntity
{
    if (self.superentity) {
        return [self.superentity rm_rootEntity];
    } else {
        return self;
    }
}

@end
