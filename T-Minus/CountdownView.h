//
//  CountdownView.h
//  T-Minus
//
//  Created by Alexander Stonehouse on 26/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CountdownView : NSView

@property (weak) IBOutlet NSTextFieldCell *countdownLabel;
@property (nonatomic, strong) NSString *backgroundPath;

@end
