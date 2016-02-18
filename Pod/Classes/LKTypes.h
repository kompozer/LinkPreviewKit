//
//  LKTypes.h
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 17/02/16.
//  Copyright © 2016 Andreas Kompanez. All rights reserved.
//

typedef NS_ENUM(NSInteger, LKTemplateKind) {
    LKTemplateKindUndefined,
    LKTemplateKindStandard, // <title> and meta description
    LKTemplateKindTwitterCard,
    LKTemplateKindOpenGraph
};

extern NSString *StringFromLKTemplateKind(LKTemplateKind kind);
