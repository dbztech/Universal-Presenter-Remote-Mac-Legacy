//
//  DBZ_PresentWindowController.m
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 3/31/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import "DBZ_PresentWindowController.h"
#import "DBZ_SlideControl.h"

@interface DBZ_PresentWindowController ()

@end

@implementation DBZ_PresentWindowController

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
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)connectButton:(id)sender {
    _connectButton.title = @"Disconnect";
}
@end
