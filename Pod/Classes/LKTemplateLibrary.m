//
//  LKTemplateLibrary.m
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 17/02/16.
//  Copyright © 2016 Andreas Kompanez. All rights reserved.
//

#import "LKTemplateLibrary.h"

@interface LKTemplateLibrary ()

/// Registered @c LKLinkPreview values by the @c LKTemplateKind as the key
@property (nonatomic, readwrite) NSMutableDictionary *registeredPreviews;

@end

@implementation LKTemplateLibrary

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.registeredPreviews = [NSMutableDictionary new];
    }
    return self;
}

- (NSArray *)allPreviews
{
    return self.registeredPreviews.allValues;
}

- (void)resetRegisteredPreviews
{
    self.registeredPreviews = [NSMutableDictionary new];
}

- (LKLinkPreview *)fetchOrRegisterNewLinkPreviewByKind:(LKTemplateKind)kind
{
    NSNumber *key = @(kind);
    LKLinkPreview *preview = [self.registeredPreviews objectForKey:key];
    if (! preview) {
        preview = [[LKLinkPreview alloc] initWithKind:kind];
        [self.registeredPreviews setObject:preview forKey:key];
    }
    return preview;
}

@end
