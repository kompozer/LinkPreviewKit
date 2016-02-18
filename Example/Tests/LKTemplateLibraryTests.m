//
//  LKTemplateLibraryTests.m
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 18/02/16.
//  Copyright © 2016 Andreas Kompanez. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LKTemplateLibrary.h"

@interface LKTemplateLibraryTests : XCTestCase

@property (nonatomic) LKTemplateLibrary *library;

@end

@implementation LKTemplateLibraryTests

- (void)setUp {
    [super setUp];
    
    self.library = [LKTemplateLibrary new];
}

- (void)testThatRegisteredPreviewsAreSame
{
    LKLinkPreview *p0 = [self.library fetchOrRegisterNewLinkPreviewByKind:LKTemplateKindTwitterCard];
    LKLinkPreview *p1 = [self.library fetchOrRegisterNewLinkPreviewByKind:LKTemplateKindTwitterCard];
    XCTAssertEqual(p0, p1);
}

- (void)testThatResetAndRegisterWorks
{
    XCTAssertTrue(self.library.allPreviews.count == 0);
    [self.library fetchOrRegisterNewLinkPreviewByKind:LKTemplateKindStandard];
    [self.library fetchOrRegisterNewLinkPreviewByKind:LKTemplateKindTwitterCard];
    XCTAssertTrue(self.library.allPreviews.count == 2);
    [self.library resetRegisteredPreviews];
    XCTAssertTrue(self.library.allPreviews.count == 0);
}


@end
