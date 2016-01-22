//
//  LinerLayout.h
//  EALayout
//
//  Created by easycoding on 15/7/9.
//  Copyright (c) 2015年 www.easycoding.com. All rights reserved.
//

#ifndef __LINERLAYOUT_H__
#define __LINERLAYOUT_H__

#import <UIKit/UIKit.h>
#import "BaseLayouter.h"

typedef enum LayoutSizeMode
{
    ESizeFixed      = 0,
    ESizeFillWidth  = 1 << 0,
    ESizeFillHeight = 1 << 1,
    ESizeFillBoth = ESizeFillWidth | ESizeFillHeight
} LayoutSizeMode;

@interface LinerLayout : BaseLayouter
{
@public
    LayoutStyle style[1];
    LayoutSizeMode sizeMode;
}

@property (nonatomic, assign) CGFloat spacing;

@end

#endif //__LINERLAYOUT_H__
