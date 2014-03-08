//
//  RMObjectProxyTests.m
//  ResourceMapper
//
//  Created by Tobias Kräntzer on 08.03.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ResourceMapper+Private.h"

@interface RMObjectProxyTests : XCTestCase

@end

@implementation RMObjectProxyTests

- (void)testObjectProxy
{
    NSDictionary *object = @{@"foo":@"foo", @"bar":@"bar"};

    RMObjectProxy *proxy = [[RMObjectProxy alloc] initWithObject:object];

    XCTAssertEqualObjects([proxy valueForKey:@"foo"], @"foo");
    XCTAssertEqualObjects([proxy valueForKey:@"bar"], @"bar");
    
    [proxy setValue:@"bar" forKey:@"foo"];
    
    XCTAssertEqualObjects([proxy valueForKey:@"foo"], @"bar");
    XCTAssertEqualObjects([proxy valueForKey:@"bar"], @"bar");

    [proxy setNilValueForKey:@"foo"];

    XCTAssertEqualObjects([proxy valueForKey:@"foo"], @"foo");
    XCTAssertEqualObjects([proxy valueForKey:@"bar"], @"bar");
}

@end
