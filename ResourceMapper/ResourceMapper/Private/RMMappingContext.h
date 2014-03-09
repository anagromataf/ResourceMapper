//
//  RMMappingContext.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 09.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RMMappingContext : NSObject

#pragma mark Access Resources
@property (nonatomic, readonly) NSArray *entities;
- (NSDictionary *)resourcesByPrimaryKeyOfEntity:(NSEntityDescription *)entity;

#pragma mark Add Resources
- (void)addResources:(NSArray *)resources usingEntity:(NSEntityDescription *)entity;
- (void)addResource:(id)resource usingEntity:(NSEntityDescription *)entity;

@end
