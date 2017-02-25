//
//  AppDelegate.m
//  T-Minus
//
//  Created by Alexander Stonehouse on 19/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import "AppDelegate.h"
#import "CountdownViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)applicationWillFinishLaunching:(NSNotification *)notification {
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    
}

- (void)setupConnection {
    NSString *storagePath = NSHomeDirectory();
    NSString *db = [storagePath stringByAppendingString:@"/.tminus.db"];
    
    self.connection = Database_open(db.UTF8String);
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    Database_close(self.connection);
}

@end
