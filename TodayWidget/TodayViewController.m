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

@property (nonatomic, weak) IBOutlet NSTextFieldCell *label;
@property (nonatomic, weak) IBOutlet NSImageView *image;

@end

@implementation TodayViewController

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    Connection *conn = [TminusMacUtils defaultConnection];
    
    Countdown *ctdn = Countdown_getMostUrgent(conn);
    
    if (ctdn) {
        Tminus tm = Countdown_tminus(ctdn);
        
        self.label.stringValue = [NSString stringWithUTF8String:tm.description];
        self.image.image = [TminusMacUtils imageForCountdown:ctdn];
        completionHandler(NCUpdateResultNewData);
    } else {
        self.image.image = nil;
        self.label.stringValue = NSLocalizedString(@"Nothing to see here", nil);
        completionHandler(NCUpdateResultNoData);
    }
    
}

@end

