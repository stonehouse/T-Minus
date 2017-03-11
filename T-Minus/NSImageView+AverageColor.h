//
//  NSImageView+AverageColor.h
//  T-Minus
//
//  Created by Alexander Stonehouse on 27/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImageView (AverageColor)

- (NSColor *)averageColor;
- (NSColor *)averageColorForSection:(CGRect)section;

/**
 Determines ideal text colour based on the size of the image rect and a specific subsection of that rect. 
 Useful for determining what colour text should be over an image.

 @param section Section of the image where ideal text colour is desired
 @return Either black or white
 */
- (NSColor *)idealTextColorForSection:(CGRect)section;
- (NSColor *)idealTextColor;

@end
