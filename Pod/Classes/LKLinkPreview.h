//
//  LKLinkPreview.h
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 11.04.15.
//  Copyright (c) 2015 Andreas Kompanez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKLinkPreview : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic) NSURL *URL;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic, copy) NSString *linkDescription;

@end
