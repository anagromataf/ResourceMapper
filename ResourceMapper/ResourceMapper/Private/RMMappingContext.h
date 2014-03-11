//
//  RMMappingContext.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 09.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum {
    RMMappingContextOperationTypeFetch = 0,
    RMMappingContextOperationTypeUpdateOrInsert,
    RMMappingContextOperationTypeDelete
} RMMappingContextOperationType;

@interface RMMappingContext : NSObject

#pragma mark Life-cycle
- (id)initWithOperationType:(RMMappingContextOperationType)operationType;

#pragma mark Operation Type
@property (nonatomic, readonly) RMMappingContextOperationType operationType;

#pragma mark Access Resources
@property (nonatomic, readonly) NSArray *entities;
- (NSDictionary *)resourcesByPrimaryKeyOfEntity:(NSEntityDescription *)entity;

#pragma mark Add Resources
- (void)addResources:(NSArray *)resources usingEntity:(NSEntityDescription *)entity;
- (void)addResource:(id)resource usingEntity:(NSEntityDescription *)entity;

@end
