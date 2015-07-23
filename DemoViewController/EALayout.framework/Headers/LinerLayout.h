//
//  LinerLayout.h
//
//  Created by easycoding on 15-7-9.
//  Copyright (c) 2015年 www.easycoding.com. All rights reserved.
//

#ifndef __LinerLayout_h__
#define __LinerLayout_h__

#import <UIKit/UIKit.h>
#import "BaseLayouter.h"


typedef enum {
    ESizeFixed,
    ESizeFillWidth = 1,
    ESizeFillHeight = 2,
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

#endif //__LinerLayout_h__


