//
//  ViewController.m
//  T-Minus
//
//  Created by Alexander Stonehouse on 19/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import "CountdownViewController.h"
#import "AppDelegate.h"
#import "CreateCountdownViewController.h"

@interface CountdownViewController()
@property (weak) IBOutlet NSTextFieldCell *countdownTitleLabel;
@property (weak) IBOutlet NSTextFieldCell *countdownLabel;
@property (weak) IBOutlet NSImageView *backgroundView;
@property (nonatomic, strong) NSString *backgroundPath;
@property (nonatomic, strong) NSWindowController *createWindow;
@end

@implementation CountdownViewController

- (void)setBackgroundPath:(NSString *)backgroundPath
{
    NSURL *bgURL = [NSURL URLWithString:backgroundPath];
    self.backgroundView.image = [[NSImage alloc] initWithContentsOfURL:bgURL];
    if (self.backgroundView.image) {
        self.countdownLabel.textColor = [NSColor whiteColor];
        self.countdownTitleLabel.textColor = [NSColor whiteColor];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear
{
    if (self.ctdn) {
        [self setupCountdownTimer];
    } else {
        [self createCountdown];
    }
}

- (void)dealloc
{
    Countdown_destroy(self.ctdn);
}

- (void)updateTimer {
    Tminus *tm = Countdown_tminus(self.ctdn);
    
    self.countdownLabel.stringValue = [NSString stringWithUTF8String:tm->description];
    
    Tminus_destroy(tm);
}

- (void)setupCountdownTimer
{
    if (strlen(self.ctdn->title) > 0) {
        NSString *title = [NSString stringWithUTF8String:self.ctdn->title];
        self.view.window.title = title;
    }
    self.backgroundPath = [NSString stringWithUTF8String:self.ctdn->background];
    [self updateTimer];
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)cancel:(id)sender
{
    Countdown_delete(self.connection, self.ctdn);
    [self.view.window close];
}

- (void)createCountdown
{
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSWindowController *vc = [storyboard instantiateControllerWithIdentifier:@"createCountdown"];
    
    CreateCountdownViewController *content = (CreateCountdownViewController*) vc.contentViewController;
    content.conn = self.connection;
    self.createWindow = vc;
    
    [self.view.window beginSheet:vc.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSModalResponseCancel) {
            [self.view.window close];
        } else {
            CreateCountdownViewController *content = (CreateCountdownViewController*) self.createWindow.contentViewController;
            self.ctdn = content.ctdn;
            [self setupCountdownTimer];
        }
    }];
}



@end
