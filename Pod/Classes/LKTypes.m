//
//  LKTypes.h
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 18/02/16.
//  Copyright © 2016 Andreas Kompanez. All rights reserved.
//

#import "LKTypes.h"

NSString *StringFromLKTemplateKind(LKTemplateKind kind)
{
    if (kind == LKTemplateKindStandard) {
        return @"Standard";
    }
    if (kind == LKTemplateKindTwitterCard) {
        return @"TwitterCard";
    }
    if (kind == LKTemplateKindOpenGraph) {
        return @"OpenGraph";
    }
    return @"Undefined";
}
