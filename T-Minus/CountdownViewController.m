//
//  ViewController.m
//  T-Minus
//
//  Created by Alexander Stonehouse on 19/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import "CountdownViewController.h"
#import "AppDelegate.h"

@interface CountdownViewController()
@property (weak) IBOutlet NSTextFieldCell *countdownLabel;
@property (weak) IBOutlet NSImageView *backgroundView;
@property (nonatomic) Countdown *ctdn;
@property (nonatomic) Countdown *openingCtdn;
@property (nonatomic, strong) NSString *storagePath;
@property (nonatomic) NSTimeInterval deadline;
@property (nonatomic, strong) NSString *backgroundPath;
@end

@implementation CountdownViewController

- (void)setBackgroundPath:(NSString *)backgroundPath
{
    NSURL *bgURL = [NSURL URLWithString:backgroundPath];
    self.backgroundView.image = [[NSImage alloc] initWithContentsOfURL:bgURL];
    if (self.backgroundView.image) {
        self.countdownLabel.textColor = [NSColor whiteColor];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.countdownLabel.textColor = [NSColor blackColor];
}

- (void)viewDidAppear
{
    if (!self.connection) {
        AppDelegate *delegate = (AppDelegate*) [NSApplication sharedApplication].delegate;
        [delegate setupConnection];
        self.connection = delegate.connection;
    }
    
    if (self.ctdn) {
        self.backgroundPath = [NSString stringWithCString:self.ctdn->background encoding:NSASCIIStringEncoding];
        [self setupCountdownTimer];
    } else {
        self.ctdn = Countdown_get(self.connection);
        if (self.ctdn) {
            self.backgroundPath = [NSString stringWithCString:self.ctdn->background encoding:NSASCIIStringEncoding];
            [self setupCountdownTimer];
            
            self.openingCtdn = Countdown_get(self.connection);
            while (self.openingCtdn) {
                [self performSegueWithIdentifier:@"newCountdown" sender:self];
                self.openingCtdn = Countdown_get(self.connection);
            }
            self.openingCtdn = NULL;
        } else {
            [self showSetup];
        }
    }
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
        self.deadline = input.dateValue.timeIntervalSince1970;
        [self askAboutBackground];
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
            const char *bgPath = NULL;
            
            if (bgURL) {
                bgPath = bgURL.absoluteString.UTF8String;
                self.backgroundPath = bgURL.absoluteString;
            }
            
            self.ctdn = Countdown_createWithTimestamp(self.connection, "Title", self.deadline, bgPath);
            Countdown_save(self.connection, self.ctdn);
            [self setupCountdownTimer];
        }
    }];
}

- (void)setupCountdownTimer
{
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)newDocument:(id)sender
{
    [self performSegueWithIdentifier:@"newCountdown" sender:self];
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationController isKindOfClass:NSWindowController.class]) {
        NSWindowController *window = (NSWindowController*) segue.destinationController;
        if ([window.contentViewController isKindOfClass:CountdownViewController.class]) {
            CountdownViewController *vc = (CountdownViewController*) window.contentViewController;
            vc.connection = self.connection;
            vc.ctdn = self.openingCtdn;
        }
        
    }
}



@end
