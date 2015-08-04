//
//  ViewLayoutDes.h
//  EALayout
//
//  Created by easycoding on 15/7/9.
//  Copyright (c) 2015年 www.easycoding.com. All rights reserved.
//

#ifndef __VIEWLAYOUTDES_H__
#define __VIEWLAYOUTDES_H__

#import <Foundation/Foundation.h>

#import "LayoutTypeDef.h"

@class BaseLayouter;

@interface ViewLayoutDes : NSObject

@property (nonatomic, strong) BaseLayouter* __nullable layouter;

-(void)setStyleType:(NSInteger)index type:(LayoutType)type;

-(void)setStyleAlign:(NSInteger)index type:(AlignType)type;

-(void)setLeft:(NSInteger)index value:(CGFloat)value;

-(void)setCenter:(NSInteger)index value:(CGFloat)value;

-(void)setRight:(NSInteger)index value:(CGFloat)value;

-(void)setTop:(NSInteger)index value:(CGFloat)value;

-(void)setMiddle:(NSInteger)index value:(CGFloat)value;

-(void)setBottom:(NSInteger)index value:(CGFloat)value;

-(void)setWidth:(NSInteger)index value:(CGFloat)value;

-(void)setHeight:(NSInteger)index value:(CGFloat)value;

-(void)setStyleType:(LayoutType)type forTag:(NSInteger)tag;

-(void)setStyleAlign:(AlignType)type forTag:(NSInteger)tag;

-(void)setLeft:(CGFloat)value forTag:(NSInteger)tag;

-(void)setCenter:(CGFloat)value forTag:(NSInteger)tag;

-(void)setRight:(CGFloat)value forTag:(NSInteger)tag;

-(void)setTop:(CGFloat)value forTag:(NSInteger)tag;

-(void)setMiddle:(CGFloat)value forTag:(NSInteger)tag;

-(void)setBottom:(CGFloat)value forTag:(NSInteger)tag;

-(void)setWidth:(CGFloat)value forTag:(NSInteger)tag;

-(void)setHeight:(CGFloat)value forTag:(NSInteger)tag;

-(void)setTag:(NSInteger)tag;

-(void)setMaxSize:(CGSize)size;

-(void)setMinSize:(CGSize)size;

-(void)setConstraintMask:(NSInteger)constraintMask;

-(LayoutType)styleType:(NSInteger)index;

-(AlignType)styleAlign:(NSInteger)index;

-(CGFloat)left:(NSInteger)index;

-(CGFloat)center:(NSInteger)index;

-(CGFloat)right:(NSInteger)index;

-(CGFloat)top:(NSInteger)index;

-(CGFloat)middle:(NSInteger)index;

-(CGFloat)bottom:(NSInteger)index;

-(LayoutType)styleTypeByTag:(NSInteger)aTag;

-(AlignType)styleAlignByTag:(NSInteger)aTag;

-(CGFloat)leftByTag:(NSInteger)aTag;

-(CGFloat)centerByTag:(NSInteger)aTag;

-(CGFloat)rightByTag:(NSInteger)aTag;

-(CGFloat)topByTag:(NSInteger)aTag;

-(CGFloat)middleByTag:(NSInteger)aTag;

-(CGFloat)bottomByTag:(NSInteger)aTag;

-(NSInteger)tag;

-(CGSize)maxSize;

-(CGSize)minSize;

-(NSInteger)constraintMask;

@end

#endif //__VIEWLAYOUTDES_H__
