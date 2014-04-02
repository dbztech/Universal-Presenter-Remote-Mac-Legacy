//
//  DBZ_ServerCommunication.m
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 4/1/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import "DBZ_ServerCommunication.h"
#import "DBZ_SlideControl.h"

@implementation DBZ_ServerCommunication

static NSString *serverAddress = @"http://localhost";
static int uid = 0;
static int temptoken = 0;
static int controlmode = 0;
static int token = 0;
static bool enabled = NO;
static bool serverAvailable = NO;

+(NSString*)serverAddress { return  serverAddress;}
+(int)uid { return  uid;}
+(int)temptoken { return  temptoken;}
+(int)controlmode { return  controlmode;}
+(int)token { return  token;}
+(bool)enabled { return  enabled;}
+(bool)serverAvailable { return  serverAvailable;}

+(void)getResponse:(NSString*)page withToken:(NSInteger*)requestToken withHoldfor:(NSInteger*)holdfor {
    __block NSString *result;
    NSString *strURL= [NSString stringWithFormat:@"%@/%@", serverAddress, page];
    if (requestToken != nil) {
        strURL = [NSString stringWithFormat:@"%@?token=%d", strURL, (int)requestToken];
    }
    
    if (holdfor != nil) {
        strURL = [NSString stringWithFormat:@"%@&holdfor=%d", strURL, (int)holdfor];
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
         
         [NSNotificationCenter defaultCenter];
         NSNotification* notification = [NSNotification notificationWithName:@"ServerResponse" object:notify];
         [[NSNotificationCenter defaultCenter] postNotification:notification];
         
         
     }];
}

+(void)processResponse:(NSMutableArray*)webResponse {
    // The one we want to switch on
    NSArray *items = @[@"Alive", @"NewSession", @"TempSession"];
    int item = [items indexOfObject:[webResponse objectAtIndex:0]];
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
        default:
            break;
    }
}

+(void)setupUid {
    NSUInteger r = arc4random_uniform(999999);
    uid = (int)r;
}

+(void)checkStatus {
    [self getResponse:@"Alive" withToken:nil withHoldfor:nil];
}

+(void)checkStatusCallback:(NSString *)response {
    if ([response isEqualToString:@"Ready"]) {
        NSLog(@"Alive!");
        serverAvailable = YES;
        [self checkToken];
        
    } else {
        NSLog(@"Dead :(");
        serverAvailable = NO;
    }
}

+(void)checkToken {
    [self getResponse:@"TempSession" withToken:(NSInteger*)temptoken withHoldfor:(NSInteger*)uid];
}

+(void)checkTokenCallback:(NSString*)response {
    int r = [response intValue];
    controlmode = r;
    if (controlmode == 0) {
        temptoken = 0;
    }
    if (temptoken == 0) {
        [self getResponse:@"NewSession" withToken:nil withHoldfor:nil];
    }
}

+(void)newTokenCallback:(NSString*)response {
    if (temptoken == 0) {
        NSInteger r = [response intValue];
        temptoken = r;
    }
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
