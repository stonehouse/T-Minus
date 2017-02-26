//
//  CountdownView.m
//  T-Minus
//
//  Created by Alexander Stonehouse on 26/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import "CountdownView.h"

@interface CountdownView()

@property (weak) IBOutlet NSTextFieldCell *countdownTitleLabel;
@property (weak) IBOutlet NSImageView *backgroundView;

@end

@implementation CountdownView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setBackgroundPath:(NSString *)backgroundPath
{
    NSURL *bgURL = [NSURL URLWithString:backgroundPath];
    self.backgroundView.image = [[NSImage alloc] initWithContentsOfURL:bgURL];
    if (self.backgroundView.image) {
        self.countdownLabel.textColor = [NSColor whiteColor];
        self.countdownTitleLabel.textColor = [NSColor whiteColor];
    }
}

@end
