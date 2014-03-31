//
//  DBZ_AppDelegate.m
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 3/31/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import "DBZ_AppDelegate.h"

@implementation DBZ_AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)controlTextDidChange:(NSNotification *)notification {
    // there was a text change in some control
    // [notification object] points to the control that has sent
    // the notification
    /*
    if ([notification object] == nameField) {
        // nameField has changed
    }
    else if ([notification object] == addressField) {
        // addressField has changed
    }
     */
    
    
    
    NSLog(@"Hello World3");
    
}

- (IBAction)connectButton:(id)sender {
    NSLog(@"Hello World");
}
@end
