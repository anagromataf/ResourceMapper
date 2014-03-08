//
//  RMManagedObjectModelTestCase.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "RMManagedObjectModelTestCase.h"

@implementation RMManagedObjectModelTestCase

- (void)setUp
{
    [super setUp];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    NSAssert(self.managedObjectModel, @"Failed to load the test model.");
}

- (void)tearDown
{
    self.managedObjectModel = nil;
    
    [super tearDown];
}

#pragma mark Helpers

- (NSEntityDescription *)entityWithName:(NSString *)name
{
    return [[self.managedObjectModel entitiesByName] valueForKey:name];
}

- (NSPropertyDescription *)propertyWithName:(NSString *)propertyName ofEntity:(id)entity
{
    if ([entity isKindOfClass:[NSString class]]) {
        entity = [self entityWithName:entity];
    }
    return [[(NSEntityDescription *)entity propertiesByName] valueForKey:propertyName];
}

@end
