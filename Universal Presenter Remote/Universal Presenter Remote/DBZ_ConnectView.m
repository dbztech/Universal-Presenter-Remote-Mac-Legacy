//
//  DBZ_ConnectView.m
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 4/11/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import "DBZ_ConnectView.h"
#import "DBZ_ServerCommunication.h"

@interface DBZ_ConnectView ()

@end

@implementation DBZ_ConnectView

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
    [DBZ_ServerCommunication connectSetup];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)leftButton:(id)sender {
    [DBZ_ServerCommunication getResponse:@"SlideDown" withToken:[DBZ_ServerCommunication token] withHoldfor:YES];
}

- (IBAction)rightButton:(id)sender {
    [DBZ_ServerCommunication getResponse:@"SlideUp" withToken:[DBZ_ServerCommunication token] withHoldfor:YES];
}

- (IBAction)mediaButton:(id)sender {
    [DBZ_ServerCommunication getResponse:@"PlayMedia" withToken:[DBZ_ServerCommunication token] withHoldfor:YES];
}

- (void)windowWillClose:(NSNotification *)notification
{
    NSNotification *outgoingnotification = [NSNotification notificationWithName:@"Reset" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:outgoingnotification];
    
}
@end
