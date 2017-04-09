//
//  AppDelegate.m
//  T-Minus
//
//  Created by Alexander Stonehouse on 19/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import "AppDelegate.h"
#import "CountdownViewController.h"
#import "TminusMacUtils.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSMutableArray<NSWindowController*>* windows;

@end

@implementation AppDelegate

-(void)applicationWillFinishLaunching:(NSNotification *)notification {
//    self.windows = [NSMutableArray new];
//    
//    [self setupConnection];
//    
//    Countdown *savedCountdown = Countdown_get(self.connection);
//    while (savedCountdown) {
//        [self openCountdown:savedCountdown];
//        savedCountdown = Countdown_get(self.connection);
//    }
//    
//    // If there are no saved countdowns, create a new one
//    if (Countdown_count(self.connection) == 0) {
//        [self openCountdown:NULL];
//    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
}

- (void)setupConnection {
    self.connection = [TminusMacUtils defaultConnection];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    Database_close(self.connection);
}

- (void)openCountdown:(Countdown*)ctdn
{
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSWindowController *vc = [storyboard instantiateControllerWithIdentifier:@"countdownViewController"];
    
    CountdownViewController *content = (CountdownViewController*) vc.contentViewController;
    content.connection = self.connection;
    content.ctdn = ctdn;
    [self.windows addObject:vc];
    [vc showWindow:self];
}

- (void)newDocument:(id)sender
{
    [self openCountdown:NULL];
}

@end
