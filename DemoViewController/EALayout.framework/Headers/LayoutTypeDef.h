//
//  LayoutTypeDef.h
//  EALayout
//
//  Created by easycoding on 15/7/9.
//  Copyright (c) 2015年 www.easycoding.com. All rights reserved.
//

#ifndef __LAYOUTTYPEDEF_H__
#define __LAYOUTTYPEDEF_H__

#import <UIKit/UIKit.h>

typedef struct LayoutStyle LayoutStyle;

#define NILV (MAXFLOAT)

typedef enum LayoutType
{
    ELayoutNone,
    ELayoutLeft = 1,
    ELayoutCenter = 1<<1,
    ELayoutRight = 1<<2,
    ELAYOUT_HOR_FLAG = 0x0F,
    
    ELayoutTop = 1<<4,
    ELayoutMiddle = 1<<5,
    ELayoutBottom = 1<<6,
    ELAYOUT_VER_FLAG = ~ELAYOUT_HOR_FLAG,
    
    ELayoutDefault = ELayoutMiddle
} LayoutType;

typedef enum AlignType
{
    EAlignNone,
    EVertical,
    EHorizontal,
    EBothVerAndHor
} AlignType;

typedef enum ConstraintMask
{
    EConstraintNone     = 0,
    EConstraintHeight   = 1 << 0,
    EConstraintWidth    = 1 << 1,
    EConstraintLeft     = 1 << 2,
    EConstraintRight    = 1 << 3,
    EConstraintTop      = 1 << 4,
    EConstraintBottom   = 1 << 5,
    EConstraintCenter   = 1 << 6,
    EConstraintMiddle   = 1 << 7
} ConstraintMask;

typedef enum RefView
{ // value must below 16
    ERefViewNone,
    ERefScreen,
    ERefParent,
    ERefFriend,
    ERefMyself
} RefView;

typedef enum RefOri
{
    ERefOriNone,
    ERefLeft,
    ERefCenter,
    ERefRight,
    ERefTop,
    ERefMiddle,
    ERefBottom,
    ERefWidth,
    ERefHeight
} RefOri;

typedef enum RefOpt
{ // value must below 16
    ERefOptNone,
    ERefAdd,
    ERefSub,
    ERefMul,
    ERefDiv
} RefOpt;

typedef enum RefMutableOri
{
    ERefMutableNone     = 0,
    ERefMutableWidth    = 1,
    ERefMutableHeight   = 1 << 1,
    ERefFixedWidth      = 1 << 5,
    ERefFixedHeight     = 1 << 6
} RefMutableOri;

typedef struct RefRule
{
    RefView refView : 4;
    RefOri  refOri  : 4;
    RefOpt  refOpt  : 4;
} RefRule;

struct LayoutStyle
{
    LayoutType  layoutType;
    AlignType   alignType;
    struct
    {
        RefRule
            leftRef,
            rightRef,
            topRef,
            bottomRef,
            centerRef,
            middleRef,
            widthRef,
            heightRef;
        
        CGFloat left;
        CGFloat top;
        CGFloat right;
        CGFloat bottom;
        CGFloat center;
        CGFloat middle;
        CGFloat width;
        CGFloat height;
    };
    
    UInt8 mutableOri;
    NSInteger asstag;
    BOOL align;
};

#endif //__LAYOUTTYPEDEF_H__
