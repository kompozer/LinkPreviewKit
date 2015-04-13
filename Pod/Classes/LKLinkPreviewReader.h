//
//  LKLinkPreviewReader.h
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 13.04.15.
//  Copyright (c) 2015 Andreas Kompanez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LKLinkPreviewKitErrors.h"

@class LKLinkPreview;



typedef void (^LKLinkPreviewKitHandler)(LKLinkPreview *preview, NSError *error);

@interface LKLinkPreviewReader : NSObject

+ (void)linkPreviewFromURL:(NSURL *)URL completionHandler:(LKLinkPreviewKitHandler)handler;

@end
