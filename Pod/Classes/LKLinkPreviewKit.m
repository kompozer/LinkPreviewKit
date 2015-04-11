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


NSString *const LKLinkPreviewKitErrorDomain = @"LKLinkPreviewKitErrorDomain";


static NSString *const LKHTMLElementMeta = @"";
static NSString *const LKHTMLAttributeContent = @"content";
static NSString *const LKHTMLAttributeProperty = @"property";



@implementation LKLinkPreviewKit

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
        
        LKLinkPreviewKit *previewKit = [LKLinkPreviewKit new];
        [previewKit linkPreviewFromHTMLDocument:document completionHandler:handler];
    }] resume];
}

#pragma mark - Private

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
}

@end
