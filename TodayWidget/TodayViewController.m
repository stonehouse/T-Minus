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
    if (self.conn) {
        [self.timer invalidate];
    } else {
        self.conn = [TminusMacUtils defaultConnection];
    }

    
    self.ctdn = Countdown_getMostUrgent(self.conn);
    
    if (self.ctdn) {
        if (strlen(self.ctdn->title) > 0) {
            self.titleLabel.stringValue = [NSString stringWithUTF8String:self.ctdn->title];
        } else {
            self.titleLabel.stringValue = @"T-Minus";
        }
        
        self.image.image = [TminusMacUtils imageForCountdown:self.ctdn];
        [self updateTimer];
        [self setupTimer];
        completionHandler(NCUpdateResultNewData);
    } else {
        self.image.image = nil;
        self.label.stringValue = NSLocalizedString(@"Nothing to see here", nil);
        completionHandler(NCUpdateResultNoData);
    }
}

- (void)updateTimer
{
    if (self.ctdn) {
        Tminus tm = Countdown_tminus(self.ctdn);
        
        self.label.stringValue = [NSString stringWithUTF8String:tm.description];
    }
}

- (void)setupTimer
{
    [self updateTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

@end

