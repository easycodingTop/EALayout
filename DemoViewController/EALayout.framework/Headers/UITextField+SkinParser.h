//
//  UITextField+SkinParser.h
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#ifndef __UITEXTFIELD_SKINPARSER_H__
#define __UITEXTFIELD_SKINPARSER_H__

#import "SkinParser.h"

@interface UITextField(SkinParser)

/*
 @key[String]:borderStyle
 @value[String]:[none | line | bezel | roundedRect]
 @brief 详见系统 UITextBorderStyle 枚举
 @example "borderStyle":"bezel"
 */
DefineParseFun(borderStyle);

@end

#endif //__UITEXTFIELD_SKINPARSER_H__
