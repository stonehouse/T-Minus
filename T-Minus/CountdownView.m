//
//  CountdownView.m
//  T-Minus
//
//  Created by Alexander Stonehouse on 26/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import "CountdownView.h"
#import "NSImageView+AverageColor.h"

@interface CountdownView()

@property (weak) IBOutlet NSTextFieldCell *countdownTitleLabel;

@end

@implementation CountdownView

- (void)setBackgroundPath:(NSString *)backgroundPath
{
    NSURL *bgURL = [NSURL URLWithString:backgroundPath];
    self.backgroundView.image = [[NSImage alloc] initWithContentsOfURL:bgURL];
    [self adjustTextColor];
}

- (void)adjustTextColor
{
    CGRect sectionCountdown = [self convertRect:self.countdownLabel.controlView.frame toView:self.backgroundView];
    self.countdownLabel.textColor = [self.backgroundView idealTextColorForSection:sectionCountdown];
    self.countdownTitleLabel.textColor = [self.countdownLabel.textColor copy];
}

@end
