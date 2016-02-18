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
#import "LKLinkPreview.h"

static NSArray *testFiles = nil;
static NSString *const extension = @"html";


@interface LKLinkPreviewReaderTests : XCTestCase

@end

@implementation LKLinkPreviewReaderTests

- (void)setUp
{
    [super setUp];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        testFiles = [NSArray arrayWithObjects:@"t0", @"t1", nil];
    });
}

- (void)testThatReaderFindAnyPreviews
{
    LKLinkPreviewHTMLReader *htmlReader = [LKLinkPreviewHTMLReader new];
    for (NSString *file in testFiles) {
        HTMLDocument *document = [self loadTestHTMLDocumentWithName:file extension:extension];
        XCTAssertNotNil(document);
        [htmlReader linkPreviewFromHTMLDocument:document completionHandler:^(NSArray *previews, NSError *error) {
            XCTAssertTrue(previews.count >= 1);
        }];
    }
}

- (void)testThatReaderFindOpenGraphPreviews
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"OpenGraph previews found"];
    __block NSUInteger count = 0;
    
    LKLinkPreviewHTMLReader *htmlReader = [LKLinkPreviewHTMLReader new];
    for (NSString *file in testFiles) {
        HTMLDocument *document = [self loadTestHTMLDocumentWithName:file extension:extension];
        XCTAssertNotNil(document);
        [htmlReader linkPreviewFromHTMLDocument:document completionHandler:^(NSArray *previews, NSError *error) {
            for (LKLinkPreview *preview in previews) {
                if (preview.kind == LKTemplateKindOpenGraph) {
                    count += 1;
                    if (count == testFiles.count) {
                        [expectation fulfill];
                    }
                }
            }
        }];
    }
    
    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Couldnt find all OpenGraph previews");
        }
    }];

}

#pragma mark Helpers

- (HTMLDocument *)loadTestHTMLDocumentWithName:(NSString *)name extension:(NSString *)extension
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:name ofType:extension];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    HTMLDocument *document = [HTMLDocument documentWithString:html];
    
    return document;
}

@end
