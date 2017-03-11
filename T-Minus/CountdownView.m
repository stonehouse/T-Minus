//
//  CountdownView.m
//  T-Minus
//
//  Created by Alexander Stonehouse on 26/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import "CountdownView.h"
#import "NSImage+AverageColor.h"

@interface CountdownView()

@property (weak) IBOutlet NSTextFieldCell *countdownTitleLabel;
@property (weak) IBOutlet NSImageView *backgroundView;

@end

@implementation CountdownView

- (void)setBackgroundPath:(NSString *)backgroundPath
{
    NSURL *bgURL = [NSURL URLWithString:backgroundPath];
    self.backgroundView.image = [[NSImage alloc] initWithContentsOfURL:bgURL];
    self.countdownLabel.textColor = [self.backgroundView.image idealTextColor:self.backgroundView.bounds forSection:self.countdownLabel.controlView.bounds];
    self.countdownTitleLabel.textColor = [self.backgroundView.image idealTextColor:self.backgroundView.bounds forSection:self.countdownTitleLabel.controlView.bounds];
}

@end
