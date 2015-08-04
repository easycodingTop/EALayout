//
//  NSObject+SkinParser.h
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#ifndef __NSOBJECT_SKINPARSER_H__
#define __NSOBJECT_SKINPARSER_H__

#import <Foundation/Foundation.h>
#import "SkinParser.h"

@interface NSObject(SkinParser)

/**
 @key[String]:   class
 @value[String]: className
 @brief 需要创建对象的类名, 如果该类使用Swift编写，需要使用 @objc(类)来自动生成Objective-C头文件
 @example {"class":"UIView"}
 */
DefineParseFun(class);

/**
 @key[String]:  extend
 @value[Bool]:  true / false
 @brief 在解析控件   -(UIView*)parse:(NSString*)viewname view:(UIView*)view;
        读取属性    -(id)valueWithName:(NSString*)name key:(NSString*)key;
        extend为true, 则优先解析 common.json里,再解析自身结点, 当自身结点不存在时，直接解析common.json
 @example {"extend":true}
 */
DefineParseFun(extend);

/**
 @key[String]:  linkStyle
 @value[String]:styleName
 @brief 该属性会从  style.json 里读取对应 styleName 样式的属性
 @example {"linkStyle":"greenStyle"}
 */
DefineParseFun(linkStyle);

/**
 @key[String]:      other
 @value[Dictionary]:自定字典类型 key-value
 @brief 解析控件时,不会解析该结点,在单独读取属性使用
 @example
        { "test": {
                "class":"UIView",
                "other":{
                    "mykey1":aJsonObject
                }
            }
        }
        解析"test"控件时，会忽略"other".
        在使用 [parser valueWithName:@"test" key:@"mykey1"] 可读取 aJsonObject对象;
 */
DefineParseFun(other);

/**
 @key[String]:   textAlignment
 @value[String]: [left|center|right], default:left [String]
 @brief 通常为 UILabel文字对齐方式
 @example { "textAlignment":"center" }
 */
DefineParseFun(textAlignment);

@end

#endif //__NSOBJECT_SKINPARSER_H__
