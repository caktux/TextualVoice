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
@property (nonatomic, strong) NSSpeechSynthesizer *synth;
@property (nonatomic, readwrite) Boolean enabled;
@property (nonatomic, readwrite) float volume;
@end

@implementation TPI_TextualVoiceClass

- (void)pluginLoadedIntoMemory:(IRCWorld *)world
{
  self.enabled = true;
  self.volume = 0.5;

  /* Find ourselves. */
  NSBundle *currBundle = [NSBundle bundleForClass:[self class]];
  
  /* Find nicknames. */
  NSURL *nicksPath = [currBundle URLForResource:@"nicknames" withExtension:@"plist"];
  
  /* Load dictionary. */
  NSDictionary *nicksData = [NSDictionary dictionaryWithContentsOfURL:nicksPath];
  
  /* Save nicknames. */
  self.nicknames = nicksData;

  self.synth = [[NSSpeechSynthesizer alloc] init];
}

- (NSArray *)pluginSupportsUserInputCommands
{
  return @[@"say", @"talk", @"volume"];
}

- (NSArray *)pluginSupportsServerInputCommands
{
  return @[@"privmsg"];
}

- (void)messageSentByUser:(IRCClient *)client
                  message:(NSString *)messageString
                  command:(NSString *)commandString
{
  IRCChannel *c = [[self worldController] selectedChannelOn:client];

  if ([commandString isEqualToString:@"SAY"])
  {
    [self.synth stopSpeaking];
    [self.synth setVolume:self.volume];
    [self.synth startSpeakingString:messageString];
  }
  else if ([commandString isEqualToString:@"TALK"])
  {
    if ([messageString isEqualToString:@"off"])
    {
      [client printDebugInformation:TXTLS(@"ssshh") channel:c];
      self.enabled = false;
    }
    else if ([messageString isEqualToString:@"on"])
    {
      [client printDebugInformation:TXTLS(@"aaaah") channel:c];
      self.enabled = true;
    }
  }
  else if ([commandString isEqualToString:@"VOLUME"])
  {
    double newVolume = [messageString doubleValue];
    self.volume = newVolume;
    [client printDebugInformation:TXTLS([NSString stringWithFormat:@"volume set to %f", self.volume]) channel:c];
  }
}

- (void)messageReceivedByServer:(IRCClient *)client
                         sender:(NSDictionary *)senderDict
                        message:(NSDictionary *)messageDict
{
  NSString *channel = @"";
  NSArray *params = messageDict[@"messageParamaters"];
  if ([params count] > 0 && [params[0] hasPrefix:@"#"])
  {
    IRCChannel *c = [client findChannel:params[0]];
    channel = [c name];
  }
  else if ([params count] > 0 && [params[0] hasPrefix:@"~"])
  {
    channel = params[0];
    // NSLog(@"%@", channel);
  }

  NSString *sender = senderDict[@"senderNickname"];
  NSString *message = messageDict[@"messageSequence"];
  NSArray *components = [message componentsSplittedByHyperlink];
  NSString *textonly = @"";

  for (NSStringExtractedComponent *comp in components) {
    switch (comp.type) {
      case NSStringExtractedComponentTypeNormal:
        textonly = [textonly stringByAppendingString:comp.string];
        // NSLog(@"TEXT: %@", comp.string);
        break;
      case NSStringExtractedComponentTypeHyperlink:
        // NSLog(@"URL: %@", comp.string);
        break;
    }
  }
  
  textonly = [textonly stringByReplacingOccurrencesOfString:@"=>" withString:@" "];

  for (id key in [self nicknames]) {
    NSString *allfromnick = [[self nicknames] objectForKey:key];

    // Use voice only from selected nicknames that are either in private messages, contain our nickname, has the "true" flag to speak all messages from that nickname or contains the channel name
    if (self.enabled && [sender isEqualToString:key] && (
           [textonly contains:[client localNickname]] ||
           [allfromnick isEqualToString:@"true"] ||
           [allfromnick contains:channel] ||
           [channel length] == 0 // private message?
        ))
    {
      if ([allfromnick hasPrefix:@"voice:"]) {
        NSArray *chans = [allfromnick componentsSeparatedByString:@" "];
        NSString *voice = [chans[0] stringByReplacingOccurrencesOfString:@"voice:" withString:@"com.apple.speech.synthesis.voice."];
        self.synth = [self.synth initWithVoice:voice];
      }
      else
      {
        self.synth = [self.synth init];
      }

      [self.synth stopSpeaking];
      [self.synth setVolume:self.volume];
      [self.synth startSpeakingString:textonly];
    }
  }
}

- (void) dealloc
{
  [self.synth dealloc];
  [super dealloc];
}

@end
