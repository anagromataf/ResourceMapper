//
//  NSMutableArray+Private.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 18.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Private)

@property (nonatomic, readonly) id rm_head;
- (void)rm_push:(id)object;

@end
