//
//  LKLinkPreview.m
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 11.04.15.
//  Copyright (c) 2015 Andreas Kompanez. All rights reserved.
//

#import "LKLinkPreview.h"

static NSDateFormatter *pubDateFormatter = nil;

static NSDateFormatter *LKPubDateFormatter() {
    if (! pubDateFormatter) {
        pubDateFormatter = [[NSDateFormatter alloc] init];
        pubDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        // e.g. 2014-02-24T14:45:54Z
        [pubDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    }
    return pubDateFormatter;
}

static NSString *LKTemplateKindPropertyNamespaceString(LKTemplateKind kind) {
    if (kind == LKTemplateKindTwitterCard) {
        return @"twitter:";
    }
    if (kind == LKTemplateKindOpenGraph) {
        return @"og:";
    }
    return @"";
}

static NSString *LKNormalizedProperyName(NSString *property, LKTemplateKind kind) {
    NSString *namespace = LKTemplateKindPropertyNamespaceString(kind);
    if ([property hasPrefix:namespace]) {
        return [property stringByReplacingOccurrencesOfString:namespace withString:@""];
    }
    return namespace;
}

@interface LKLinkPreview ()

@property (nonatomic, readwrite) LKTemplateKind kind;

@end

@implementation LKLinkPreview

- (instancetype)initWithKind:(LKTemplateKind)kind;
{
    self = [super init];
    if (self) {
        self.kind = kind;
    }
    return self;
}

- (void)setContent:(nullable id)content forProperty:(NSString * _Nonnull)property
{
    NSString *normalized = LKNormalizedProperyName(property, self.kind);
    
    if ([normalized isEqualToString:@"title"]) {
        self.title = content;
    }
    else if ([normalized isEqualToString:@"type"]) {
        self.type = content;
    }
    else if ([normalized isEqualToString:@"pubdate"]) {
        NSDateFormatter *formatter = LKPubDateFormatter();
        self.publishedDate = [formatter dateFromString:content];
    }
    else if ([normalized isEqualToString:@"url"]) {
        self.URL = [NSURL URLWithString:content];
    }
    else if ([normalized isEqualToString:@"image"]) {
        self.imageURL = [NSURL URLWithString:content];
    }
    else if ([normalized isEqualToString:@"description"]) {
        self.linkDescription = content;
    }
}

- (NSString *)description
{
    NSMutableString *body = [NSMutableString new];
    [body appendFormat:@"title: '%@'\n", self.title];
    [body appendFormat:@"type: '%@'\n", self.type];
    [body appendFormat:@"URL: '%@'\n", [self.URL absoluteString]];
    [body appendFormat:@"imageURL: '%@'\n", [self.imageURL absoluteString]];
    [body appendFormat:@"linkDescription: '%@'\n", self.linkDescription];
    [body appendFormat:@"publishedDate: '%@'", self.publishedDate];
    
    return [NSString stringWithFormat:@"<%@: %p> %@", [self class], self, body];
}

@end
