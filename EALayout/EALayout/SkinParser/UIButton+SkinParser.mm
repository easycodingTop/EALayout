//
//  UIButton+SkinParser.mm
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import "UIButton+SkinParser.h"
#import "UIControl+SkinParser.h"

@interface UIControl()
- (UIControlState)valueOfUIControlState:(NSString*)stateStr;
@end

@implementation UIButton(SkinParser)

#define DefineUIControlStateFun(_key, _setFun, _parseFun)\
\
DefineParseFun(_key)\
{\
    if ( isNSString(value) )\
    {\
        [self _setFun:_parseFun(value) forState:UIControlStateNormal];\
    }\
    else if (isNSDictionary(value))\
    {\
        NSDictionary* dict = (NSDictionary*)value;\
        for( NSString* key in dict)\
        {\
            UIControlState state = [self valueOfUIControlState:key];\
            [self _setFun:_parseFun(dict[key]) forState:state];\
        }\
    }\
}

NSString* toLocalString(NSString* str)
{
    return [SkinParser ToLocalString:str];
}

DefineUIControlStateFun(image, setImage, toImage)

DefineUIControlStateFun(backgroundImage, setBackgroundImage, toImage)

DefineUIControlStateFun(title, setTitle, toLocalString)

DefineUIControlStateFun(titleColor, setTitleColor, toColor)

DefineUIControlStateFun(titleShadowColor, setTitleShadowColor, toColor)

- (void)setText:(NSString*)str
{
    [self setTitle: [SkinParser ToLocalString:str] forState:(UIControlStateNormal)];
}

- (void)setTextColor:(UIColor*)color
{
    [self setTitleColor:color forState:(UIControlStateNormal)];
}

@end
