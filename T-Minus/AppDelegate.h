//
//  AppDelegate.h
//  T-Minus
//
//  Created by Alexander Stonehouse on 19/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "tminus.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic) Connection *connection;

- (void)setupConnection;

@end

