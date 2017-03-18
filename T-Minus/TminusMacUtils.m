//
//  TminusMacUtils.m
//  T-Minus
//
//  Created by Alexander Stonehouse on 18/03/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import "TminusMacUtils.h"
#import <Cocoa/Cocoa.h>

@implementation TminusMacUtils

+ (NSURL *)documentsFolder
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *appGroupName = @"group.tminus";
    
    NSURL *groupContainerURL = [fm containerURLForSecurityApplicationGroupIdentifier:appGroupName];
    groupContainerURL = [[groupContainerURL URLByAppendingPathComponent:@"Library"] URLByAppendingPathComponent:@"Application Support"];
    return groupContainerURL;
}

+ (NSURL *)backgroundsFolder
{
    NSURL *documentsFolder = [self documentsFolder];
    NSURL *backgroundsPath = [documentsFolder URLByAppendingPathComponent:@"Backgrounds"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exists = [fm fileExistsAtPath:backgroundsPath.path];
    
    if (!exists) {
        [fm createDirectoryAtPath:backgroundsPath.path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return backgroundsPath;
}

+ (Connection *)defaultConnection
{
    NSURL *documentsFolder = [self documentsFolder];
    #if DEBUG
    NSString *dbFile = @"/.tminus.debug.db";
    #else
    NSString *dbFile = @"/.tminus.db";
    #endif
    NSString *db = [documentsFolder.path stringByAppendingString:dbFile];
    return Database_open(db.UTF8String);
}

+ (NSImage *)imageForCountdown:(Countdown *)ctdn
{
    NSString *backgroundPath = [NSString stringWithUTF8String:ctdn->background];
    NSURL *bgURL = [NSURL fileURLWithPath:backgroundPath];
    return [[NSImage alloc] initWithContentsOfURL:bgURL];
}

@end
