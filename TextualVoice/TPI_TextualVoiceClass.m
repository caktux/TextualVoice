//
//  TPI_TextualVoiceClass.m
//  TextualVoice
//
//  Created by caktux on 2014-05-16.
//  Copyright (c) 2014 caktux. All rights reserved.
//

#import "TPI_TextualVoiceClass.h"
#import "NSString+Hyperlink.h"
#import "NSStringExtractedComponent.h"

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
  NSArray *components = [message componentsSplittedByHyperlink];
  NSString *textonly = @"";

  for (NSStringExtractedComponent *comp in components) {
    switch (comp.type) {
      case NSStringExtractedComponentTypeNormal:
        textonly = [textonly stringByAppendingString:comp.string];
        NSLog(@"TEXT: %@", comp.string);
        break;
      case NSStringExtractedComponentTypeHyperlink:
        NSLog(@"URL: %@", comp.string);
        break;
    }
  }

  for (id key in [self nicknames]) {
    NSString *allfromnick = [[self nicknames] objectForKey:key];

    // Use voice only from selected nicknames that are either in private messages, contain our nickname, has the "true" flag to speak all messages from that nickname or contains the channel name
    if ([sender isEqualToString:key] && ([c isPrivateMessage] || [textonly contains:[client localNickname]] || [allfromnick isEqualToString:@"true"] || [allfromnick contains:[c name]]))
    {
      NSSpeechSynthesizer *synth = [[NSSpeechSynthesizer alloc] initWithVoice:@"com.apple.speech.synthesis.voice.Alex"];
      if ([NSSpeechSynthesizer isAnyApplicationSpeaking])
      {
        [synth stopSpeaking];
        [synth startSpeakingString:textonly];
      }
      else
        [synth startSpeakingString:textonly];
    }
  }
}
@end
