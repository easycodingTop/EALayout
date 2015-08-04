//
//  CALayer+SkinParser.h
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#ifndef __CALAYER_SKINPARSER_H__
#define __CALAYER_SKINPARSER_H__

#import "SkinParser.h"

@interface CALayer(SkinParser)

/**
 @key[String]:borderColor
 @value[Color]:颜色对象
 @brief 设置Layer borderColor。
        注:因为默认以Color字符器结尾的属性会自动解析为UIColor,
           但此处属性类型为  CGColor, 所以需要特别为其写解析方法
 @example "layer.borderColor":"0xFFFF0000"
        此处通常为 "layer.borderColor",
        因为解析通常是相对于View解析，所以需要先取layer再设置layer的属性
 */
DefineParseFun(borderColor);

/**
 @key[String]:backgroundColor
 @value[Color]:颜色对象
 @brief 设置Layer backgroundColor。
        注:因为默认以Color字符器结尾的属性会自动解析为UIColor,
        但此处属性类型为  CGColor, 所以需要特别为其写解析方法
 
 @example "layer.backgroundColor":"0xFFFF0000"
        此处通常为 "layer.backgroundColor",
        因为解析通常是相对于View解析，所以需要先取layer再设置layer的属性
 */
DefineParseFun(backgroundColor);

/**
 @key[String]:shadowColor
 @value[Color]:颜色对象
 @brief 设置Layer shadowColor。
        注:因为默认以Color字符器结尾的属性会自动解析为UIColor,
        但此处属性类型为  CGColor, 所以需要特别为其写解析方法
 @example "layer.shadowColor":"0xFFFF0000"
        此处通常为 "layer.shadowColor",
        因为解析通常是相对于View解析，所以需要先取layer再设置layer的属性
 */
DefineParseFun(shadowColor);

@end

#endif //__CALAYER_SKINPARSER_H__
