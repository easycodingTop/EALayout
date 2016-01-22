//
//  CALayer+SkinParser.mm
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import "CALayer+SkinParser.h"

@implementation CALayer(SkinParser)

#define DEF_DefineParseFun(x) \
DefineParseFun(x)\
{\
    self.x = toColor(value).CGColor;\
}

DEF_DefineParseFun(borderColor);

DEF_DefineParseFun(backgroundColor);

DEF_DefineParseFun(shadowColor);

DefineParseFun(shadowOffset)
{
    self.shadowOffset = toSize(value);
}

@end
