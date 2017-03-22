//
//  TodayViewController.m
//  TodayWidget
//
//  Created by Alexander Stonehouse on 18/03/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TminusMacUtils.h"
#include "tminus.h"

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, weak) IBOutlet NSTextFieldCell *titleLabel;
@property (nonatomic, weak) IBOutlet NSTextFieldCell *label;
@property (nonatomic, weak) IBOutlet NSImageView *image;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) Connection *conn;
@property (nonatomic) Countdown *ctdn;

@end

@implementation TodayViewController

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    [self updateConnection];
    
    NSClickGestureRecognizer *clickRecognizer = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(clickedTodayWidget)];
    [self.view addGestureRecognizer:clickRecognizer];
    
    if ([self checkMostUrgentCountdown]) {
        completionHandler(NCUpdateResultNewData);
    } else {
        completionHandler(NCUpdateResultNoData);
    }
}

- (void)clickedTodayWidget
{
    [self updateConnection];
    [self checkMostUrgentCountdown];
}

- (void)updateConnection
{
    if (self.conn) {
        Database_close(self.conn);
    }
    
    self.conn = [TminusMacUtils defaultConnection];
}

- (BOOL)checkMostUrgentCountdown
{
    BOOL hadRunningCountdown = NO;
    
    if (self.ctdn) {
        hadRunningCountdown = YES;
        // Countdown just finished, so leave what was just displayed
        Countdown_destroy(self.ctdn);
    }
    
    if (self.timer) {
        [self.timer invalidate];
    }
    
    self.ctdn = Countdown_getMostUrgent(self.conn);
    
    if (self.ctdn) {
        if (strlen(self.ctdn->title) > 0) {
            self.titleLabel.stringValue = [NSString stringWithUTF8String:self.ctdn->title];
        }
        
        self.image.image = [TminusMacUtils imageForCountdown:self.ctdn];
        [self updateTimer];
        [self setupTimer];
        return YES;
    } else if (!hadRunningCountdown) {
        // No running countdown, nothing to do
        self.image.image = nil;
        self.label.stringValue = NSLocalizedString(@"Nothing to see here", nil);
    }
    
    return NO;
}

- (void)updateTimer
{
    if (self.ctdn) {
        Tminus tm = Countdown_tminus(self.ctdn);
        self.label.stringValue = [NSString stringWithUTF8String:tm.description];
        
        // Countdown over, need to check for another one
        if (tm.finished == 1) {
            [self checkMostUrgentCountdown];
        }
    }
}

- (void)setupTimer
{
    [self updateTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

@end

