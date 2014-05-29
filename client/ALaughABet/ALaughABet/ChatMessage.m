//
//  ChatMessage.m
//  ALaughABet
//
//  Created by Lar Judge on 29/05/2014.
//  Copyright (c) 2014 Lar Judge. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage

@synthesize username = _username;
@synthesize message = _message;
@synthesize timestamp = _timestamp;

-(void)print
{
    NSLog(@"%@", _message);
}
@end
