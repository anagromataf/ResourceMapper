//
//  NSSortDescriptor+Private.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "NSSortDescriptor+Private.h"

@implementation NSSortDescriptor (Private)

+ (NSComparator)rm_comperatorUsingSortDescriptors:(NSArray *)sortDescriptors
{
    return ^(id firstObject, id secondObject) {
        for (NSSortDescriptor *sortDescriptor in sortDescriptors) {
            NSComparisonResult result = [sortDescriptor compareObject:firstObject toObject:secondObject];
            switch (result) {
                case NSOrderedAscending:
                    return sortDescriptor.ascending ? NSOrderedAscending : NSOrderedDescending;
                case NSOrderedDescending:
                    return sortDescriptor.ascending ? NSOrderedDescending : NSOrderedAscending;
                default:
                    break;
            }
        }
        return NSOrderedSame;
    };
}

@end
