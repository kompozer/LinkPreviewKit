//
//  LKLinkPreviewReader.m
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 13.04.15.
//  Copyright (c) 2015 Andreas Kompanez. All rights reserved.
//

#import "LKLinkPreviewReader.h"

#import "LKLinkPreview.h"
#import "LKLinkPreviewHTMLReader.h"
#import <HTMLReader/HTMLReader.h>


NSString *const LKLinkPreviewKitErrorDomain = @"LKLinkPreviewKitErrorDomain";



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
                dispatch_sync(dispatch_get_main_queue(), ^{
                    handler(nil, error);
                });
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
        [htmlReader linkPreviewFromHTMLDocument:document completionHandler:^(NSArray *previews, NSError *error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                handler(previews, error);
            });
        }];
    }] resume];
}

@end


