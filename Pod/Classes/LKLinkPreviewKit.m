//
//  LKLinkPreviewKit.m
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 11.04.15.
//  Copyright (c) 2015 Andreas Kompanez. All rights reserved.
//

#import "LKLinkPreviewKit.h"

#import "LKLinkPreview.h"
#import <HTMLReader/HTMLReader.h>


@implementation LKLinkPreviewKit

+ (void)linkPreviewFromURL:(NSURL *)URL completionHandler:(LKLinkPreviewKitHandler)handler
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = 404;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            statusCode = [(NSHTTPURLResponse *)response statusCode];
        }
        NSLog(@"%s status code %ld", __PRETTY_FUNCTION__, (long)statusCode);
        if (error) {
            if (handler) {
                handler(nil, error);
            }
            return;
        }
        
        NSString *contentType = nil;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
            contentType = headers[@"Content-Type"];
        }
        HTMLDocument *document = [HTMLDocument documentWithData:data
                                          contentTypeHeader:contentType];

        LKLinkPreview *preview = [LKLinkPreview new];
        NSArray *metaNodes = [document nodesMatchingSelector:@"meta"];
        for (id meta in metaNodes) {
            if (! [meta isKindOfClass:[HTMLElement class]]) {
                continue;
            }
            HTMLElement *metaElement = (HTMLElement *)meta;
            NSString *property = [metaElement.attributes objectForKey:@"property"];
            NSString *content = [metaElement.attributes objectForKey:@"content"];
            if ([property isEqualToString:@"og:title"]) {
                preview.title = content;
            }
            else if ([property isEqualToString:@"og:type"]) {
                preview.type = content;
            }
            else if ([property isEqualToString:@"og:url"]) {
                preview.URL = [NSURL URLWithString:content];
            }
            else if ([property isEqualToString:@"og:image"]) {
                preview.imageURL = [NSURL URLWithString:content];
            }
            else if ([property isEqualToString:@"og:description"]) {
                preview.linkDescription = content;
            }
        }
        if (handler) {
            handler(preview, nil);
        }
    }] resume];
}

@end
