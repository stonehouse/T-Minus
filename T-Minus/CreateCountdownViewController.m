//
//  CreateCountdownViewController.m
//  T-Minus
//
//  Created by Alexander Stonehouse on 26/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#import "CreateCountdownViewController.h"

@interface CreateCountdownViewController ()

@property (weak) IBOutlet NSTextField *titleTextField;
@property (weak) IBOutlet NSDatePicker *deadlinePicker;
@property (nonatomic, strong) NSString *backgroundPath;

@end

@implementation CreateCountdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *now = [NSDate date];
    self.deadlinePicker.minDate = now;
    self.deadlinePicker.dateValue = [now dateByAddingTimeInterval: SECONDS_IN_DAY * 10];
    self.deadlinePicker.maxDate = [now dateByAddingTimeInterval: SECONDS_IN_YEAR];
}

- (IBAction)addCustomBackground:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        NSURL *bgURL = panel.URLs.firstObject;
        self.backgroundPath = bgURL.absoluteString;
    }
}

- (IBAction)save:(id)sender
{
    time_t deadline = self.deadlinePicker.dateValue.timeIntervalSince1970;
    const char *title = self.titleTextField.stringValue.UTF8String;
    const char *bgPath = NULL;
    if (self.backgroundPath) {
        bgPath = self.backgroundPath.UTF8String;
    }
    
    self.ctdn = Countdown_createWithTimestamp(self.conn, title, deadline, bgPath);
    Countdown_save(self.conn, self.ctdn);
    
    NSWindow *window = self.view.window;
    [window.sheetParent endSheet:window returnCode:NSModalResponseOK];
}

- (IBAction)cancel:(id)sender
{
    NSWindow *window = self.view.window;
    [window.sheetParent endSheet:window returnCode:NSModalResponseCancel];
}

@end
