//
//  LKLinkPreviewReader.m
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 13.04.15.
//  Copyright (c) 2015 Andreas Kompanez. All rights reserved.
//

#import "LKLinkPreviewReader.h"

#import "LKLinkPreview.h"
#import <HTMLReader/HTMLReader.h>


NSString *const LKLinkPreviewKitErrorDomain = @"LKLinkPreviewKitErrorDomain";


static NSString *const LKHTMLElementMeta = @"meta";
static NSString *const LKHTMLAttributeContent = @"content";
static NSString *const LKHTMLAttributeProperty = @"property";

@interface LKLinkPreviewHTMLReader : NSObject

- (void)linkPreviewFromHTMLDocument:(HTMLDocument *)document completionHandler:(LKLinkPreviewKitHandler)handler;

@end

@implementation LKLinkPreviewHTMLReader

- (void)linkPreviewFromHTMLDocument:(HTMLDocument *)document completionHandler:(LKLinkPreviewKitHandler)handler
{
    LKLinkPreview *preview = [LKLinkPreview new];
    NSArray *metaNodes = [document nodesMatchingSelector:LKHTMLElementMeta];
    for (id meta in metaNodes) {
        if (! [meta isKindOfClass:[HTMLElement class]]) {
            continue;
        }
        HTMLElement *metaElement = (HTMLElement *)meta;
        NSString *property = [metaElement.attributes objectForKey:LKHTMLAttributeProperty];
        NSString *content = [metaElement.attributes objectForKey:LKHTMLAttributeContent];
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
        dispatch_sync(dispatch_get_main_queue(), ^{
            handler(preview, nil);
        });
    }
}

@end


@implementation LKLinkPreviewReader

+ (void)linkPreviewFromURL:(NSURL *)URL completionHandler:(LKLinkPreviewKitHandler)handler
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = 404;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            statusCode = [(NSHTTPURLResponse *)response statusCode];
        }
        if (error || statusCode != 200) {
            if (statusCode != 200 && error == nil) {
                error = [NSError errorWithDomain:LKLinkPreviewKitErrorDomain code:LKLinkPreviewKitErrorBadURL userInfo:nil];
            }
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
        LKLinkPreviewHTMLReader *htmlReader = [LKLinkPreviewHTMLReader new];
        [htmlReader linkPreviewFromHTMLDocument:document completionHandler:handler];
    }] resume];
}

@end


