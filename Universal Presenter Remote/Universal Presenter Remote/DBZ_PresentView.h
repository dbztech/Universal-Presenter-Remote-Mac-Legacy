//
//  DBZ_PresentView.h
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 4/11/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DBZ_PresentView : NSWindowController

@property (weak) IBOutlet NSButton *connectButton;

- (IBAction)connectButton:(id)sender;
-(void)checkSlide:(NSTimer *)timer;

@end
