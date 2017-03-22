//
//  CountdownView.h
//  T-Minus
//
//  Created by Alexander Stonehouse on 26/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CountdownView : NSView

@property (nonatomic, strong) NSString *countdownDescription;
@property (nonatomic, strong) NSString *backgroundPath;
@property (weak) IBOutlet NSImageView *backgroundView;

@end
