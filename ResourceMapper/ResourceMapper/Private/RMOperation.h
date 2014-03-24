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
@class RMMappingStep;

@interface RMOperation : NSObject

#pragma mark Life-cycle
- (id)initWithMappingContext:(RMMappingContext *)mappingContext;

#pragma mark Mapping Context
@property (nonatomic, readonly) RMMappingContext *mappingContext;

#pragma mark Apply Operation
- (RMMappingSession *)applyToManagedObjectContext:(NSManagedObjectContext *)context error:(NSError **)error;

#pragma mark Session Handler (Internal Use Only)
- (void(^)(id resource, NSEntityDescription *entity))newObjectHandlerWithSession:(RMMappingSession *)session omit:(NSSet *)omit;
- (void(^)(NSManagedObject *managedObject, id resource))matchingObjectHandlerWithSession:(RMMappingSession *)session omit:(NSSet *)omit;
- (void(^)(NSManagedObject *managedObject))remainingObjectHandlerWithSession:(RMMappingSession *)session omit:(NSSet *)omit;

@end
