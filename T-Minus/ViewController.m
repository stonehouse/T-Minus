//
//  ViewController.m
//  T-Minus
//
//  Created by Alexander Stonehouse on 19/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import "ViewController.h"
#include "tminus.h"

@interface ViewController()
@property (weak) IBOutlet NSTextFieldCell *countdownLabel;
@property (nonatomic) Countdown *ctdn;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear
{
    
    [self showSetup];
}

- (void)dealloc
{
    Countdown_destroy(self.ctdn);
}

- (void)updateTimer {
    Tminus *tm = Countdown_tminus(self.ctdn);
    
    self.countdownLabel.stringValue = [NSString stringWithCString:tm->description encoding:NSASCIIStringEncoding];
    
    Tminus_destroy(tm);
}

- (void)showSetup
{
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert setMessageText:@"What's your deadline?"];
    [alert setInformativeText:NSLocalizedString(@"Let me know when your deadline is so we can start the...final countdown!", nil)];
    [alert addButtonWithTitle:NSLocalizedString(@"OK", nil)];
    [alert setAlertStyle:NSAlertStyleInformational];
    
    NSDatePicker *input = [[NSDatePicker alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    
    NSDate *now = [NSDate date];
    input.minDate = now;
    input.dateValue = [now dateByAddingTimeInterval: SECONDS_IN_DAY * 10];
    input.maxDate = [now dateByAddingTimeInterval: SECONDS_IN_YEAR];
    alert.accessoryView = input;
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        [self setupCountdown:input.dateValue.timeIntervalSince1970];
    }];
}

- (void)setupCountdown:(NSTimeInterval)deadline
{
    self.ctdn = Countdown_createWithTimestamp("Title", deadline);
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
