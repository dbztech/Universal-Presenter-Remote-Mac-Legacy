//
//  DBZ_ServerCommunication.h
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 4/1/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBZ_ServerCommunication : NSObject


+(NSString*)serverAddress;
+(int)uid;
+(int)temptoken;
+(int)controlmode;
+(int)token;
+(bool)enabled;
+(bool)serverAvailable;

+(void)getResponse:(NSString*)page withToken:(NSInteger*)requestToken withHoldfor:(NSInteger*)holdfor;
+(void)processResponse:(NSMutableArray*)webResponse;
+(void)setupUid;
+(void)checkStatus;
+(void)checkStatusCallback:(NSString*)response;
+(void)checkToken;
+(void)checkTokenCallback:(NSString*)response;
+(void)newTokenCallback:(NSString*)response;

@end
