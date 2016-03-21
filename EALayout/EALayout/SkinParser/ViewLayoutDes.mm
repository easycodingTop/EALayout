//
//  ViewLayoutDes.mm
//  EALayout
//
//  Created by easycoding on 15/7/9.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import "ViewLayoutDes.h"

@implementation ViewLayoutDes

- (void)setStyleType:(NSInteger)index type:(LayoutType)type
{

}


- (void)setStyleAlign:(NSInteger)index type:(AlignType)type
{

}

#define SetConstraint(__ori, __orikey)\
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


#define SETV(__ori)\
for(NSInteger index=0; index<2; ++index)\
{\
    if( tag == style[index].asstag )\
    {\
        [self set##__ori:index value:value];\
        break;\
    }\
}

#define SetValueByIndex(__ori, __orikey)\
- (void)set##__ori:(NSInteger)index value:(CGFloat)value\
{\
}

#define SetValueByTag(__ori, __oriKey)\
- (void)set##__ori:(CGFloat)value forTag:(NSInteger)asstag\
{\
}

#define SetPairValue(__ori, __orikey)\
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

#define SETV(__x)\
for(NSInteger index=0; index<2; ++index)\
{\
    if( tag == style[index].asstag )\
    {\
        (__x);\
        break;\
    }\
}

- (void)setStyleType:(LayoutType)type forTag:(NSInteger)asstag
{
    
}

- (void)setStyleAlign:(AlignType)type forTag:(NSInteger)asstag
{
    
}

#undef SETV

- (void)setTag:(NSInteger)aTag
{
    
}

- (void)setMaxSize:(CGSize)size
{
    
}

- (void)setMinSize:(CGSize)size
{
    
}

- (void)setConstraintMask:(NSInteger)mask
{
    
}

- (LayoutType)styleType:(NSInteger)index
{
    return ELayoutNone;
}

- (AlignType)styleAlign:(NSInteger)index
{
    return EAlignNone;
}

- (CGFloat)left:(NSInteger)index
{
    return 0;
}

- (CGFloat)center:(NSInteger)index
{
    return 0;
}

- (CGFloat)right:(NSInteger)index
{
    return 0;
}

- (CGFloat)top:(NSInteger)index
{
    return 0;
}

- (CGFloat)middle:(NSInteger)index
{
    return 0;
}

- (CGFloat)bottom:(NSInteger)index
{
    return 0;
}

- (CGFloat)width:(NSInteger)index
{
    return 0;
}

- (CGFloat)height:(NSInteger)index
{
    return 0;
}

- (LayoutType)styleTypeByTag:(NSInteger)aTag
{
    return ELayoutNone;
}

- (AlignType)styleAlignByTag:(NSInteger)aTag
{
    return EAlignNone;
}

- (CGFloat)leftByTag:(NSInteger)aTag
{
    return NILV;
}

- (CGFloat)centerByTag:(NSInteger)aTag
{
    return NILV;
}

- (CGFloat)rightByTag:(NSInteger)aTag
{
    return NILV;
}

- (CGFloat)topByTag:(NSInteger)aTag
{
    return NILV;
}

- (CGFloat)middleByTag:(NSInteger)aTag
{
    return NILV;
}

- (CGFloat)bottomByTag:(NSInteger)aTag
{
    return NILV;
}

- (CGFloat)widthByTag:(NSInteger)aTag
{
    return NILV;
}

- (CGFloat)heightByTag:(NSInteger)aTag
{
    return NILV;
}

- (NSInteger)tag
{
    return 0;
}

- (CGSize)maxSize
{
    return CGSizeZero;
}

- (CGSize)minSize
{
    return CGSizeZero;
}

- (NSInteger)constraintMask
{
    return 0;
}

@end
