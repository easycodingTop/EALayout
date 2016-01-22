//
//  LinerLayout+SkinParser.h
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#ifndef __LINERLAYOUT_SKINPARSER_H__
#define __LINERLAYOUT_SKINPARSER_H__

#import "UIView+SkinParser.h"

@interface LinerLayout(SkinParser)

/**
 @key[String]:subviewsLayout
 @value[Dictionary]:layout描述，LinerLayout仅支持一个Layout. 
 @brief 对该LinerLayout子view进行布局. Layout规则具体见Layout规范文档
 @example  "subviewsLayout":{"s":"c"}
 */
DefineParseFun(subviewsLayout);

/**
 @key[String]:sizeMode
 @value[String]: 子view 宽高适配策略,[w | h | w,h ]
 @brief 对该LinerLayout子view进行布局时，宽高适配. Layout规则具体见Layout规范文档
 @example "sizeMode":"w,h"
 */
DefineParseFun(sizeMode);

@end

#endif //__LINERLAYOUT_SKINPARSER_H__
