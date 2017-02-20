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
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.countdownLabel.stringValue = @"";
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
}


- (void)viewWillAppear {
    
}

- (void)viewWillDisappear {
    
}

- (void)updateTimer {
    Countdown ctdn = Countdown_create(2017, 05, 7, 23, 35);
    char *str = Countdown_toString(ctdn);
    self.countdownLabel.stringValue = [NSString stringWithCString:str encoding:NSASCIIStringEncoding];
    
    Countdown_destroy(ctdn);
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
