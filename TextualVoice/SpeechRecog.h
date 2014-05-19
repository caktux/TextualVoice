//
//  SpeechRecog.h
//  TextualVoice
//
//  Created by caktux on 2014-05-17.
//  Copyright (c) 2014 caktux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeechRecog : NSObject < NSSpeechRecognizerDelegate > {
  NSSpeechRecognizer* recog;
}

- (id)init;
////- (IBAction)listen:(id)sender;
-(void) startListening;
-(void) stopListening;
- (void)speechRecognizer:(NSSpeechRecognizer *)sender didRecognizeCommand:(id)aCmd;
////- (void)awakeFromNib;
- (void)dealloc;

@end
