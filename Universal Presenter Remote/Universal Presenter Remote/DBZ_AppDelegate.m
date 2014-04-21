//
//  DBZ_AppDelegate.m
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 4/11/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import "DBZ_AppDelegate.h"
#import "DBZ_ConnectView.h"
#import "DBZ_PresentView.h"
#import "DBZ_ServerCommunication.h"
#import "DBZ_SlideControl.h"

@implementation DBZ_AppDelegate

DBZ_PresentView *presentWindow;
DBZ_ConnectView *connectWindow;

-(void)applicationDidFinishLaunching:(NSNotification *)Notification {
    if ([[NSProcessInfo processInfo] respondsToSelector:@selector(beginActivityWithOptions:reason:)]) {
        self.activity = [[NSProcessInfo processInfo] beginActivityWithOptions:0x00FFFFFF reason:@"receiving OSC messages"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotification:) name:@"ServerResponse" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInterface:) name:@"UpdateInterface" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinSession:) name:@"JoinSession" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reset:) name:@"Reset" object:nil];
    [self.window setBackgroundColor: [NSColor colorWithRed:52.0f/255.0f green:6.0f/255.0f blue:54.0f/255.0f alpha:1.0f]];
    
    [DBZ_ServerCommunication setupUid];
    [DBZ_ServerCommunication checkStatus];
    
    //NSTimer *checkServerTimer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(checkServer:) userInfo:nil repeats:YES];
    
    
    presentWindow = [[DBZ_PresentView alloc] initWithWindowNibName:@"DBZ_PresentView"];
    connectWindow = [[DBZ_ConnectView alloc] initWithWindowNibName:@"DBZ_ConnectView"];
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
        _presentButton.enabled = YES;
    } else {
        _presentButton.enabled = NO;
    }
}

- (IBAction)presentButton:(id)sender {
    [_presentButton setEnabled:NO];
    [_presentButton setTitle:@"Connecting..."];
    NSString *presentToken = [NSString stringWithFormat:@"%@%@%@%@%@%@",[_token1 stringValue],[_token2 stringValue],[_token3 stringValue],[_token4 stringValue],[_token5 stringValue],[_token6 stringValue]];
    int temp = [presentToken intValue];
    [DBZ_ServerCommunication joinSession:temp];
}

-(IBAction)connectButton:(id)sender {
    [_window orderOut:self];
    [connectWindow showWindow:self];
}

-(void)checkServer:(NSTimer*) timer {
    [DBZ_ServerCommunication checkStatus];
}

-(void)updateInterface:(NSNotification*)notification {
    int token = DBZ_ServerCommunication.temptoken;
    switch ([DBZ_ServerCommunication controlmode]) {
        case 1:
            [_connectButton setTitle:@"Waiting..."];
            [_connectButton setEnabled:NO];
            [_tokenLabel setStringValue: [NSString stringWithFormat:@"%d",token]];
            break;
            
        case 2:
            [_connectButton setTitle:@"Connect"];
            [_connectButton setEnabled:YES];
            break;
            
        default:
            [_connectButton setTitle:@"Connecting..."];
            [_connectButton setEnabled:NO];
            break;
    }
}

-(void)joinSession:(NSNotification *)notification {
    [_window orderOut:self];
    [presentWindow showWindow:self];
}

- (void)reset:(NSNotification *)notification
{
    [_window makeKeyAndOrderFront:self];
    _token1.stringValue = @"";
    _token2.stringValue = @"";
    _token3.stringValue = @"";
    _token4.stringValue = @"";
    _token5.stringValue = @"";
    _token6.stringValue = @"";
    _connectButton.title = @"Connect";
    [_token1 becomeFirstResponder];
    [DBZ_ServerCommunication setupUid];
    [DBZ_ServerCommunication checkStatus];
    [DBZ_SlideControl reset];
}

@end
