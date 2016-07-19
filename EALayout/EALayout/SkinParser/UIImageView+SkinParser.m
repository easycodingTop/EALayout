//
//  UIImageView+SkinParser.m
//  EALayout
//
//  Created by Peak.Liu on 16/6/26.
//  Copyright © 2016年 www.easycoding.top. All rights reserved.
//

#import "UIImageView+SkinParser.h"

@implementation UIImageView (SkinParser)



#define DefineAnimationImagesFun(_key, _setFun)\
\
DefineParseFun(_key)\
{\
    NSMutableArray <UIImage *> *imageArr = [NSMutableArray array];\
    for(NSString* imageStr in (NSArray*)value)\
    {\
        UIImage *image = toImage(imageStr);\
        if (image) \
        {\
            [imageArr addObject:image];\
        }\
    }\
    if ( imageArr.count ) \
    { \
        [self _setFun:imageArr]; \
    } \
}

DefineAnimationImagesFun(animationImages, setAnimationImages)

DefineAnimationImagesFun(highlightedAnimationImages, setHighlightedAnimationImages)

DefineParseFun(animationDuration)
{
    [self setAnimationDuration:[(NSNumber *)value doubleValue]];
}

DefineParseFun(animationRepeatCount)
{
    [self setAnimationRepeatCount:[(NSNumber *)value integerValue]];
}

#undef DefineAnimationImagesFun 
@end
