//
//  DBZ_PresentView.m
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 4/11/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import "DBZ_PresentView.h"
#import "DBZ_ServerCommunication.h"

@interface DBZ_PresentView ()

@end

@implementation DBZ_PresentView

NSTimer *timer;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:self.window];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
}

- (void)windowWillClose:(NSNotification *)notification
{
    NSNotification *outgoingnotification = [NSNotification notificationWithName:@"Reset" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:outgoingnotification];
    
}

- (IBAction)connectButton:(id)sender {
    _connectButton.title = @"Disconnect";
    timer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(checkSlide:) userInfo:nil repeats:YES];
}

-(void)checkSlide:(NSTimer *)timer {
    [DBZ_ServerCommunication getResponse:@"ActiveSession" withToken:[DBZ_ServerCommunication token] withHoldfor:YES];
}

@end
