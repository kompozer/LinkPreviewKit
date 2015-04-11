//
//  LKLinkPreviewKit.h
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 11.04.15.
//  Copyright (c) 2015 Andreas Kompanez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LKLinkPreview;

typedef void (^LKLinkPreviewKitHandler)(LKLinkPreview *preview, NSError *error);


@interface LKLinkPreviewKit : NSObject

+ (void)linkPreviewFromURL:(NSURL *)URL completionHandler:(LKLinkPreviewKitHandler)handler;

@end
