//
//  UIImageView+SkinParser.h
//  EALayout
//
//  Created by Peak.Liu on 16/6/26.
//  Copyright © 2016年 www.easycoding.top. All rights reserved.
//

#import "SkinParser.h"

@interface UIImageView (SkinParser)
/*
 @key[String]:animationImages
 @value[String]: [1.png, 2.png, 3.png]
 @brief 详见系统 animationImages 
 @example "animationImages":["1.png","2.png","3.png"]
 */
DefineParseFun(animationImages);


/*
 @key[String]:highlightedAnimationImages
 @value[String]: [1.png, 2.png, 3.png]
 @brief 详见系统 animationImages 
 @example "animationImages":["1.png","2.png","3.png"]
 */
DefineParseFun(highlightedAnimationImages);

DefineParseFun(animationDuration);

DefineParseFun(animationRepeatCount);


@end
