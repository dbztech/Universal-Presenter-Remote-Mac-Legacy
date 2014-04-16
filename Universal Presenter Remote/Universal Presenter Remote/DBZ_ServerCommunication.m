//
//  DBZ_ServerCommunication.m
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 4/11/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import "DBZ_ServerCommunication.h"
#import "DBZ_SlideControl.h"

@implementation DBZ_ServerCommunication

static NSString *serverAddress = @"http://upr.dbztech.com";
static int uid = 10;
static int temptoken = 10;
static int controlmode = 0;
static int token = 0;
static bool enabled = NO;
static bool serverAvailable = NO;
static NSTimer *timer;

+(NSString*)serverAddress { return  serverAddress;}
+(int)uid { return  uid;}
+(int)temptoken { return  temptoken;}
+(int)controlmode { return  controlmode;}
+(int)token { return  token;}
+(bool)enabled { return  enabled;}
+(bool)serverAvailable { return  serverAvailable;}

+(void)getResponse:(NSString*)page withToken:(int)requestToken withHoldfor:(bool)holdfor {
    __block NSString *result;
    NSString *strURL= [NSString stringWithFormat:@"%@/%@", serverAddress, page];
    if (requestToken > 99999) {
        strURL = [NSString stringWithFormat:@"%@?token=%d", strURL, requestToken];
    }
    
    if (holdfor) {
        strURL = [NSString stringWithFormat:@"%@&holdfor=%d", strURL, uid];
    }
    
    NSLog(strURL);
    
    NSURL *URL = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         //When Json request complite then call this block
         result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
         
         NSMutableArray *notify = [NSMutableArray arrayWithObjects:page, result,response, nil];
         NSNotification* notification = [NSNotification notificationWithName:@"ServerResponse" object:notify];
         [[NSNotificationCenter defaultCenter] postNotification:notification];
         
         
     }];
}

+(void)processResponse:(NSMutableArray*)webResponse {
    // The one we want to switch on
    NSArray *items = @[@"Alive", @"NewSession", @"TempSession", @"JoinSession", @"ActiveSession"];
    NSInteger item = [items indexOfObject:[webResponse objectAtIndex:0]];
    switch (item) {
        case 0:
            // Alive
            [self checkStatusCallback:[webResponse objectAtIndex:1]];
            break;
        case 1:
            // NewSession
            [self newTokenCallback:[webResponse objectAtIndex:1]];
            break;
        case 2:
            // TempSession
            [self checkTokenCallback:[webResponse objectAtIndex:1]];
            break;
        case 3:
            // JoinSession
            [self joinSessionCallback:[webResponse objectAtIndex:1]];
            break;
        case 4:
            // ActiveSession
            [self activeSessionCallback:[webResponse objectAtIndex:1]];
            break;
        default:
            break;
    }
}

+(void)setupUid {
    NSUInteger r = arc4random_uniform(999999);
    uid = (int)r;
}

+(void)checkStatus {
    [self getResponse:@"Alive" withToken:0 withHoldfor:NO];
}

+(void)checkStatusCallback:(NSString *)response {
    if ([response isEqualToString:@"Ready"]) {
        NSLog(@"Alive!");
        serverAvailable = YES;
        [self checkToken:nil];
        
    } else {
        NSLog(@"Dead :(");
        serverAvailable = NO;
        controlmode = 0;
    }
}

+(void)checkToken:(NSTimer *)timer {
    int sendtoken = temptoken;
    [self getResponse:@"TempSession" withToken:sendtoken withHoldfor:YES];
}

+(void)checkTokenCallback:(NSString*)response {
    int r = [response intValue];
    controlmode = r;
    switch (controlmode) {
        case 0:
            [timer invalidate];
            timer = nil;
            temptoken = 0;
            break;
        case 1:
            timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkToken:) userInfo:nil repeats:NO];
            break;
        case 2:
            //[self checkToken];
            break;
            
        default:
            break;
    }
    if (temptoken == 0) {
        [self getResponse:@"NewSession" withToken:0 withHoldfor:NO];
    }
    [self updateInterface];
}

+(void)newTokenCallback:(NSString*)response {
    int r = [response intValue];
    temptoken = r;
    [self checkToken:nil];
}

+(void)updateInterface {
    NSNotification* notification = [NSNotification notificationWithName:@"UpdateInterface" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

+(void)joinSession:(int)sendtoken {
    token = sendtoken;
    [self getResponse:@"JoinSession" withToken:sendtoken withHoldfor:NO];
}

+(void)joinSessionCallback:(NSString *)response {
    if ([response integerValue] > 0) {
        NSNotification* notification = [NSNotification notificationWithName:@"JoinSession" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        uid = [response intValue];
    } else {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"The token you entered was invalid, please try again"];
        [alert runModal];
    }
}

+(void)activeSessionCallback:(NSString *)response {
    if ([response integerValue] > 0) {
        NSNotification* notification = [NSNotification notificationWithName:@"ChangeSlide" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [DBZ_SlideControl setSlide:[response intValue]];
    } else {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Server error! Please restart your application and check your internet connection"];
        [alert runModal];
    }
}

+(void)connectSetup {
    token = temptoken;
}

/*
 public static void checkStatus()
 {
 if(getResponse("Alive") == "Ready")
 {
 serverAvailable = true;
 if (temptoken == 0)
 {
 try
 {
 temptoken = Int32.Parse(getResponse("NewSession"));
 }
 catch (FormatException e)
 {
 Console.WriteLine(e.Message);
 }
 }
 try
 {
 controlmode = Int32.Parse(getResponse("TempSession?token=" + temptoken + "&holdfor=" + uid));
 }
 catch (FormatException e)
 {
 Console.WriteLine(e.Message);
 }
 }
 else
 {
 serverAvailable = false;
 }
 }
 */

/*
 
 public static bool sendCommand(string command)
 {
 string response = getResponse(command + "?token=" + token + "&holdfor=" + uid);
 int r = 0;
 try
 {
 r = Int32.Parse(response);
 }
 catch (FormatException e)
 {
 Console.WriteLine(e.Message);
 }
 
 if (r == 1)
 {
 return true;
 }
 else
 {
 return false;
 }
 }
 
 
 public static bool joinSession()
 {
 string response = getResponse("JoinSession?token=" + token);
 int r = 0;
 try
 {
 r = Int32.Parse(response);
 }
 catch (FormatException e)
 {
 Console.WriteLine(e.Message);
 }
 
 if (r > 0)
 {
 uid = r;
 return true;
 }
 else
 {
 return false;
 }
 }
 
 public static void update()
 {
 string response = getResponse("ActiveSession?token=" + token + "&holdfor=" + uid);
 int r = 0;
 try
 {
 r = Int32.Parse(response);
 }
 catch (FormatException e)
 {
 Console.WriteLine(e.Message);
 }
 
 if (r > 0 && Server_Communication.enabled)
 {
 if (r > SlideControl.currentSlide)
 {
 if ((r - SlideControl.currentSlide) >= 100)
 {
 SlideControl.playMedia();
 }
 else
 {
 SlideControl.slideforward();
 }
 
 SlideControl.currentSlide = r;
 }
 if (r < SlideControl.currentSlide)
 {
 SlideControl.slidebackward();
 SlideControl.currentSlide = r;
 }
 }
 }
 */





@end
