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
@property (weak) IBOutlet NSImageView *backgroundView;
@property (nonatomic) Countdown *ctdn;
@property (nonatomic) Connection *connection;
@property (nonatomic, strong) NSString *documentsPath;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.countdownLabel.textColor = [NSColor blackColor];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.documentsPath = [paths objectAtIndex:0];
    NSString *db = [self.documentsPath stringByAppendingString:@"/.tminus.db"];
    
    self.connection = Database_open(db.cString);
}

- (void)viewDidAppear
{
    if (self.connection->db->rows[0].deadline != 0) {
        self.ctdn = &(self.connection->db->rows[0]);
        [self setupCountdownTimer];
    } else {
        [self showSetup];
    }
}

- (void)dealloc
{
    Database_close(self.connection);
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
        [self askAboutBackground];
        self.ctdn = Countdown_createWithTimestamp("Title", input.dateValue.timeIntervalSince1970);
        Countdown_save(self.connection, self.ctdn);
        [self setupCountdownTimer];
    }];
}

- (void)askAboutBackground
{
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert setMessageText:@"Do you what to pick a background?"];
    [alert setInformativeText:NSLocalizedString(@"You can pick a custom background for your countdown if you like.", nil)];
    [alert addButtonWithTitle:NSLocalizedString(@"OK", nil)];
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [alert setAlertStyle:NSAlertStyleInformational];
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == 1000) {
            [self showBackgroundSelect];
        }
    }];
}

- (void)showBackgroundSelect
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *bgURL = panel.URLs.firstObject;
            if (bgURL) {
                self.backgroundView.image = [[NSImage alloc] initWithContentsOfURL:bgURL];
                self.countdownLabel.textColor = [NSColor whiteColor];
            }
        }
    }];
}

- (void)setupCountdownTimer
{
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

@end
