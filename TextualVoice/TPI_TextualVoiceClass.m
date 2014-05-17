//
//  TPI_TextualVoiceClass.m
//  TextualVoice
//
//  Created by caktux on 2014-05-16.
//  Copyright (c) 2014 caktux. All rights reserved.
//

#import "TPI_TextualVoiceClass.h"


@interface TPI_TextualVoiceClass ()
@property (nonatomic, strong) NSDictionary *nicknames;
@end

@implementation TPI_TextualVoiceClass

- (void)pluginLoadedIntoMemory:(IRCWorld *)world
{
  /* Find ourselves. */
  NSBundle *currBundle = [NSBundle bundleForClass:[self class]];
  
  /* Find nicknames. */
  NSURL *nicksPath = [currBundle URLForResource:@"nicknames" withExtension:@"plist"];
  
  /* Load dictionary. */
  NSDictionary *nicksData = [NSDictionary dictionaryWithContentsOfURL:nicksPath];
  
  /* Save nicknames. */
  self.nicknames = nicksData;
}

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
  NSSpeechSynthesizer *synth = [[NSSpeechSynthesizer alloc] initWithVoice:@"com.apple.speech.synthesis.voice.Alex"];
  if ([NSSpeechSynthesizer isAnyApplicationSpeaking])
  {
    [synth stopSpeaking];
    [synth startSpeakingString:messageString];
  }
  else
    [synth startSpeakingString:messageString];
}

- (void)messageReceivedByServer:(IRCClient *)client
                         sender:(NSDictionary *)senderDict
                        message:(NSDictionary *)messageDict
{
	IRCChannel *c = [[self worldController] selectedChannelOn:client];
    
  NSString *sender = senderDict[@"senderNickname"];
  NSString *message = messageDict[@"messageSequence"];

  for (id key in [self nicknames]) {
    NSString *allfromnick = [[self nicknames] objectForKey:key];

    // Use voice only from selected nicknames that are either in private messages, contain our nickname or has the "true" flag to get all messages from that nickname
    if ([sender isEqualToString:key] && ([c isPrivateMessage] || [message contains:[client localNickname]] || [allfromnick isEqualToString:@"true"]))
    {
      NSSpeechSynthesizer *synth = [[NSSpeechSynthesizer alloc] initWithVoice:@"com.apple.speech.synthesis.voice.Alex"];
      if ([NSSpeechSynthesizer isAnyApplicationSpeaking])
      {
        [synth stopSpeaking];
        [synth startSpeakingString:message];
      }
      else
        [synth startSpeakingString:message];
    }
  }
}
@end
