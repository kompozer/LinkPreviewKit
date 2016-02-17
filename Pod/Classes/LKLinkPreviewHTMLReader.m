//
//  LKLinkPreviewHTMLReader.m
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 17/02/16.
//  Copyright © 2016 Andreas Kompanez. All rights reserved.
//

#import "LKLinkPreviewHTMLReader.h"

#import "LKLinkPreview.h"
#import "LKTypes.h"
#import "LKTemplateLibrary.h"
#import <HTMLReader/HTMLReader.h>

static NSString *const LKHTMLElementMeta = @"meta";
static NSString *const LKHTMLAttributeContent = @"content";
static NSString *const LKHTMLAttributeProperty = @"property";

@interface LKLinkPreview (LKLinkPreviewHTMLReader)

- (BOOL)isEmpty;

@end

@implementation LKLinkPreview (LKLinkPreviewHTMLReader)

- (BOOL)isEmpty
{
    return self.title.length == 0;
}

@end

@interface LKTemplateMatcher : NSObject

- (LKTemplateKind)matchingTemplateByProperty:(NSString *)property;

@end

@implementation LKTemplateMatcher

- (LKTemplateKind)matchingTemplateByProperty:(NSString *)property
{
    if ([property hasPrefix:@"og:"]) {
        return LKTemplateKindOpenGraph;
    }
    if ([property hasPrefix:@"twitter:"]) {
        return LKTemplateKindTwitterCard;
    }
    
    return LKTemplateKindUndefined;
}

@end


@implementation LKLinkPreviewHTMLReader

- (void)linkPreviewFromHTMLDocument:(HTMLDocument *)document completionHandler:(LKLinkPreviewKitHandler)handler
{
    NSArray *metaNodes = [document nodesMatchingSelector:LKHTMLElementMeta];
    LKTemplateLibrary *library = [LKTemplateLibrary new];
    LKTemplateMatcher *matcher = [LKTemplateMatcher new];

    for (id meta in metaNodes) {
        if (! [meta isKindOfClass:[HTMLElement class]]) {
            continue;
        }
        HTMLElement *metaElement = (HTMLElement *)meta;
        NSString *property = [metaElement.attributes objectForKey:LKHTMLAttributeProperty];
        NSString *content = [metaElement.attributes objectForKey:LKHTMLAttributeContent];
        
        LKTemplateKind kind = [matcher matchingTemplateByProperty:property];
        
        if (kind == LKTemplateKindUndefined) {
            continue;
        }
        
        LKLinkPreview *preview = [library fetchOrRegisterNewLinkPreviewByKind:kind];
        [preview setContent:content forProperty:property];
    }
    
    if (handler) {
        handler(library.allPreviews, nil);
    }
}

@end
