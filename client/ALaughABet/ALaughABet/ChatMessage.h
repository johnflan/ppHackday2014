//
//  ChatMessage.h
//  ALaughABet
//
//  Created by Lar Judge on 29/05/2014.
//  Copyright (c) 2014 Lar Judge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessage : NSObject

@property NSString *username;
@property NSString *message;
@property NSString *timestamp;
@property NSString *info;

-(void)print;
@end
