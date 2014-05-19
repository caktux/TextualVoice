//
//  SpeechRecog.m
//  TextualVoice
//
//  Created by caktux on 2014-05-17.
//  Copyright (c) 2014 caktux. All rights reserved.
//

#import "SpeechRecog.h"

@implementation SpeechRecog

- (id)init {
  self = [super init];
  if (self) {
    NSArray *cmds = [NSArray arrayWithObjects:@"Zero", @"Sing", nil];
    recog = [[NSSpeechRecognizer alloc] init]; // recog is an ivar
    [recog setCommands:cmds];
    [recog setDelegate:[SpeechRecog alloc]];
    [recog setListensInForegroundOnly:YES];
    [recog setBlocksOtherRecognizers:NO];
    [recog startListening];
//    [recog stopListening];
  }
  return self;
}

- (void)speechRecognizer:(NSSpeechRecognizer *)sender didRecognizeCommand:(id)aCmd {
  NSBeep();
  NSLog(@"%@", aCmd);

//  [recog stopListening];
//  [recog startListening];

//  if ([(NSString *)aCmd isEqualToString:@"Sing"]) {
//    NSLog(@"%@", aCmd);
////    NSAlert *alert = [[NSAlert alloc] init];
////    NSSound *snd = [[NSSound alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HappyBirthday" ofType:@"aif"] byReference:NO];
////    [snd play];
////    [snd release];
//    return;
//  }
//
//  if ([(NSString *)aCmd isEqualToString:@"Zero"]) {
//    NSLog(@"%@", aCmd);
//    // .... some response here...
//    return;
//  }
  
}

-(void) startListening
{
  NSLog(@"startListening");
  [recog startListening];
//  [recog setBlocksOtherRecognizers:NO];
}

-(void) stopListening
{
  NSLog(@"stopListening");
//  [recog setBlocksOtherRecognizers:NO];
  [recog stopListening];
}

//- (void)awakeFromNib {
//  [recog startListening];
//}

- (void)dealloc {
  [recog dealloc];
  [super dealloc];
}

@end
