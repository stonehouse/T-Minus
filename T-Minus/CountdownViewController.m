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
#import "CountdownView.h"

@interface CountdownViewController() <NSWindowDelegate>
@property (nonatomic, strong) CountdownView *countdownView;
@property (nonatomic, strong) NSWindowController *createWindow;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CountdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *views = nil;
    bool success = [[NSBundle mainBundle] loadNibNamed:@"CountdownView" owner:self topLevelObjects:&views];
    
    if (success) {
        for (int i = 0; i < views.count; i++) {
            id obj = [views objectAtIndex:i];
            if ([obj isKindOfClass:CountdownView.class]) {
                self.countdownView = (CountdownView*) obj;
                [self.view addSubview:self.countdownView];
                [self.countdownView setTranslatesAutoresizingMaskIntoConstraints:NO];
                
                // Add constraints to fix content to window size
                NSArray<NSLayoutConstraint*> *constraints = [NSArray arrayWithObjects:
                                                             [NSLayoutConstraint constraintWithItem:self.countdownView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f],
                                                             [NSLayoutConstraint constraintWithItem:self.countdownView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f],
                                                             [NSLayoutConstraint constraintWithItem:self.countdownView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f],
                                                             [NSLayoutConstraint constraintWithItem:self.countdownView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f],
                                                             nil];
                
                [self.view addConstraints:constraints];
            }
        }
        
    }

}

- (void)viewDidAppear
{
    self.view.window.delegate = self;
    
    if (self.ctdn) {
        [self setupCountdownTimer];
    } else {
        [self createCountdown];
    }
}

- (void)windowDidResize:(NSNotification *)notification
{

}


- (void)dealloc
{
    Countdown_destroy(self.ctdn);
}

- (void)updateTimer {
    if (!self.timer) {
        return;
    }
    
    Tminus tm = Countdown_tminus(self.ctdn);
    
    self.countdownView.description = [NSString stringWithUTF8String:tm.description];
    
    if (tm.difference == 10) {
        // With 10 seconds to go, pop to the foreground
        [NSApp activateIgnoringOtherApps:YES];
    }
    
    if (tm.finished == 1) {
        // Timer finished
        [[NSSound soundNamed:@"Basso"] play];
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)setupCountdownTimer
{
    NSWindowController *windowController = self.view.window.windowController;
    // Name frame based on countdown id, persist window position
    windowController.windowFrameAutosaveName = [NSString stringWithFormat:@"%d", self.ctdn->index];
    
    if (strlen(self.ctdn->title) > 0) {
        NSString *title = [NSString stringWithUTF8String:self.ctdn->title];
        self.view.window.title = title;
    }
    self.countdownView.backgroundPath = [NSString stringWithUTF8String:self.ctdn->background];
    
    [self setupWindow];
    
    [self updateTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)setupWindow
{
    NSImage *bgImage = self.countdownView.backgroundView.image;
    NSSize imgSize = bgImage.size;
    
    CGFloat defaultWidth = 560;
    CGFloat defaultHeight = 300;
    
    if (imgSize.width > 0 && imgSize.height > 0) {
        [self.view.window setContentAspectRatio:bgImage.size];
        NSSize defaultContentSize;
        
        if (imgSize.width > imgSize.height) {
            CGFloat ratio = imgSize.width / imgSize.height;
            defaultContentSize = NSMakeSize(defaultWidth, defaultWidth / ratio);
        } else {
            CGFloat ratio = imgSize.height / imgSize.width;
            defaultContentSize = NSMakeSize(defaultHeight / ratio, defaultHeight);
        }
        [self.view.window setContentSize:defaultContentSize];
    } else {
        [self.view.window setContentSize:NSMakeSize(defaultWidth, defaultHeight)];
        [self.view.window setContentAspectRatio:NSMakeSize(defaultWidth, defaultHeight)];
    }
    
    self.view.window.contentMaxSize = NSMakeSize(1000, 1000);
    self.view.window.contentMinSize = NSMakeSize(defaultWidth/2, defaultHeight);
}

- (void)cancel:(id)sender
{
    Countdown_delete(self.connection, self.ctdn);
    [self.view.window close];
}

- (void)createCountdown
{
    self.countdownView.description = @"";
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
