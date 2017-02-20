//
//  T_MinusTests.m
//  T-MinusTests
//
//  Created by Alexander Stonehouse on 19/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "tminus.h"

@interface T_MinusTests : XCTestCase

@end

@implementation T_MinusTests

- (void)testExample {
    
    Countdown ctdn = Countdown_create(2017, 05, 7, 22, 30);
    // Relative to 19.02.17 7:25PM
    char *str = Countdown_toStringRelativeToCurrentTime(ctdn, 1487528450);
    char *expected = "77 days and 2 hours";
    NSString *string = [NSString stringWithCString:str encoding:NSASCIIStringEncoding];
    XCTAssertTrue(strcmp(str, expected) == 0, @"%@", string);
    
    Countdown_destroy(ctdn);
    free(str);
}

@end
