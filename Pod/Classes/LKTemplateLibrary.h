//
//  LKTemplateLibrary.h
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 17/02/16.
//  Copyright © 2016 Andreas Kompanez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LKLinkPreview.h"

@interface LKTemplateLibrary : NSObject

/// Returns all the registered @c LKLinkPreview objects
@property (nonatomic, readonly) NSArray * _Nonnull allPreviews;

- (LKLinkPreview * _Nullable)fetchOrRegisterNewLinkPreviewByKind:(LKTemplateKind)kind;

- (void)resetRegisteredPreviews;

@end
