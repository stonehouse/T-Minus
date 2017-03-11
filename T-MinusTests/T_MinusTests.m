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

- (void)testWithSpecificDate {
    Connection *conn = Create_inMemoryConnection();
   // time_t now = time(NULL);
    
  //  Countdown_createWithTimestamp(conn, "Test countdown", now+10, NULL);
    
    time_t timestamp = createTimestamp(2017, 05, 7, 22, 30);
    Countdown* ctdn = Countdown_createWithTimestamp(conn, "Relative to 19.02.17 7:25PM", timestamp, NULL);
    
    Tminus *tm = Countdown_tminusRelative(ctdn, 1487528450);
    [self verifyTminus:tm description:"77 Days 02:09:10" days:77 hours:2 minutes:9 seconds:10];
    
    Countdown_destroy(ctdn);
    Tminus_destroy(tm);
}

- (void)testFinalCountdown {
    Connection *conn = Create_inMemoryConnection();
    time_t now = time(NULL);
    
    Countdown* ctdn = Countdown_createWithTimestamp(conn, "Test countdown", now+10, NULL);
    
    Tminus *tm = Countdown_tminus(ctdn);
    
    [self verifyTminus:tm description:"Ten..." seconds:10];
    
    Countdown_destroy(ctdn);
    Tminus_destroy(tm);
}

- (void)verifyTminus:(Tminus*)tm finished:(int)finished description:(char *)description days:(int)days hours:(int)hours minutes:(int)minutes seconds:(int)seconds {
    XCTAssertEqual(finished, tm->finished, "Finished does not match expected");
    XCTAssertEqual(days, tm->days, @"Days does not match expected");
    XCTAssertEqual(hours, tm->hours, @"Hours does not match expected");
    XCTAssertEqual(minutes, tm->minutes, @"Minutes does not match expected");
    XCTAssertEqual(seconds, tm->seconds, @"Seconds does not match expected");
    if (description) {
        NSString *expected = [NSString stringWithUTF8String:description];
        NSString *string = [NSString stringWithUTF8String:tm->description];
        XCTAssertTrue(strcmp(tm->description, description) == 0, @"%@ != %@", expected, string);
    }
}

- (void)verifyTminus:(Tminus*)tm description:(char *)description days:(int)days hours:(int)hours minutes:(int)minutes seconds:(int)seconds {
    [self verifyTminus:tm finished:0 description:description days:days hours:hours minutes:minutes seconds:seconds];
}

- (void)verifyTminus:(Tminus*)tm description:(char *)description seconds:(int)seconds {
    [self verifyTminus:tm finished:0 description:description days:0 hours:0 minutes:0 seconds:seconds];
}

- (void)verifyTminus:(Tminus*)tm description:(char *)description hours:(int)hours minutes:(int)minutes seconds:(int)seconds {
    [self verifyTminus:tm finished:0 description:description days:0 hours:hours minutes:minutes seconds:seconds];
}

- (void)verifyTminusFinished:(Tminus*)tm {
    [self verifyTminus:tm finished:1 description:NULL days:0 hours:0 minutes:0 seconds:0];
}

@end
