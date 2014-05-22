//
//  TPI_TextualVoiceClass.h
//  TextualVoice
//
//  Created by caktux on 2014-05-16.
//  Copyright (c) 2014 caktux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPI_TextualVoiceClass : NSObject <THOPluginProtocol>

- (NSArray *)pluginSupportsUserInputCommands;
- (void)messageSentByUser:(IRCClient *)client message:(NSString *)messageString command:(NSString *)commandString;

- (NSArray *)pluginSupportsServerInputCommands;
- (void)messageReceivedByServer:(IRCClient *)client sender:(NSDictionary *)senderDict message:(NSDictionary *)messageDict;
- (void)dealloc;

@end
