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
    
    self.ctdn = Countdown_create("Title", 2017, 05, 7, 23, 35);
    
    self.countdownLabel.stringValue = @"";
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
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

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
