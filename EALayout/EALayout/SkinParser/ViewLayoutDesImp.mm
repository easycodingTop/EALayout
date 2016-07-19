//
//  ViewLayoutDesImp.mm
//  EALayout
//
//  Created by easycoding on 15/7/18.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import "ViewLayoutDesImp.h"

@implementation UIView(getViewLayoutDesImp)

- (ViewLayoutDesImp*)getViewLayoutDesImp
{
    return (ViewLayoutDesImp*)[self getViewLayoutDes];
}
@end

@implementation ViewLayoutDesImp

- (id)init
{
    if(self = [super init])
    {
        maxSize.height = MAXFLOAT;
        maxSize.width = MAXFLOAT;
        minSize.width = 0;
        minSize.height = 0;
        constraintMask = EConstraintNone;
        zeroRectWhenHidden = YES;
        
        for(NSInteger i=0; i < 2; ++i)
        {
            style[i].left = NILV;
            style[i].right = NILV;
            style[i].top = NILV;
            style[i].bottom = NILV;
            style[i].center = NILV;
            style[i].middle = NILV;
            style[i].width = NILV;
            style[i].height = NILV;
            style[i].layoutType = ELayoutNone;
            style[i].alignType = EAlignNone;
        }
    }
    return self;
}

- (void)setStyleType:(NSInteger)index type:(LayoutType)type
{
    style[index].layoutType = type;
}

- (void)setStyleAlign:(NSInteger)index type:(AlignType)type
{
    style[index].alignType = type;
}

#define SetConstraint(__ori, __orikey) \
do\
{\
    BOOL isNil = YES;\
    for(NSInteger i = 0; i< (sizeof(style) / sizeof(style[0])); ++i)\
    {\
        if(style[i].__orikey < NILV)\
        {\
            isNil = NO;\
            break;\
        }\
    }\
    if(isNil)\
    {\
        constraintMask &= ~EConstraint##__ori;\
    }\
    else\
    {\
        constraintMask |= EConstraint##__ori;\
    }\
}while(0)


#define SETV(__ori) \
for(NSInteger index=0; index<2; ++index)\
{\
    if( asstag == style[index].asstag )\
    {\
        [self set##__ori:index value:value];\
        break;\
    }\
}

#define SetValueByIndex(__ori, __orikey) \
- (void)set##__ori:(NSInteger)index value:(CGFloat)value\
{\
    style[index].__orikey = value;\
    SetConstraint(__ori, __orikey);\
}

#define SetValueByTag(__ori, __oriKey) \
- (void)set##__ori:(CGFloat)value forTag:(NSInteger)asstag\
{\
    SETV(__ori);\
}

#define SetPairValue(__ori, __orikey) \
SetValueByIndex(__ori, __orikey)\
SetValueByTag(__ori, __orikey)

SetPairValue(Left, left)
SetPairValue(Center, center)
SetPairValue(Right, right)
SetPairValue(Top, top)
SetPairValue(Middle, middle)
SetPairValue(Bottom, bottom)
SetPairValue(Width, width)
SetPairValue(Height, height)

#undef SETV

#define SETV(__x) \
for(NSInteger index=0; index<2; ++index)\
{\
    if( tag == style[index].asstag ) {\
        (__x);\
        break;\
    }\
}

- (void)setStyleType:(LayoutType)type forTag:(NSInteger)asstag
{
    SETV(style[index].layoutType = type)
}

- (void)setStyleAlign:(AlignType)type forTag:(NSInteger)asstag
{
    SETV(style[index].alignType = type)
}

#undef SETV

- (void)setTag:(NSInteger)aTag
{
    self->tag = aTag;
}

- (void)setMaxSize:(CGSize)size
{
    maxSize = size;
}

- (void)setMinSize:(CGSize)size
{
    minSize = size;
}

- (void)setConstraintMask:(NSInteger)mask
{
    constraintMask = mask;
}

- (LayoutType)styleType:(NSInteger)index
{
    return style[index].layoutType;
}

- (AlignType)styleAlign:(NSInteger)index
{
    return style[index].alignType;
}

- (CGFloat)left:(NSInteger)index
{
    return style[index].left;
}

- (CGFloat)center:(NSInteger)index
{
    return style[index].center;
}

- (CGFloat)right:(NSInteger)index
{
    return style[index].right;
}

- (CGFloat)top:(NSInteger)index
{
    return style[index].top;
}

- (CGFloat)middle:(NSInteger)index
{
    return style[index].middle;
}

- (CGFloat)bottom:(NSInteger)index
{
    return style[index].bottom;
}

- (CGFloat)width:(NSInteger)index
{
    return style[index].width;
}

- (CGFloat)height:(NSInteger)index
{
    return style[index].height;
}

- (LayoutType)styleTypeByTag:(NSInteger)aTag
{
    for(NSInteger index=0; index<2; ++index)
    {
        if( aTag == style[index].asstag )
        {
            return style[index].layoutType;
        }
    }
    return ELayoutNone;
}

- (AlignType)styleAlignByTag:(NSInteger)aTag
{
    for(NSInteger index=0; index<2; ++index)
    {
        if( aTag == style[index].asstag )
        {
            return style[index].alignType;
        }
    }
    return EAlignNone;
}

- (CGFloat)leftByTag:(NSInteger)aTag
{
    for(NSInteger index=0; index<2; ++index)
    {
        if( aTag == style[index].asstag )
        {
            return style[index].left;
        }
    }
    return NILV;
}

- (CGFloat)centerByTag:(NSInteger)aTag
{
    for(NSInteger index=0; index<2; ++index)
    {
        if( aTag == style[index].asstag )
        {
            return style[index].center;
        }
    }
    return NILV;
}

- (CGFloat)rightByTag:(NSInteger)aTag
{
    for(NSInteger index=0; index<2; ++index)
    {
        if( aTag == style[index].asstag )
        {
            return style[index].right;
        }
    }
    return NILV;
}

- (CGFloat)topByTag:(NSInteger)aTag
{
    for(NSInteger index=0; index<2; ++index)
    {
        if( aTag == style[index].asstag )
        {
            return style[index].top;
        }
    }
    return NILV;
}

- (CGFloat)middleByTag:(NSInteger)aTag
{
    for(NSInteger index=0; index<2; ++index)
    {
        if( aTag == style[index].asstag )
        {
            return style[index].middle;
        }
    }
    return NILV;
}

- (CGFloat)bottomByTag:(NSInteger)aTag
{
    for(NSInteger index=0; index<2; ++index)
    {
        if( aTag == style[index].asstag )
        {
            return style[index].bottom;
        }
    }
    return NILV;
}

- (CGFloat)widthByTag:(NSInteger)aTag
{
    for(NSInteger index=0; index<2; ++index)
    {
        if( aTag == style[index].asstag )
        {
            return style[index].width;
        }
    }
    return NILV;
}

- (CGFloat)heightByTag:(NSInteger)aTag
{
    for(NSInteger index=0; index<2; ++index)
    {
        if( aTag == style[index].asstag )
        {
            return style[index].height;
        }
    }
    return NILV;
}

- (NSInteger)tag
{
    return self->tag;
}

- (CGSize)maxSize
{
    return self->maxSize;
}

- (CGSize)minSize
{
    return self->minSize;
}

- (NSInteger)constraintMask
{
    return self->constraintMask;
}

CGRect S_rect;

#define calcByOpt(__ori) \
switch ( __style.__ori##Ref.refOpt )\
{\
    case ERefAdd:\
    {\
        result = theV + __style.__ori;\
    }\
    break;\
\
    case ERefSub:\
    {\
        result = theV - __style.__ori;\
    }\
    break;\
\
    case ERefMul:\
    {\
        result = theV * __style.__ori;\
    }\
    break;\
\
    case ERefDiv:\
    {\
        result = theV / __style.__ori;\
    }\
    break;\
\
    default:\
    {\
        result = theV;\
    }\
    break;\
}

#define assValue(__ori, __rect) \
({\
    CGFloat __ret = 0;\
    switch(__ori)\
    {\
        case ERefLeft:      __ret = CGRectGetMinX(*__rect);break;\
        case ERefRight:     __ret = CGRectGetMaxX(*__rect);break;\
        case ERefTop:       __ret = CGRectGetMinY(*__rect);break;\
        case ERefBottom:    __ret = CGRectGetMaxY(*__rect);break;\
        case ERefWidth:     __ret = CGRectGetWidth(*__rect);break;\
        case ERefHeight:    __ret = CGRectGetHeight(*__rect);break;\
        case ERefCenter:    __ret = CGRectGetWidth(*__rect)/2 + CGRectGetMinX(*__rect);break;\
        case ERefMiddle:    __ret = CGRectGetHeight(*__rect)/2 + CGRectGetMinY(*__rect);break;\
        default: break;\
    }\
    (__ret);\
})

#define calcByOri(__ori) \
+ (CGFloat) calc_##__ori:(LayoutStyle&)__style fetchRect:( CGRect* (^)(RefView) ) fetchViewRect\
{\
    CGFloat result = NILV;\
    switch (__style.__ori##Ref.refView)\
    {\
        case ERefScreen:\
        {\
            CGRect* rect = &S_rect;\
            CGFloat theV = assValue(__style.__ori##Ref.refOri, rect);\
            calcByOpt(__ori);\
        }\
        break;\
\
        case ERefParent:\
        case ERefFriend:\
        case ERefMyself:\
        {\
            CGRect* rect = fetchViewRect((RefView)__style.__ori##Ref.refView);\
            if(rect) {\
                CGFloat theV = assValue(__style.__ori##Ref.refOri, rect);\
                calcByOpt(__ori);\
            }\
        }\
        break;\
\
        default:\
        {\
            CGFloat theV = __style.__ori;\
            result = theV;\
        }\
        break;\
    }\
    return result;\
}

calcByOri(left)
calcByOri(top)
calcByOri(right)
calcByOri(bottom)
calcByOri(width)
calcByOri(height)

+ (CGFloat) calc_center:(LayoutStyle&)__style fetchRect:( CGRect* (^)(RefView) ) fetchViewRect
{
    return __style.center;
}

+ (CGFloat) calc_middle:(LayoutStyle&)__style fetchRect:( CGRect* (^)(RefView) ) fetchViewRect
{
    return __style.middle;
}

@end
