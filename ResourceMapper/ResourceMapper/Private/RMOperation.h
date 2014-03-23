//
//  RMOperation.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 22.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RMMappingContext;
@class RMMappingSession;

@interface RMOperation : NSObject

#pragma mark Life-cycle
- (id)initWithMappingContext:(RMMappingContext *)mappingContext;

#pragma mark Mapping Context
@property (nonatomic, readonly) RMMappingContext *mappingContext;

#pragma mark Apply Operation
- (BOOL)applyToManagedObjectContext:(NSManagedObjectContext *)context
                              error:(NSError **)error;

#pragma mark Session Handler (Internal Use Only)
- (void(^)(id resource))newObjectHandlerWithSession:(id<RMMappingSession>)session;
- (void(^)(NSManagedObject *managedObject, id resource))matchingObjectHandlerWithSession:(id<RMMappingSession>)session;
- (void(^)(NSManagedObject *managedObject))remainingObjectHandlerWithSession:(id<RMMappingSession>)session;

@end
