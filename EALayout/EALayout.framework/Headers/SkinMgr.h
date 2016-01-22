//
//  SkinMgr.h
//  EALayout
//
//  Created by easycoding on 15/7/9.
//  Copyright (c) 2015年 www.easycoding.com. All rights reserved.
//

#ifndef __SKINMGR_H__
#define __SKINMGR_H__

#import <Foundation/Foundation.h>

@class SkinParser;

@interface SkinMgr : NSObject

/* 
 @brief 布局文件所在目录
    默认值:[NSBundle mainBundle].resourcePath
 */
@property (nonatomic, strong) NSString* skinPath;

+(instancetype)sharedInstance;

-(SkinParser*)getParserByName:(NSString*)filename;

-(SkinParser*)getParserByData:(NSData *)data;

@end

#endif //__SKINMGR_H__
