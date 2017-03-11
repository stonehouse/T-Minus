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
    time_t donnie = SECONDS_IN_DAY * 28 + SECONDS_IN_HOUR * 6 + 42 * 60 + 12; // Why are you wearing that stupid bunny suit?
    self.deadlinePicker.dateValue = [now dateByAddingTimeInterval: donnie];
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
    int response;
    
    if (!self.ctdn) {
        NSAlert *alert = [NSAlert new];
        alert.messageText = NSLocalizedString(@"Too Many Countdowns", nil);
        alert.informativeText = NSLocalizedString(@"Sorry, but we do not currently support that many parallel countdowns. Try cancelling some running countdowns first.", nil);
        [alert addButtonWithTitle:NSLocalizedString(@"OK", nil)];
        [alert runModal];
        response = NSModalResponseCancel;
    } else {
        Countdown_save(self.conn, self.ctdn);
        response = NSModalResponseOK;
    }
    
    NSWindow *window = self.view.window;
    [window.sheetParent endSheet:window returnCode:response];
}

- (IBAction)cancel:(id)sender
{
    NSWindow *window = self.view.window;
    [window.sheetParent endSheet:window returnCode:NSModalResponseCancel];
}

@end
