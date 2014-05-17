//
//  NSStringHyperlinkTests.m
//  NSStringHyperlinkTests
//
//  Created by 亮 加藤 on 12/06/19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSStringHyperlinkTests.h"
#import "NSString+Hyperlink.h"

@implementation NSStringHyperlinkTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}



- (void)testFind
{
    NSString *str = @"hogehoge http://hoge.com/, aaa http://example.com/hoge?v=q aaaaa";
    NSArray *array = [str hyperlinks];
    STAssertTrue([array count] == 2, [NSString stringWithFormat:@"should be 2, but found %d", [array count]]);
    STAssertTrue([[array objectAtIndex:0] isEqualToString:@"http://hoge.com/"], @"should be hoge.com");
    STAssertTrue([[array objectAtIndex:1] isEqualToString:@"http://example.com/hoge?v=q"], @"should be example.com");
    
    NSString *str2 = @"hogehttp://hoge.com/http://example.com";
    NSArray *array2 = [str2 hyperlinks];
    STAssertTrue([array2 count] == 1, [NSString stringWithFormat:@"should be 1, but found %d", [array2 count]]);
    STAssertTrue([[array2 objectAtIndex:0] isEqualToString:@"http://example.com"], @"should be hoge.com");
    
    NSString *str3 = @"hogehttp://example.com";
    NSArray *array3 = [str3 hyperlinks];
    STAssertTrue([array3 count] == 0, [NSString stringWithFormat:@"should be 0, but found %d", [array3 count]]);
    
    NSString *str4 = @"Lyo Kato (http://d.hatena.ne.jp/lyokato)";
    NSArray *array4 = [str4 hyperlinks];
    STAssertTrue([array4 count] == 1, [NSString stringWithFormat:@"should be 1, but found %d", [array4 count]]);
    STAssertTrue([[array4 objectAtIndex:0] isEqualToString:@"http://d.hatena.ne.jp/lyokato"], @"should be hoge.com");
}

- (void)testSplitWithTrimming
{
    NSString *str = @"hogehoge http://hoge.com/, aaa http://example.com/hoge?v=q aaaaa";
    //NSArray *array = [str hyperlinks];
    NSArray *components = [str componentsSplittedByHyperlink];
    STAssertTrue([components count] == 5, @"components count");
    STAssertTrue(((NSStringExtractedComponent*)[components objectAtIndex:0]).type == NSStringExtractedComponentTypeNormal, @"1st component type");
    STAssertTrue([((NSStringExtractedComponent*)[components objectAtIndex:0]).string isEqualToString:@"hogehoge"], @"1st component string");
    
    STAssertTrue(((NSStringExtractedComponent*)[components objectAtIndex:1]).type == NSStringExtractedComponentTypeHyperlink, @"2nd component type");
    STAssertTrue([((NSStringExtractedComponent*)[components objectAtIndex:1]).string isEqualToString:@"http://hoge.com/"], @"2nd component string");
    STAssertTrue([((NSStringExtractedComponent*)[components objectAtIndex:2]).string isEqualToString:@", aaa"], @"3rd component string");
    
    STAssertTrue([((NSStringExtractedComponent*)[components objectAtIndex:3]).string isEqualToString:@"http://example.com/hoge?v=q"], @"4th component string");
    
    STAssertTrue([((NSStringExtractedComponent*)[components objectAtIndex:4]).string isEqualToString:@"aaaaa"], @"5th component string");
    
  
}

- (void)testSplitWithoutTrimming
{
    NSString *str = @"hogehoge http://hoge.com/, aaa http://example.com/hoge?v=q aaaaa";
    //NSArray *array = [str hyperlinks];
    NSArray *components = [str componentsSplittedByHyperlinkWithTrimming:NO];
    STAssertTrue([components count] == 5, @"components count");
    STAssertTrue(((NSStringExtractedComponent*)[components objectAtIndex:0]).type == NSStringExtractedComponentTypeNormal, @"1st component type");
    STAssertTrue([((NSStringExtractedComponent*)[components objectAtIndex:0]).string isEqualToString:@"hogehoge "], @"1st component string");
    
    STAssertTrue(((NSStringExtractedComponent*)[components objectAtIndex:1]).type == NSStringExtractedComponentTypeHyperlink, @"2nd component type");
    STAssertTrue([((NSStringExtractedComponent*)[components objectAtIndex:1]).string isEqualToString:@"http://hoge.com/"], @"2nd component string");
}
@end
