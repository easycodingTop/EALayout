//
//  SkinParser.h
//  EALayout
//
//  Created by easycoding on 15/7/9.
//  Copyright (c) 2015年 www.easycoding.com. All rights reserved.
//

#ifndef __SKNPARSER_H__
#define __SKNPARSER_H__

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Layout.h"
#import "SkinKeysDef.h"
#import "SkinMgr.h"
#import "LinerLayout.h"
#import "ViewLayoutDes.h"

#define isNSArray(x) ( [(x) isKindOfClass:[NSArray class]] )
#define isNSDictionary(x) ( [(x) isKindOfClass:[NSDictionary class]] )
#define isNSString(x) ( [(x) isKindOfClass:[NSString class]] )
#define isNSNumber(x) ( [(x) isKindOfClass:[NSNumber class]] )

#define DefineParseFun(_property) \
-(void)_property:(id)value parser:(SkinParser*)parser

@interface SkinParser : NSObject

/**
 @brief 设置当前事件target, 如解析 button addTarget时
 */
@property (nonatomic,weak) id eventTarget;

@property (nonatomic, assign) BOOL isRootParser;

+(instancetype)getParserByData:(NSData*)data;

+(instancetype)getParserByName:(NSString*)filename;

-(instancetype)init:(NSDictionary*)dict;

/**
 @param key, 对应view的key
 @param view, 需要解析属性的view, 如果为nil, 则创建.  并返回该view
 @retval 返回传入的view,或者创建的view
 @details 1:如果该结点key存在，并且 "extend":true,则会先解析common属性，再解析当前解析属性。
          2:如果该结点key不存在，则直接解析common属性
 */
-(UIView*)parse:(NSString*)key view:(UIView* )view;

/**
 @brief 当于调用[parser parse:key view:nil]
 */
-(UIView*)parse:(NSString*)key;

/**
 @brief 通过字典解析view
 */
-(UIView*)parse:(UIView*)view attr:(NSDictionary*)dict;

/**
 @brief 获取key结点下对应name的图片
 */
-(UIImage*)imageWithName:(NSString*)name key:(NSString*)key;

/**
 @brief 通过文件相对路径获取图片
 */
-(UIImage*)imageWithPath:(NSString*)path;

/**
 @brief 获取key结点下对应name的颜色
 */
-(UIColor*)colorWithName:(NSString*)name key:(NSString*)key;

/**
 @brief 获取key结点下对应name的结点
 */
-(id)valueWithName:(NSString*)name key:(NSString*)key;

/**
 @brief 字符串解析为UIColor对象 "#aarrggbb" "0xaarrggbb" "blackColor"(UIColor方法)
 */
+(UIColor*)StringToColor:(NSString*)string;

@end

/*=================== C parse function ====================*/
/*
 [width, height] ==> CGSize
 */
CGSize toSize(NSArray* array);

/*
 "a string" ==> NSString
 */
NSString* toString(id value);

/*
 "#FFFFFFFF"    ==> UIColor
 "0xFFFFFFFF"   ==> UIColor
 [r,g,b,a]      ==> UIColor
 [r,g,b]        ==> UIColor
 "blackColor"   ==> UIColor.blackColor
 */
UIColor* toColor(id value);

/*
 "imagename.png"    ==> UIImage
 */
UIImage* toImage(id value);

/*
 [x, y, width, height] ==> CGRect
 */
CGRect toRect(NSArray* array);

/*
 15     ==> [UIFont systemFontOfSize:15]
 {"size":15, "name":"bold"} ==> [UIFont boldSystemFontOfSize:15]
 */
UIFont* toFont(id value);

/*
 {
    "class":"UIView",     ==>  UIView
    "xxx":"xxx"
 }
 */
UIView* toView(id value, SkinParser* parser);

/*
 "never"    ==>  UITextFieldViewMode
 */
UITextFieldViewMode toViewMode(id value, SkinParser* parser);

#pragma mark ParseFunctions

id MakeColorValue(id value, SkinParser* parser);

id MakeRectValue(id value, SkinParser* parser);

id MakeImageValue(id value, SkinParser* parser);

id MakeSizeValue(id value, SkinParser* parser);

id MakeInsetValue(id value, SkinParser* parser);

id MakeFontValue(id value, SkinParser* parser);

id MakeViewValue(id value, SkinParser* parser);

id MakeViewModeValue(id value, SkinParser* parser);

/**
 * 框架默认已添加部分通用解析方法,如有需要，可自行添加需要的方法
 */

/*
 * 所有后缀为 color 的属性会自动匹配 MakeColorValue解析方法，设置对应UIColor
 *
 * AddMatchPattern(@"color",   nil, MakeColorValue);   //UIColor
 */

/*
 * 所有后缀为 image 的属性会自动匹配 MakeImageValue解析方法，设置对应UIImage
 *
 * AddMatchPattern(@"image",   nil, MakeImageValue);   //UIImage
 */

/*  以下 与上 同理 */
//AddMatchPattern(@"font",    nil, MakeFontValue);    //UIFont
//AddMatchPattern(@"frame",   nil, MakeRectValue);    //CGRect
//AddMatchPattern(@"size",    nil, MakeSizeValue);    //CGSize
//AddMatchPattern(@"Insets",  nil, MakeInsetValue);   //UIEdgeInsets
//AddMatchPattern(@"Inset",   nil, MakeInsetValue);   //UIEdgeInsets
//AddMatchPattern(@"View",    nil, MakeViewValue);    //UIView
//AddMatchPattern(@"ViewMode",nil, MakeViewModeValue);//UITextFieldViewMode

#endif //__SKNPARSER_H__
