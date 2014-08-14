//
//  NSManagedObject+ResourceMapper.h
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 14.08.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (ResourceMapper)

- (BOOL)rm_objectIsGarbage;

@end
