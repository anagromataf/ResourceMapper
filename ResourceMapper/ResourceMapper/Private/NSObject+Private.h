//
//  NSObject+Private.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Private)

- (NSDictionary *)rm_dictionaryWithValuesForKeys:(NSArray *)keys omittingNilValues:(BOOL)omittingNilValues;

@end
