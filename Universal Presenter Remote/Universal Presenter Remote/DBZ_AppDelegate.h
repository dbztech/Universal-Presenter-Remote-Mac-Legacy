//
//  DBZ_AppDelegate.h
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 3/31/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DBZ_AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *token1;
@property (weak) IBOutlet NSTextField *token2;
@property (weak) IBOutlet NSTextField *token3;
@property (weak) IBOutlet NSTextField *token4;
@property (weak) IBOutlet NSTextField *token5;
@property (weak) IBOutlet NSTextField *token6;
- (void)controlTextDidChange:(NSNotification *)notification;

- (IBAction)connectButton:(id)sender;

@end
