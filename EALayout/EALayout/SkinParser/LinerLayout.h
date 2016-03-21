//
//  LinerLayout.h
//  EALayout
//
//  Created by easycoding on 15/7/9.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#ifndef __LINERLAYOUT_H__
#define __LINERLAYOUT_H__

#import <UIKit/UIKit.h>
#import "BaseLayouter.h"

@interface LinerLayout : BaseLayouter
{
@public
    LayoutStyle style[1];
    LayoutSizeMode sizeMode;
}

@property (nonatomic, assign) CGFloat spacing;

@end

#endif //__LINERLAYOUT_H__
