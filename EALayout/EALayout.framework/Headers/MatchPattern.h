//
//  MatchPattern.h
//  EALayout
//
//  Created by easycoding on 15/7/15.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#ifndef __MATCHPATTERN_H__
#define __MATCHPATTERN_H__

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SkinParser;
typedef id (*ParseFunction)(id value, SkinParser* parser);

/**
 @param subfix    匹配属性名后缀,不区分大小写
 @param cls       指定匹配的类,  cls为nil, 则添加通用匹配规则
 @param fun       匹配成功时使用的解析方法
 @brief 当解析某对象属性时, 优先查找当前对象类型匹配规则，如果未查找到，则使用通用匹配规则
 */
bool AddMatchPattern(NSString* subfix, Class cls, ParseFunction fun);

/**
 @param subfix    匹配属性名后缀,不区分大小写
 @param cls       指定匹配的类, cls为nil， 则移出通用匹配规则
 @brief 移出cls所对应subfix属性解析方法
 */
bool RemoveMatchPattern(NSString* subfix, Class cls);

/**
 @param subfix    匹配属性名后缀,不区分大小写
 @param cls       指定匹配的类, cls为nil， 则匹配通用匹配规则
 @retval 未找到则返回NULL
 @brief 查找cls所对应subfix属性解析方法,如果未找到，则查找通用规则
 */
ParseFunction GetMatchPatternFunciton(NSString* subfix, Class cls);

#endif //__MATCHPATTERN_H__
