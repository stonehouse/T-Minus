//
//  CreateCountdownViewController.h
//  T-Minus
//
//  Created by Alexander Stonehouse on 26/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "tminus.h"

@interface CreateCountdownViewController : NSViewController

@property (nonatomic) Countdown *ctdn;
@property (nonatomic) Connection *conn;

@end
