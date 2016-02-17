//
//  LKLinkPreviewHTMLReader.h
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 17/02/16.
//  Copyright © 2016 Andreas Kompanez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LKLinkPreviewReader.h"
@class HTMLDocument;

@interface LKLinkPreviewHTMLReader : NSObject

- (void)linkPreviewFromHTMLDocument:(HTMLDocument *)document completionHandler:(LKLinkPreviewKitHandler)handler;

@end
