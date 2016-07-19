//
//  CacheLayout.m
//  EALayout
//
//  Created by easycoding on 16/7/18.
//  Copyright © 2016年 www.easycoding.top. All rights reserved.
//

#import "CacheLayout.h"
#import "EasyDefine.h"
#import <objc/runtime.h>

/*************************** NSObject(CacheLayout) ***************************/

@implementation NSObject(CacheLayout)

- (void)clearCacheLayout
{
    self.cacheLayout = nil;
}

- (void)clearCacheValue
{
    self.commonDataDict = nil;
}

DefAssObj(CacheLayout*, cacheLayout, setCacheLayout, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

DefAssObj(NSMutableDictionary*, commonDataDict, setCommonDataDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

- (NSMutableDictionary*)commonData
{
    NSMutableDictionary* dataDict = self.commonDataDict;
    if(!dataDict)
    {
        dataDict = [NSMutableDictionary dictionary];
        self.commonDataDict = dataDict;
    }
    return dataDict;
}

- (id)cacheValue:(NSObject<NSCopying>*)key noCache:(id(^)())noCacheBlock
{
    id value = nil;
    if(key)
    {
        NSMutableDictionary* dataDict = self.commonData;
        value = dataDict[key];
        if(!value && noCacheBlock)
        {
            value = noCacheBlock();
            if(value)
            {
                dataDict[key] = value;
            }
        }
    }
    return value;
}

@end


/*************************** UIView(CacheLayout) ***************************/

@implementation UIView(CacheLayout)

DefAssObj(NSObject*, cacheLayoutHost, setCacheLayoutHost, OBJC_ASSOCIATION_ASSIGN)

DefAssObj(NSObject<NSCopying>*, cacheLayoutKey, setCacheLayoutKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

- (void)configCache:(NSObject<NSCopying>*)key host:(NSObject*)lifeCycle
{
    self.cacheLayoutKey = key;
    self.cacheLayoutHost = lifeCycle;
}

- (BOOL)setNeedCacheLayout
{
    NSObject* cacheLayoutHost = self.cacheLayoutHost;
    NSObject<NSCopying>* cacheLayoutKey = self.cacheLayoutKey;
    
    if(cacheLayoutHost && cacheLayoutKey)
    {
        CacheLayout* cacheLayout = cacheLayoutHost.cacheLayout;
        if(!cacheLayout)
        {
            cacheLayout = [[CacheLayout alloc] init];
            cacheLayoutHost.cacheLayout = cacheLayout;
        }
        return [cacheLayout cache:cacheLayoutKey view:self];
    }
    return NO;
}

- (BOOL)applyCacheLayout
{
    NSObject* cacheLayoutHost = self.cacheLayoutHost;
    NSObject<NSCopying>* cacheLayoutKey = self.cacheLayoutKey;
    
    if(cacheLayoutHost && cacheLayoutKey)
    {
        CacheLayout* cacheLayout = cacheLayoutHost.cacheLayout;
        return [cacheLayout apply:cacheLayoutKey view:self];
    }
    return NO;
}

@end

/***************************** CacheLayoutItem ******************************/

@interface CacheLayoutItem : NSObject

@property (nonatomic) CGRect frame;
@property (nonatomic) NSMutableArray<CacheLayoutItem*>* subItems;

- (void)cache:(UIView*)view;

@end

@implementation CacheLayoutItem

- (void)cache:(UIView*)view
{
    self.frame = view.frame;
    NSArray<UIView*>* subviews = view.subviews;
    NSInteger count = subviews.count;
    if(count > 0)
    {
        _subItems = [NSMutableArray<CacheLayoutItem*> arrayWithCapacity:count];
        for(NSInteger i=0; i < count; ++i)
        {
            CacheLayoutItem* item = [[CacheLayoutItem alloc] init];
            [item cache:subviews[i]];
            [_subItems addObject:item];
        }
    }
}

- (BOOL)applyTo:(UIView*)view
{
    if(!CGRectEqualToRect(view.frame, self.frame))
    {
        view.frame = self.frame;
    }
    NSArray<UIView*>* subviews = view.subviews;
    NSInteger count = subviews.count;
    if(count == _subItems.count)
    {
        BOOL success = YES;
        for(NSInteger i=0; (i < count) && success ; ++i)
        {
            success &= [_subItems[i] applyTo:subviews[i]];
        }
        return success;
    }
    return NO;
}

@end

/***************************** CacheLayout ******************************/

@interface CacheLayout()

@property (nonatomic) NSMutableDictionary<NSObject<NSCopying>*, CacheLayoutItem*>* cacheLayoutItems;

@end

@implementation CacheLayout

- (BOOL)cache:(NSObject<NSCopying>*)cacheLayoutKey view:(UIView*)view
{
    if(cacheLayoutKey)
    {
        CacheLayoutItem* item = self.cacheLayoutItems[cacheLayoutKey];
        if(!item)
        {
            item = [[CacheLayoutItem alloc] init];
            self.cacheLayoutItems[cacheLayoutKey] = item;
        }
        [item cache:view];
        return YES;
    }
    return NO;
}

- (BOOL)apply:(NSObject<NSCopying>*)cacheLayoutKey view:(UIView*)view
{
    if(cacheLayoutKey)
    {
        CacheLayoutItem* item = self.cacheLayoutItems[cacheLayoutKey];
        return [item applyTo:view];
    }
    return NO;
}

- (NSMutableDictionary<NSObject<NSCopying>*, CacheLayoutItem*>*)cacheLayoutItems
{
    if(!_cacheLayoutItems)
    {
        _cacheLayoutItems = [NSMutableDictionary<NSObject<NSCopying>*, CacheLayoutItem*> dictionary];
    }
    return _cacheLayoutItems;
}

@end
