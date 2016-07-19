//
//  CacheLayout.h
//  EALayout
//
//  Created by easycoding on 16/7/18.
//  Copyright © 2016年 www.easycoding.top. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSObject(CacheLayout)

//清空lifeCycle上绑定的缓存
- (void)clearCacheLayout;

- (void)clearCacheValue;

- (id)cacheValue:(NSObject<NSCopying>*)key noCache:(id(^)())noCacheBlock;

@end

@interface UIView(CacheLayout)

/**
 @param key  此key 映射cell的布局，如果key一样，布局就完全一样
 @param lifeCycle 缓存布局对象的依附对象，即生命周期与lifeCycle一样，或者调用[lifeCycle clearCacheLayout]主动清除缓存布局
*/
- (void)configCache:(NSObject<NSCopying>*)key host:(NSObject*)lifeCycle;

- (BOOL)setNeedCacheLayout;

- (BOOL)applyCacheLayout;

@end

@interface CacheLayout : NSObject

- (BOOL)cache:(NSObject<NSCopying>*)cacheLayoutKey view:(UIView*)view;

- (BOOL)apply:(NSObject<NSCopying>*)cacheLayoutKey view:(UIView*)view;

@end
