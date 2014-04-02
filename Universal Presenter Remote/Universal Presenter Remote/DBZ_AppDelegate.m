//
//  DBZ_AppDelegate.m
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 3/31/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import "DBZ_AppDelegate.h"
#import "DBZ_PresentWindowController.h"
#import "DBZ_ServerCommunication.h"

@implementation DBZ_AppDelegate

DBZ_PresentWindowController *presentWindow;

-(void)applicationDidFinishLaunching:(NSNotification *)Notification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotification:) name:@"ServerResponse" object:nil];
    
    
    [DBZ_ServerCommunication setupUid];
    [DBZ_ServerCommunication checkStatus];
    
    NSTimer *checkServerTimer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(checkServer:) userInfo:nil repeats:YES];
    
    
    presentWindow = [[DBZ_PresentWindowController alloc] initWithWindowNibName:@"DBZ_PresentWindowController"];
    [_token1 becomeFirstResponder];
    // Insert code here to initialize your application
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:NSControlTextDidChangeNotification object:_token1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:NSControlTextDidChangeNotification object:_token2];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:NSControlTextDidChangeNotification object:_token3];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:NSControlTextDidChangeNotification object:_token4];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:NSControlTextDidChangeNotification object:_token5];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:NSControlTextDidChangeNotification object:_token6];
}

-(void) incomingNotification:(NSNotification *)notification {
    NSMutableArray *incoming = [notification object];
    [DBZ_ServerCommunication processResponse:incoming];
}

- (void)textViewDidChange:(NSNotification*)notification {
    // Do whatever you like to respond to text changes here.
    if ([notification object] == _token1) {
        [_token2 becomeFirstResponder];
        [self validate];
    } else if ([notification object] == _token2) {
        [_token3 becomeFirstResponder];
        [self validate];
    } else if ([notification object] == _token3) {
        [_token4 becomeFirstResponder];
        [self validate];
    } else if ([notification object] == _token4) {
        [_token5 becomeFirstResponder];
        [self validate];
    } else if ([notification object] == _token5) {
        [_token6 becomeFirstResponder];
        [self validate];
    } else if ([notification object] == _token6) {
        [self validate];
    }
}

-(void)validate {
    if (![[_token1 stringValue] isEqualToString:@""] && ![[_token2 stringValue] isEqualToString:@""] && ![[_token3 stringValue] isEqualToString:@""] && ![[_token4 stringValue] isEqualToString:@""] && ![[_token5 stringValue] isEqualToString:@""] && ![[_token6 stringValue] isEqualToString:@""]) {
        _connectButton.enabled = YES;
    } else {
        _connectButton.enabled = NO;
    }
}

-(IBAction)connectButton:(id)sender {
    [_window orderOut:self];
    [presentWindow showWindow:self];
}

-(void)checkServer:(NSTimer*) timer {
    [DBZ_ServerCommunication checkStatus];
}
@end
