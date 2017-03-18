//
//  TminusMacUtils.h
//  T-Minus
//
//  Created by Alexander Stonehouse on 18/03/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "tminus.h"

@interface TminusMacUtils : NSObject

+ (NSURL *)backgroundsFolder;
+ (NSURL *)documentsFolder;
+ (Connection *)defaultConnection;
+ (NSImage *)imageForCountdown:(Countdown *)ctdn;

@end
