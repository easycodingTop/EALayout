//
//  FlowLayout.h
//  EALayout
//
//  Created by easycoding on 15/8/10.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLayouter.h"

@interface FlowLayout : BaseLayouter
{
@public
    LayoutStyle style[1];
    LayoutSizeMode sizeMode;
}

/**
 @brief 控件之间的间距
 */
@property (nonatomic) CGSize spacingSize;

/**
 @brief 固定行高(默认为0), 否则使用当前行最大高度控件的高度作为行高
 */
@property (nonatomic) CGFloat rowHeight;

@end
