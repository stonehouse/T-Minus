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
@property (weak) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation CountdownView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.visualEffectView.layer.cornerRadius = 5.0f;
}

- (void)setCountdownDescription:(NSString *)countdownDescription
{
    self.countdownLabel.stringValue = countdownDescription;
    CGFloat currentWidth = self.widthConstraint.constant;
    CGFloat defaultPadding = 20;
    CGFloat desiredWidth = [self.countdownLabel cellSize].width + defaultPadding;
    CGFloat diff = currentWidth - desiredWidth;
    if (diff < 0 || diff > 40) {
        if (desiredWidth > self.frame.size.width + defaultPadding) {
            self.widthConstraint.constant = self.frame.size.width - defaultPadding;
        } else {
            self.widthConstraint.constant = desiredWidth;
        }
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

@end
