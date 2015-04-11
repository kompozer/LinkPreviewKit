//
//  LKLinkPreview.m
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 11.04.15.
//  Copyright (c) 2015 Andreas Kompanez. All rights reserved.
//

#import "LKLinkPreview.h"

@implementation LKLinkPreview

- (NSString *)description
{
    NSMutableString *body = [NSMutableString new];
    [body appendFormat:@"title: '%@'\n", self.title];
    [body appendFormat:@"type: '%@'\n", self.type];
    [body appendFormat:@"URL: '%@'\n", [self.URL absoluteString]];
    [body appendFormat:@"imageURL: '%@'\n", [self.imageURL absoluteString]];
    [body appendFormat:@"linkDescription: '%@'\n", self.linkDescription];
    
    return [NSString stringWithFormat:@"<%@: %p> %@", [self class], self, body];
}

@end
