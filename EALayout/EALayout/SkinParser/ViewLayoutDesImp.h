//
//  ViewLayoutDesImp.h
//  EALayout
//
//  Created by splendourbell on 15/7/18.
//  Copyright (c) 2015年 easylayout. All rights reserved.
//

#ifndef __VIEWLAYOUTDESIMP_H__
#define __VIEWLAYOUTDESIMP_H__

#import <EALayout/EALayout.h>

@interface ViewLayoutDesImp : ViewLayoutDes
{
@public
    LayoutStyle style[2];
    NSInteger tag;
    CGSize maxSize;
    CGSize minSize;
    NSInteger constraintMask;
    BOOL zeroRectWhenHidden;
    NSInteger calcOnlyOneTimeMask;
}

#ifdef __cplusplus
#define calcByOri(__ori) \
+ (CGFloat) calc_##__ori:(LayoutStyle&)__style fetchRect:( CGRect* (^)(RefView) ) fetchViewRect;

calcByOri(left)
calcByOri(top)
calcByOri(right)
calcByOri(bottom)
calcByOri(width)
calcByOri(height)
calcByOri(center)
calcByOri(middle)

#undef calcByOri

#endif

@end

@interface UIView(getViewLayoutDesImp)

- (ViewLayoutDesImp*)getViewLayoutDesImp;

@end

#endif //__VIEWLAYOUTDESIMP_H__
