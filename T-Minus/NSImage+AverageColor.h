//
//  NSImageView+AverageColor.h
//  T-Minus
//
//  Created by Alexander Stonehouse on 27/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (AverageColor)

- (NSColor *)averageColor:(CGRect)imageRect forSection:(CGRect)section;
- (NSColor *)idealTextColor:(CGRect)imageRect forSection:(CGRect)section;

@end
