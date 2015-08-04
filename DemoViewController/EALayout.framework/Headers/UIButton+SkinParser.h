//
//  UIButton+SkinParser.h
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#ifndef __UIBUTTON_SKINPARSER_H__
#define __UIBUTTON_SKINPARSER_H__

#import <Foundation/Foundation.h>
#import "SkinParser.h"

/**
 @brief 建议直接使用  EAButton, 在完整版里会有自定义控件EAButton,比UIButton更好用
 */
@interface UIButton(SkinParser)

/**
 @key[String]:image
 @value[Dictionary/String]:不同状态对应图片
 @brief Dictionary:状态包含["normal", "highlighted", "disabled", "selected"],
        String: 相当于设置 "normal" 状态对应图片
 @example
        Dictionary :
        "image":{
            "normal":"mytestImage/normal.png",
            "selected":"selected.png"
        } 
        String:  "image":"mytestImage/normal.png"
 */
DefineParseFun(image);

/**
 @key[String]:backgroundImage
 @value[Dictionary/String]:不同状态对应背景图片
 @brief Dictionary:状态包含["normal", "highlighted", "disabled", "selected"],
        String: 相当于设置 "normal" 状态对应背景图片
 @example
        Dictionary :
        "backgroundImage":{
            "normal":"mytestImage/normalbackgroundImage.png",
            "selected":"selectedbackgroundImage.png"
        }
        String:  "backgroundImage":"mytestImage/normalbackgroundImage.png"
 */
DefineParseFun(backgroundImage);

/**
 @key[String]:title
 @value[Dictionary/String]:不同状态对应文字
 @brief Dictionary:状态包含["normal", "highlighted", "disabled", "selected"],
        String: 相当于设置 "normal" 状态对应文字
 @example
        Dictionary :
        "title":{
            "normal":"titlenormal",
            "selected":"titlehighlighted"
        }
        String:  "title":"titlenormal"
 */
DefineParseFun(title);

/**
 @key[String]:titleColor
 @value[Dictionary/Color]:不同状态对应文字颜色
 @brief Dictionary:状态包含["normal", "highlighted", "disabled", "selected"],
        String: 相当于设置 "normal" 状态对应文字颜色
 @example
        Dictionary :
        "titleColor":{
            "normal":"blueColor",
            "selected":[255,0,0],
        }
        Color:  "titleColor":[0,0,255,0.5]
 */
DefineParseFun(titleColor);

/**
 @key[String]:titleShadowColor
 @value[Dictionary/Color]:不同状态对应文字阴影颜色
 @brief Dictionary:状态包含["normal", "highlighted", "disabled", "selected"],
 String: 相当于设置 "normal" 状态对应文字阴影颜色
 @example
        Dictionary :
        "titleShadowColor":{
            "normal":"blueColor",
            "selected":[255,0,0],
        }
        Color:  "titleShadowColor":[0,0,255,0.5]
 */
DefineParseFun(titleShadowColor);

/**
 @key[String]:text
 @value[String]: button normal状态对应文字
 @brief title的简写，为了兼容UILabel设置文字的使用习惯
 @example "text":"I am normal title"
 */
-(void)setText:(NSString*)str;

/**
 @key[String]:textColor
 @value[Color]: button normal状态对应文字颜色
 @brief titleColor的简写，为了兼容UILabel设置文字颜色的使用习惯
 @example "titleColor":"#FFFF0000"
 */
-(void)setTextColor:(UIColor*)color;

@end

#endif //__UIBUTTON_SKINPARSER_H__
