//
//  NSImageView+AverageColor.m
//  T-Minus
//
//  Created by Alexander Stonehouse on 27/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import "NSImageView+AverageColor.h"

@implementation NSImageView (AverageColor)

- (NSColor *)averageColor {
    return [self averageColorForSection:self.bounds];
}

- (NSColor *)averageColorForSection:(CGRect)section {
    NSColorSpace* colorSpaceObj = [NSColorSpace deviceRGBColorSpace];

    if (!self.image) {
        return [[NSColor whiteColor] colorUsingColorSpace:colorSpaceObj];
    }
    
    CGColorSpaceRef colorSpace = colorSpaceObj.CGColorSpace;
    
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGRect bounds = self.bounds;
    
    CGImageRef ref = [self.image CGImageForProposedRect:&bounds context:nil hints:nil];
    CGContextDrawImage(context, section, ref);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    if(rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [NSColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    }
    else {
        return [NSColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}

- (NSColor *)idealTextColor
{
    return [self idealTextColorForSection:self.bounds];
}

- (NSColor *)idealTextColorForSection:(CGRect)section
{
    NSColor *avgColor = [self averageColorForSection:section];
    CGFloat red = avgColor.redComponent * 255, green = avgColor.greenComponent * 255, blue = avgColor.blueComponent * 255;
    
    int threshold = 186;
    int bgDelta = ((red * 0.299) + (green * 0.587) + (blue * 0.114));
    
    return (255 - bgDelta < threshold) ? [NSColor blackColor] : [NSColor whiteColor];
}

@end
