//
//  UITextField+SkinParser.h
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
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

/*
 @key[String]:keyboardType
 @value[String]:[Default | ASCIICapable | NumbersAndPunctuation | URL | NumberPad | PhonePad | NamePhonePad | EmailAddress | DecimalPad | Twitter | WebSearch]
 @brief 详见系统 UIKeyboardStyle 枚举
 @example "keyboardType":"default"
 */
DefineParseFun(keyboardType);

/*
 @key[String]:enablesReturnKeyAutomatically
 @value[Bool]:true | false
 @brief 自动修改键盘右下角键可用状态
 @example "enablesReturnKeyAutomatically":true
 */
DefineParseFun(enablesReturnKeyAutomatically);

/*
 @key[String]:placeholder
 @value[String]:placeholder内容
 @brief 设置输入框placeholder内容
 @example "placeholder":"请输入姓名"
 */
DefineParseFun(placeholder);

@end

#endif //__UITEXTFIELD_SKINPARSER_H__
