//
//  FlowLayout+SkinParser.h
//  EALayout
//
//  Created by easylayout on 15/8/15.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+SkinParser.h"

@interface FlowLayout(SkinParser)

/**
 @key[String]:subviewsLayout
 @value[Dictionary]:layout描述，FlowLayout仅支持一个Layout.
 @brief 对该FlowLayout子view进行布局. Layout规则具体见Layout规范文档
 @example  "subviewsLayout":{"s":"c"}
 */
DefineParseFun(subviewsLayout);

/**
 @key[String]:sizeMode
 @value[String]: 子view 宽高适配策略,[w | h | w,h ]
 @brief 对该FlowLayout子view进行布局时，宽高适配. Layout规则具体见Layout规范文档
 @example "sizeMode":"w,h"
 */
DefineParseFun(sizeMode);

@end
