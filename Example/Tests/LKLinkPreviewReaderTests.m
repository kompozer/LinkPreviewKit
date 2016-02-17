//
//  LKLinkPreviewReaderTests.m
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 17/02/16.
//  Copyright © 2016 Andreas Kompanez. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <HTMLReader/HTMLReader.h>
#import "LKLinkPreviewHTMLReader.h"

@interface LKLinkPreviewReaderTests : XCTestCase

@property (nonatomic, copy) NSString *testHTML;

@end

@implementation LKLinkPreviewReaderTests

- (void)setUp {
    [super setUp];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"input" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    XCTAssertNotNil(html);
    self.testHTML = html;
}

- (void)tearDown {
    [super tearDown];
    
    self.testHTML = nil;
}

- (void)testThatTestHTMLLoadsAndIsParseable {
    HTMLDocument *document = [HTMLDocument documentWithString:self.testHTML];
    XCTAssertNotNil(document);
    XCTAssertNotNil(document.rootElement);
}

- (void)testThatReaderFindPreviews {
    HTMLDocument *document = [HTMLDocument documentWithString:self.testHTML];
    LKLinkPreviewHTMLReader *htmlReader = [LKLinkPreviewHTMLReader new];
    [htmlReader linkPreviewFromHTMLDocument:document completionHandler:^(NSArray *previews, NSError *error) {
        XCTAssertTrue(previews.count == 1);
    }];
}

@end
