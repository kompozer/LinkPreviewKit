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
static NSString *const LKHTMLElementTitle = @"title";
static NSString *const LKHTMLAttributeContent = @"content";
static NSString *const LKHTMLAttributeProperty = @"property";
static NSString *const LKHTMLAttributeName = @"name";

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

- (LKTemplateKind)matchingTemplateByKey:(NSString *)property;

@end

@implementation LKTemplateMatcher

- (LKTemplateKind)matchingTemplateByKey:(NSString *)property
{
    if ([property hasPrefix:@"og:"]) {
        return LKTemplateKindOpenGraph;
    }
    if ([property hasPrefix:@"twitter:"]) {
        return LKTemplateKindTwitterCard;
    }
    if ([property isEqualToString:@"description"]) {
        return LKTemplateKindStandard;
    }
    
    return LKTemplateKindUndefined;
}

@end

@interface LKMetaKeyValuePair : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;

@end

@implementation LKMetaKeyValuePair

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> key '%@'; value '%@'", [self class], self, self.key, self.value];
}

@end

@interface LKLKMetaKeyValuePairParser : NSObject

- (LKMetaKeyValuePair * _Nonnull)parse:(HTMLElement *)element;

@end

@implementation LKLKMetaKeyValuePairParser

- (LKMetaKeyValuePair *)parse:(HTMLElement *)element
{
    NSString *property = [element.attributes objectForKey:LKHTMLAttributeProperty];
    NSString *name = [element.attributes objectForKey:LKHTMLAttributeName];
    NSString *content = [element.attributes objectForKey:LKHTMLAttributeContent];
    NSString *key = nil;
    
    if (property.length > 0 && name.length == 0) {
        key = property;
    }
    else {
        key = name;
    }
    LKMetaKeyValuePair *pair = [LKMetaKeyValuePair new];
    pair.key = key;
    pair.value = content;
    
    return pair;
}

@end


@implementation LKLinkPreviewHTMLReader

- (void)linkPreviewFromHTMLDocument:(HTMLDocument *)document completionHandler:(LKLinkPreviewKitHandler)handler
{
    NSArray *metaNodes = [document nodesMatchingSelector:LKHTMLElementMeta];
    LKTemplateLibrary *library = [LKTemplateLibrary new];
    LKTemplateMatcher *matcher = [LKTemplateMatcher new];
    LKLKMetaKeyValuePairParser *keyValueParser = [LKLKMetaKeyValuePairParser new];

    for (id meta in metaNodes) {
        if (! [meta isKindOfClass:[HTMLElement class]]) {
            continue;
        }
        HTMLElement *metaElement = (HTMLElement *)meta;
        LKMetaKeyValuePair *keyValuePair = [keyValueParser parse:metaElement];
        LKTemplateKind kind = [matcher matchingTemplateByKey:keyValuePair.key];
        
        if (kind == LKTemplateKindUndefined) {
            continue;
        }
        
        LKLinkPreview *preview = [library fetchOrRegisterNewLinkPreviewByKind:kind];
        [preview setContent:keyValuePair.value forProperty:keyValuePair.key];
    }
    
    // Check for Standard Template
    LKLinkPreview *standardTemplatePreview = [library fetchOrRegisterNewLinkPreviewByKind:LKTemplateKindStandard];
    if (standardTemplatePreview) {
        HTMLElement *titleElement = [document nodesMatchingSelector:LKHTMLElementTitle].firstObject;
        standardTemplatePreview.title = titleElement.textContent;
    }
    
    if (handler) {
        handler(library.allPreviews, nil);
    }
}

@end
