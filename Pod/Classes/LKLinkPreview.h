//
//  LKLinkPreview.h
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 11.04.15.
//  Copyright (c) 2015 Andreas Kompanez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LKTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface LKLinkPreview : NSObject

@property (nonatomic, readonly) LKTemplateKind kind;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable siteName;
@property (nonatomic) NSURL * _Nullable URL;
@property (nonatomic) NSURL * _Nullable imageURL;
@property (nonatomic, copy) NSString * _Nullable linkDescription;
@property (nonatomic) NSDate * _Nullable publishedDate;

- (instancetype)initWithKind:(LKTemplateKind)kind NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)setContent:(nullable id)value forProperty:(NSString * _Nonnull)key;

@end

NS_ASSUME_NONNULL_END
