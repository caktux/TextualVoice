//
//  TPI_TextualVoiceClass.h
//  TextualVoice
//
//  Created by caktux on 2014-05-16.
//  Copyright (c) 2014 caktux. All rights reserved.
//

#import "TextualApplication.h"
#import <Foundation/Foundation.h>

@interface TPI_TextualVoiceClass : NSObject <THOPluginProtocol>

- (NSArray *)subscribedUserInputCommands;

- (void)userInputCommandInvokedOnClient:(IRCClient *)client
                          commandString:(NSString *)commandString
                          messageString:(NSString *)messageString;

- (NSArray *)subscribedServerInputCommands;
- (void)didReceiveServerInputOnClient:(IRCClient *)client
                    senderInformation:(NSDictionary *)senderDict
                   messageInformation:(NSDictionary *)messageDict;

- (void)dealloc;

@end
