/*
The MIT License

Copyright (c) 2012 lyo.kato@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

#import "NSString+Hyperlink.h"

@implementation NSString (Hyperlink)

- (NSString *)decruftForHyperlink
{
    static NSRegularExpression *regexp = nil;

    if (!regexp) {
        regexp = 
            [[NSRegularExpression alloc] initWithPattern:@"[\\Q\\]\\)\\,\\.\\'\\\"\\E]+$"
                                                 options:0
                                                   error:nil];
    }

    NSString *replaced =
        [regexp stringByReplacingMatchesInString:self
                                         options:0
                                           range:NSMakeRange(0, self.length)
                                    withTemplate:@""];
    return replaced;
}

- (NSArray *)componentsSplittedByHyperlink 
{
    return [self componentsSplittedByHyperlinkWithTrimming:YES];
}

- (NSArray *)componentsSplittedByHyperlinkWithTrimming:(BOOL)withTrimming
{

    NSArray *urls = [self hyperlinks]; 

    NSMutableArray *results = [NSMutableArray array];

    NSString *string = [NSString stringWithFormat:@"%@", self];
    NSString *found;
    NSRange range;
    
    for (NSString *urlString in urls) {
        range = [string rangeOfString:urlString];
        if (range.location != 0) {
            found = [string substringToIndex: range.location];
            if (withTrimming && [found length] > 0) {
                found = [found stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
            if ([found length] > 0) {
                [results addObject:[NSStringExtractedComponent componentWithType:NSStringExtractedComponentTypeNormal
                                                                          string:found]];
            }
        }
        [results addObject:[NSStringExtractedComponent componentWithType:NSStringExtractedComponentTypeHyperlink
                                                                  string:urlString]];

        string = [string substringFromIndex:range.location + range.length];
    }

    if ([string length] > 0) {
        if (withTrimming) {
            string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        if ([string length] > 0) {
            [results addObject:[NSStringExtractedComponent componentWithType:NSStringExtractedComponentTypeNormal
                                                                      string:string]];
        }
    }
    return results;
}

- (NSArray *)hyperlinks
{
    static NSRegularExpression *regexp = nil;

    if (!regexp) {
        regexp =
            [[NSRegularExpression alloc] initWithPattern:@"(?:https?|shttp)://(?:(?:[-_.!~*'()a-zA-Z0-9;:&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*@)?(?:(?:[a-zA-Z0-9](?:[-a-zA-Z0-9]*[a-zA-Z0-9])?\\.)*[a-zA-Z](?:[-a-zA-Z0-9]*[a-zA-Z0-9])?\\.?|[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+)(?::[0-9]*)?(?:/(?:[-_.!~*'()a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*(?:;(?:[-_.!~*'()a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)*(?:/(?:[-_.!~*'()a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*(?:;(?:[-_.!~*'()a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)*)*)?(?:\\?(?:[-_.!~*'()a-zA-Z0-9;/?:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)?(?:#(?:[-_.!~*'()a-zA-Z0-9;/?:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)?"
                                                      options:0
                                                        error:nil];
    }
    
    NSString *string = [NSString stringWithFormat:@"%@", self];

    NSArray *matches = [regexp matchesInString:string
                                       options:0
                                        range:NSMakeRange(0, string.length)];
    
    NSMutableArray *uris = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        NSString *uriString = [string substringWithRange:[match rangeAtIndex:0]];
        [uris addObject:[uriString decruftForHyperlink]];
    }
    return uris;
}


@end
