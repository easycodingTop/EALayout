//
//  SkinMgr.h
//  EALayout
//
//  Created by easycoding on 15/7/9.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#ifndef __SKINMGR_H__
#define __SKINMGR_H__

#import <Foundation/Foundation.h>

@class UIImage;
@class SkinParser;

@interface SkinMgr : NSObject

@property (nonatomic, copy) NSString* __nonnull extensionPath;
@property (nonatomic, copy) NSString* __nonnull rootPath;

+ (instancetype __nullable)sharedInstance;

- (SkinParser* __nullable)getParserByName:(NSString* __nullable)filename;

- (SkinParser* __nullable)getParserByData:(NSData* __nullable)data;

- (SkinParser* __nullable)getStyleParser;

- (SkinParser* __nullable)getCommonParser;

- (UIImage* __nullable)image:(NSString* __nullable)filename;

@end

#endif //__SKINMGR_H__
