//
//  TPI_TextualVoiceClass.m
//  TextualVoice
//
//  Created by caktux on 2014-05-16.
//  Copyright (c) 2014 caktux. All rights reserved.
//

#import "TPI_TextualVoiceClass.h"

@implementation TPI_TextualVoiceClass

- (NSArray *)pluginSupportsUserInputCommands
{
  return @[@"say"];
}
- (NSArray *)pluginSupportsServerInputCommands
{
  return @[@"privmsg"];
}

- (void)messageSentByUser:(IRCClient *)client
                  message:(NSString *)messageString
                  command:(NSString *)commandString
{
  [client printDebugInformation:messageString];

  NSSpeechSynthesizer *synth = [[NSSpeechSynthesizer alloc] initWithVoice:@"com.apple.speech.synthesis.voice.Alex"];
  [synth startSpeakingString:messageString];
}

- (void)messageReceivedByServer:(IRCClient *)client
                         sender:(NSDictionary *)senderDict
                        message:(NSDictionary *)messageDict
{
  NSString *sender = senderDict[@"senderNickname"];
  NSString *message = messageDict[@"messageSequence"];
  
  if ([sender isEqualToString:@"ZeroGox"])
  {
    //  [client printDebugInformation:message];
    NSSpeechSynthesizer *synth = [[NSSpeechSynthesizer alloc] initWithVoice:@"com.apple.speech.synthesis.voice.Alex"];
    [synth startSpeakingString:message];
  }
}
@end
