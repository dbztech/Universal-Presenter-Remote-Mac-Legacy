//
//  DBZ_SlideControl.m
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 4/1/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import "DBZ_SlideControl.h"

@implementation DBZ_SlideControl

static int currentslide = 5000;

+(int)currentslide { return currentslide; }

+(void)setSlide:(int)slide {
    int deltaslide = slide - currentslide;
    
    if (deltaslide < 0) {
        [self slideLeft];
    }
    if (deltaslide > 0 && deltaslide < 50) {
        [self slideRight];
    }
    if (deltaslide > 50) {
        [self playMedia];
    }
    currentslide = slide;
}

+ (void)slideControl:(int)action {
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
                                   @"\
                                   tell application \"System Events\"\n\
                                   key code 124\n\
                                   end tell"];
    switch (action) {
        case 0:
           scriptObject = [[NSAppleScript alloc] initWithSource:
                                           @"\
                                           tell application \"System Events\"\n\
                                           key code 123\n\
                                           end tell"];
            break;
        case 1:
            scriptObject = [[NSAppleScript alloc] initWithSource:
                                           @"\
                                           tell application \"System Events\"\n\
                                           key code 124\n\
                                           end tell"];
            break;
        case 2:
            scriptObject = [[NSAppleScript alloc] initWithSource:
                                           @"\
                                           tell application \"System Events\"\n\
                                           key code 124\n\
                                           end tell"];
            break;
        default:
            break;
    }
    
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    
    if (returnDescriptor != NULL)
    {
        // successful execution
        if (kAENullEvent != [returnDescriptor descriptorType])
        {
            // script returned an AppleScript result
            if (cAEList == [returnDescriptor descriptorType])
            {
                // result is a list of other descriptors
            }
            else
            {
                // coerce the result to the appropriate ObjC type
            }
        }
    }
    else
    {
        // no script result, handle error here
    }

    
}

+ (void)slideLeft {
    [self slideControl:0];
}

+ (void)slideRight {
    [self slideControl:1];
}

+ (void)playMedia {
    [self slideControl:1];
}

+(void)reset {
    currentslide = 5000;
}


@end
