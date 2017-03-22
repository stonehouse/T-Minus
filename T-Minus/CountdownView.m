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

@property (weak) IBOutlet NSTextFieldCell *countdownLabel;
@property (weak) IBOutlet NSTextFieldCell *countdownTitleLabel;
@property (weak) IBOutlet NSVisualEffectView *visualEffectView;
@property (weak) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation CountdownView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.visualEffectView.layer.cornerRadius = 5.0f;
}

- (void)setDescription:(NSString *)description
{
    self.countdownLabel.stringValue = description;
    CGFloat currentWidth = self.widthConstraint.constant;
    CGFloat defaultPadding = 20;
    CGFloat desiredWidth = [self.countdownLabel cellSize].width + defaultPadding;
    CGFloat diff = currentWidth - desiredWidth;
    if (diff < 0 || diff > 40) {
        self.widthConstraint.constant = desiredWidth + defaultPadding;
        [self setNeedsUpdateConstraints:YES];
    }
}

- (void)setBackgroundPath:(NSString *)backgroundPath
{
    NSURL *bgURL = [NSURL fileURLWithPath:backgroundPath];
    self.backgroundView.image = [[NSImage alloc] initWithContentsOfURL:bgURL];
    self.countdownLabel.textColor = [NSColor whiteColor];
    self.countdownTitleLabel.textColor = [NSColor whiteColor];
}

- (void)adjustTextColor
{
    CGRect sectionCountdown = [self convertRect:self.countdownLabel.controlView.frame toView:self.backgroundView];
    self.countdownLabel.textColor = [self.backgroundView idealTextColorForSection:sectionCountdown];
    self.countdownTitleLabel.textColor = [self.countdownLabel.textColor copy];
}

@end
