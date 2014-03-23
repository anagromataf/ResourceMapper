//
//  RMDeleteOperation.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 23.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMMappingSession.h"

#import "RMDeleteOperation.h"

@implementation RMDeleteOperation

#pragma mark Session Handler

- (void(^)(id resource))newObjectHandlerWithSession:(id<RMMappingSession>)session
{
    return nil;
}

- (void(^)(NSManagedObject *managedObject, id resource))matchingObjectHandlerWithSession:(id<RMMappingSession>)session
{
    return ^(NSManagedObject *managedObject, id resource) {
        [session deleteManagedObject:managedObject];
    };
}

- (void(^)(NSManagedObject *managedObject))remainingObjectHandlerWithSession:(id<RMMappingSession>)session
{
    return nil;
}

@end
