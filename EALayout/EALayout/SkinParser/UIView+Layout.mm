//
//  UIView+Layout.mm
//  EALayout
//
//  Created by easycoding on 15/7/9.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import <map>
#import <objc/runtime.h>

#import "UIView+Layout.h"
#import "BaseLayouter.h"
#import "ViewLayoutDesImp.h"

#define EnAZ(__v) do{if((__v) < 0){ __v = 0;}}while(0)

#define EAssSuperView 0

@implementation UIView(UIView_Layout)

static char UIViewLayouteDescripterKey;

- (void)setViewLayoutDes:(ViewLayoutDes*)viewLayoutDes
{
    objc_setAssociatedObject(self, &UIViewLayouteDescripterKey, viewLayoutDes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ViewLayoutDes*)getViewLayoutDes
{
    return (ViewLayoutDes*)objc_getAssociatedObject(self,&UIViewLayouteDescripterKey);
}

- (BaseLayouter*)getLayouter
{
    BaseLayouter* layouter = [self getViewLayoutDes].layouter;
    if(!layouter)
    {
        for (BaseLayouter* view in self.subviews)
        {
            if ([view isKindOfClass:[BaseLayouter class]])
            {
                return view;
            }
        }
    }
    return layouter;
}

- (ViewLayoutDes*)createViewLayoutDesIfNil
{
    ViewLayoutDes* des = [self getViewLayoutDes];
    if(!des)
    {
        des = [[ViewLayoutDesImp alloc] init];
        [self setViewLayoutDes:des];
    }
    return des;
}

@end

#define TheV(__ori) \
CGFloat TheV_##__ori = [ViewLayoutDesImp calc_##__ori:subLayoutDes->style[styleIndex] fetchRect:^CGRect *(RefView refView)\
{\
    switch (refView)\
    {\
        case ERefParent:\
            return pSelfRect;\
            break;\
        case ERefFriend:\
            return pAssRect;\
            break;\
        case ERefMyself:\
            return pMyselfRect;\
            break;\
        default:\
            break;\
    }\
    return NULL;\
}];


#define CheckWidth(__width__, __minSize__, __maxSize__) \
do\
{\
    if(__width__ > __maxSize__.width && __maxSize__.width > 0)\
        {__width__ = __maxSize__.width;}\
    else if(__width__ < __minSize__.width)\
        {__width__ = __minSize__.width;}\
}while(0)

#define CheckHeight(__height__, __minSize__, __maxSize__) \
do\
{\
    if(__height__ > __maxSize__.height && __maxSize__.height > 0)\
        {__height__ = __maxSize__.height;}\
    else if(__height__ < __minSize__.height)\
        {__height__ = __minSize__.height;}\
}while(0)

#define CheckRect(__rect__, __minSize__, __maxSize__) \
do\
{\
    CheckWidth(__rect__.size.width,__minSize__,__maxSize__);\
    CheckHeight(__rect__.size.height,__minSize__,__maxSize__);\
}while(0)

@implementation UIView(SPAutoLayout)

- (NSArray*)getWillLayoutSubviews
{
    return self.subviews;
}

- (UIView*)getWillLayoutSuperview
{
    return self;
}

- (void)spUpdateLayout
{
    [self spUpdateLayout:INT_MAX];
}

- (void)spUpdateLayout:(NSInteger)level
{
    NSMutableArray* subviews = [self.getWillLayoutSubviews mutableCopy];
    NSUInteger count = subviews.count;
    if(!count)
    {
        return;
    }
    
    UIView* curView = nil;
    CGRect selfRect = self.bounds;
    selfRect.origin = CGPointZero;
        
    CGRect* pSelfRect = &selfRect;
    
    CGRect inRect;
    __block std::map<NSInteger,UIView*> assMap;
    
    BaseLayouter* layouter = [self getLayouter];
    if(layouter)
    {
        [subviews insertObject:layouter atIndex:layouter.indexOfSubview];
        count++;
    }
    
    for(int i=0; i<count; ++i)
    {
        curView = subviews[i];
        if([curView isKindOfClass:NSClassFromString(@"UIRoundedRectButton")])
        {
            continue;
        }
        
        if(i > layouter.indexOfSubview)
        {
            [layouter willLayoutView:curView];
        }
        
        ViewLayoutDesImp* subLayoutDes = [curView getViewLayoutDesImp];
        
        if(subLayoutDes)
        {
            CGSize minSize = subLayoutDes->minSize;
            CGSize maxSize = subLayoutDes->maxSize;
            
            if(subLayoutDes->tag>0)
            {
                assMap[subLayoutDes->tag] = curView;
            }
            
            NSInteger constraintMask = subLayoutDes->constraintMask;
            CGRect rect = curView.frame;
            CGRect* pMyselfRect = &rect;
            for(int styleIndex=0; styleIndex<2; styleIndex++)
            {
                UIView* assView = assMap[subLayoutDes->style[styleIndex].asstag];
                CGRect assRect = assView.frame;
                CGRect* pAssRect = &assRect;
                
                TheV(width);
                if(TheV_width < NILV)
                {
                    CheckWidth(TheV_width, minSize, maxSize);
                    rect.size.width = TheV_width;
                    constraintMask |= EConstraintWidth;
                }
                
                TheV(height);
                if(TheV_height < NILV)
                {
                    CheckHeight(TheV_height, minSize, maxSize);
                    rect.size.height = TheV_height;
                    constraintMask |= EConstraintHeight;
                }
                
                if([curView isKindOfClass:[UILabel class]])
                {
                    if( (!(constraintMask & EConstraintHeight)) )
                    {
                        CGFloat fixWidth = NILV;
                        if( ((constraintMask & EConstraintWidth) && ((UILabel*)curView).numberOfLines ==1) )
                        {
                            fixWidth = rect.size.width;
                        }
                        CheckRect(rect, minSize, maxSize);
                        curView.frame = rect;
                        [curView sizeToFit];
                        rect = curView.frame;
                        
                        if(fixWidth < NILV)
                        {
                            rect.size.width = fixWidth;
                        }
                    } else if( !(constraintMask & EConstraintWidth) && ( ((UILabel*)curView).numberOfLines == 1 ))
                    {
                        CGFloat fixHeight = rect.size.height;
                        CheckRect(rect, minSize, maxSize);
                        curView.frame = rect;
                        [curView sizeToFit];
                        rect = curView.frame;
                        rect.size.height = fixHeight;
                    }
                }
                
                if(subLayoutDes->style[styleIndex].mutableOri & ERefMutableWidth)
                {
                    curView.frame = rect;
                    
                    [curView calcWidth : ^CGFloat {
                        CGFloat priLeft = 0;
                        CGFloat priRight = self.frame.size.width;
                        
                        for(int styleIndex=0; styleIndex<2; styleIndex++)
                        {
                            UIView* assView = assMap[subLayoutDes->style[styleIndex].asstag];
                            CGRect assRect = assView.frame;
                            CGRect* pAssRect = &assRect;
                            
                            TheV(left);
                            TheV(right);
                            if(TheV_left < NILV)
                            {
                                if(assView)
                                {
                                    priLeft = assRect.origin.x + assRect.size.width + TheV_left;
                                } else {
                                    priLeft = TheV_left;
                                }
                            }
                            
                            if(TheV_right < NILV)
                            {
                                if(assView)
                                {
                                    priRight = assRect.origin.x - TheV_right;
                                } else {
                                    priRight = self.frame.size.width - TheV_right;
                                }
                            }
                        }
                        CGFloat delta = priRight - priLeft;
                        EnAZ(delta);
                        return delta;
                    }];
                    rect = curView.frame;
                    CheckRect(rect, minSize, maxSize);
                }
                
                if(subLayoutDes->style[styleIndex].mutableOri & ERefMutableHeight)
                {
                    curView.frame = rect;
                    [curView calcHeight];
                    rect = curView.frame;
                    CheckRect(rect, minSize, maxSize);
                }
                
                if(assView)
                {
                    inRect = assRect;
                    if(assView.hidden && subLayoutDes->zeroRectWhenHidden)
                    {
                        inRect.size.width = 0;
                        inRect.size.height = 0;
                    }
                    if(subLayoutDes->style[styleIndex].align)
                    {
                        [curView layoutInRect:inRect
                                       target:rect
                                         type:subLayoutDes->style[styleIndex]
                                          des:subLayoutDes
                                         mask:constraintMask
                                       parent:selfRect
                                       friend:inRect
                         ];
                    }
                    else
                    {
                        [curView layoutBesideRect:inRect
                                           target:rect
                                             type:subLayoutDes->style[styleIndex]
                                              des:subLayoutDes
                                             mask:constraintMask
                                           parent:selfRect
                                           friend:inRect
                         ];
                    }
                }
                else
                {
                    inRect = selfRect;
                    [curView layoutInRect:inRect
                                   target:rect
                                     type:subLayoutDes->style[styleIndex]
                                      des:subLayoutDes
                                     mask:constraintMask
                                   parent:selfRect
                                   friend:selfRect
                     ];
                    
                    if(EConstraintMiddle & constraintMask)
                    {
                        if( (!(constraintMask & EConstraintHeight)) && [curView isKindOfClass:[UILabel class]] )
                        {
                            CGFloat fixWidth = NILV;
                            if( ((constraintMask & EConstraintWidth) && ((UILabel*)curView).numberOfLines ==1) )
                            {
                                fixWidth = rect.size.width;
                            }
                            CheckRect(rect, minSize, maxSize);
                            curView.frame = rect;
                            [curView sizeToFit];
                            rect = curView.frame;
                            if(fixWidth < NILV)
                            {
                                rect.size.width = fixWidth;
                            }
                            if (((UILabel*)curView).numberOfLines !=1)
                            {
                                [curView layoutInRect:inRect
                                               target:rect
                                                 type:subLayoutDes->style[styleIndex]
                                                  des:subLayoutDes
                                                 mask:constraintMask
                                               parent:selfRect
                                               friend:selfRect
                                 ];
                            }
                        }
                    }
                }
            }
            [self adjustRect:rect layoutDes:subLayoutDes mask:constraintMask];
            curView.frame = rect;
            if( (!(constraintMask & EConstraintHeight)) && [curView isKindOfClass:[UILabel class]] )
            {
                CGFloat fixWidth = NILV;
                if (constraintMask & EConstraintWidth) {
                    fixWidth = rect.size.width;
                }
                
                if( [(UILabel*)curView numberOfLines] != 1 )
                {
                    [curView sizeToFit];
                }
                
                CGRect tR = curView.frame;
                if (fixWidth < NILV) {
                    tR.size.width = fixWidth;
                }
                
                if( constraintMask & EConstraintRight )
                {
                    tR.origin.x = CGRectGetMaxX(rect) - CGRectGetWidth(tR);
                }
                if( constraintMask & EConstraintBottom )
                {
                    tR.origin.y = CGRectGetMaxY(rect) - CGRectGetHeight(tR);
                }
                rect = tR;
                [self adjustRect:rect layoutDes:subLayoutDes mask:constraintMask];
                curView.frame = rect;
            }
        }
        if(![layouter didLayoutView:curView])
        {
            layouter = nil;
        }
        
        if(level > 0)
        {
            [curView spUpdateLayout:level-1];
        }
    }
}

- (void)calcWidth : (CGFloat (^)())getMaxWidth
{
    ViewLayoutDesImp* selfDes = [self getViewLayoutDesImp];
    
    if( selfDes->calcOnlyOneTimeMask & ERefFixedWidth)
    {
        return;
    }
    
    if( selfDes->calcOnlyOneTimeMask & ERefMutableWidth)
    {
        selfDes->calcOnlyOneTimeMask |= ERefFixedWidth;
    }
    
    CGRect selfRect = self.frame;
    
    for(int i=0;i<2;i++)
    {
        if(selfDes->style[i].widthRef.refView == ERefScreen)
        {
            CGFloat TheV_width = [ViewLayoutDesImp calc_width:selfDes->style[i] fetchRect:nil];
            selfRect.size.width = TheV_width;
            self.frame = selfRect;
            return;
        }
    }
    
    NSMutableArray* subviews = [self.getWillLayoutSubviews mutableCopy];
    NSInteger count = subviews.count;
    if(!count)
    {
        return;
    }
    
    CGRect* pSelfRect = &selfRect;
    
    __block std::map<NSInteger,UIView*> assMap;
    
    BaseLayouter* layouter = [self getLayouter];
    if(layouter)
    {
        [subviews insertObject:layouter atIndex:layouter.indexOfSubview];
        count++;
    }
    
    NSMutableArray* leftLinesViews = [NSMutableArray array];
    
    for(NSInteger i=0; i<count; ++i)
    {
        UIView* curView = subviews[i];
        ViewLayoutDesImp* subLayoutDes = [curView getViewLayoutDesImp];
        if(!subLayoutDes)
        {
            continue;
        }
        
        CGRect rect = curView.frame;
        CGRect* pMyselfRect = &rect;
        
        CGFloat theSetWidth = NILV;
        
        for(NSInteger styleIndex = 0; styleIndex<2; ++styleIndex)
        {
            LayoutStyle& style = subLayoutDes->style[styleIndex];
            
            if(subLayoutDes->tag>0)
                assMap[subLayoutDes->tag] = curView;
            
            UIView* assView = assMap[style.asstag];
            CGRect assRect = assView.frame;
            CGRect* pAssRect = &assRect;
            
            if(style.mutableOri & ERefMutableWidth)
            {
                curView.frame = rect;
                [curView calcWidth:^CGFloat {
                    
                    CGFloat maxWidth = getMaxWidth();
                    
                    ViewLayoutDesImp* subLayoutDes = [curView getViewLayoutDesImp];
                    if(!subLayoutDes)
                    {
                        return maxWidth;
                    }
                    
                    CGFloat priLeft = 0;
                    CGFloat priRight = maxWidth;
                    
                    for(int styleIndex=0; styleIndex<2; styleIndex++)
                    {
                        LayoutStyle& style = subLayoutDes->style[styleIndex];
                        UIView* assView = assMap[style.asstag];
                        CGRect assRect = assView.frame;
                        CGRect* pAssRect = &assRect;
                        
                        TheV(left);
                        TheV(right);
                        if(TheV_left < NILV)
                        {
                            if(assView)
                            {
                                priLeft = assRect.origin.x + assRect.size.width + TheV_left;
                            }
                            else
                            {
                                priLeft = TheV_left;
                            }
                        }
                        
                        if(TheV_right < NILV)
                        {
                            if(assView)
                            {
                                priRight = assRect.origin.x - TheV_right;
                            }
                            else
                            {
                                priRight = maxWidth - TheV_right;
                            }
                        }
                    }
                    CGFloat delta = priRight - priLeft;
                    EnAZ(delta);
                    return delta;
                }];
                rect = curView.frame;
            }
            
            if(style.asstag == EAssSuperView && style.layoutType != ELayoutNone)
            {
                if(style.leftRef.refView == ERefViewNone
                   || style.leftRef.refView == ERefParent
                   || style.leftRef.refView == ERefScreen)
                {

                    if(style.widthRef.refView == ERefViewNone
                       || style.widthRef.refView == ERefScreen)
                    {
                        TheV(width);
                        if(TheV_width >= NILV)
                        {
                            if( [curView isKindOfClass:[UILabel class]] && ((UILabel*)curView).numberOfLines ==1)
                            {
                                curView.frame = rect;
                                [curView sizeToFit];
                                rect = curView.frame;
                                theSetWidth = TheV_width;
                            }
                            else if(theSetWidth >= NILV)
                            {
                                continue;
                            }
                        }
                        else
                        {
                            theSetWidth = TheV_width;
                            rect.size.width = TheV_width;
                        }
                    }
                    else if (style.widthRef.refView == ERefFriend)
                    {
                        BOOL contains = NO;
                        for(NSArray* arr in leftLinesViews)
                        {
                            if([arr containsObject:assView])
                            {
                                contains = YES;
                                break;
                            }
                        }
                        if(!contains)
                        {
                            continue;
                        }
                        TheV(width);
                        if(TheV_width >= NILV)
                        {
                            if( [curView isKindOfClass:[UILabel class]] && ((UILabel*)curView).numberOfLines ==1)
                            {
                                curView.frame = rect;
                                [curView sizeToFit];
                                rect = curView.frame;
                            }
                            else if(theSetWidth >= NILV)
                            {
                                continue;
                            }
                        }
                        else
                        {
                            theSetWidth = TheV_width;
                            rect.size.width = TheV_width;
                        }
                    }
                    else
                    {
                        continue;
                    }
                    TheV(left);
                    if(TheV_left >= NILV)
                    {
                        TheV_left = 0;
                    }
                    rect.origin.x = TheV_left;
                    curView.frame = rect;
                    
                    NSMutableArray* array = [NSMutableArray array];
                    [leftLinesViews addObject:array];
                    [array addObject:curView];
                }
            }
            else if(assView && !style.align)
            {
                NSMutableArray* containsArray = nil;
                for(NSMutableArray* arr in leftLinesViews)
                {
                    if([arr containsObject:assView])
                    {
                        containsArray = arr;
                        break;
                    }
                }
                if(!containsArray)
                {
                    continue;
                }
                
                if(style.leftRef.refView == ERefFriend
                   || style.leftRef.refView == ERefViewNone)
                {

                    if(style.widthRef.refView == ERefViewNone
                       || style.widthRef.refView == ERefScreen
                       || style.widthRef.refView == ERefFriend
                       )
                    {
                        TheV(width);
                        if(TheV_width >= NILV)
                        {
                            if( [curView isKindOfClass:[UILabel class]] && ((UILabel*)curView).numberOfLines ==1) {
                                curView.frame = rect;
                                [curView sizeToFit];
                                rect = curView.frame;
                                theSetWidth = TheV_width;
                            }
                            else if(theSetWidth >= NILV)
                            {
                                continue;
                            }
                        }
                        else
                        {
                            theSetWidth = TheV_width;
                            rect.size.width = TheV_width;
                        }
                    }
                    else
                    {
                        continue;
                    }
                    
                    TheV(left);
                    if(TheV_left < NILV)
                    {
                        if(style.leftRef.refView == ERefViewNone)
                        {
                            TheV_left += CGRectGetMaxX(assRect);
                        }
                        rect.origin.x = TheV_left;
                        curView.frame = rect;
                        
                        [containsArray addObject:curView];
                    }
                }
            }
        }
    }
    
    CGFloat maxRight = 0;
    for(NSArray* array in leftLinesViews)
    {
        for(UIView* curView in array)
        {
            ViewLayoutDesImp* subLayoutDes = [curView getViewLayoutDesImp];
            if(!subLayoutDes)
            {
                continue;
            }
            CGRect rect = curView.frame;
            CGRect* pMyselfRect = &rect;
            
            for(NSInteger styleIndex = 0; styleIndex<2; ++styleIndex)
            {
                LayoutStyle& style = subLayoutDes->style[styleIndex];
                
                UIView* assView = assMap[style.asstag];
                CGRect assRect = assView.frame;
                CGRect* pAssRect = &assRect;
                
                if (style.rightRef.refView == ERefViewNone
                    || style.rightRef.refView == ERefScreen
                    || style.rightRef.refView == ERefParent)
                {
                    TheV(right);
                    if(TheV_right >= NILV)
                    {
                        TheV_right = 0;
                    }
                    if(assView)
                    {
                        TheV(left);
                        TheV_right += CGRectGetMaxX(assRect) + CGRectGetWidth(rect) + TheV_left;
                    }
                    else
                    {
                        TheV_right += CGRectGetMaxX(rect);
                    }
                    if(TheV_right > maxRight)
                    {
                        maxRight = TheV_right;
                    }
                }
            }
        }
    }
    selfRect.size.width = maxRight;
    self.frame = selfRect;
}

- (void)adjustRect:(ViewLayoutDesImp*)des rect:(CGRect&)rect
{
    if(des)
    {
        CGSize minSize = des->minSize;
        CGSize maxSize = des->maxSize;
        
        if ( maxSize.width>0 && rect.size.width > maxSize.width)
        {
            rect.size.width = maxSize.width;
        }
        
        if ( maxSize.height>0 && rect.size.height > maxSize.height)
        {
            rect.size.height = maxSize.height;
        }
        
        if (rect.size.width < minSize.width)
        {
            rect.size.width = minSize.width;
        }
        
        if (rect.size.height < minSize.height)
        {
            rect.size.height = minSize.height;
        }
    }
}

/**
 @brief 简单高度计算，不通过子view计算，如果完成高度计算返回 YES
 */
- (BOOL)calcHeightBase
{
    ViewLayoutDesImp* selfDes = [self getViewLayoutDesImp];
    
    if( !selfDes || selfDes->calcOnlyOneTimeMask & ERefFixedHeight)
    {
        return YES;
    }
    
    if( selfDes->calcOnlyOneTimeMask & ERefMutableHeight)
    {
        selfDes->calcOnlyOneTimeMask |= ERefFixedHeight;
    }
    
    CGRect selfRect = self.frame;
    
    if(self.hidden && selfDes->zeroRectWhenHidden)
    {
        selfRect.size.height = 0;
        self.frame = selfRect;
        return YES;
    }
    
    if(!(selfDes->style[0].mutableOri & ERefMutableHeight)
       && !(selfDes->style[1].mutableOri & ERefMutableHeight))
    {
        for(int i=0;i<2;i++)
        {
            if(selfDes->style[i].heightRef.refView == ERefScreen
               || selfDes->style[i].heightRef.refView == ERefMyself)
            {
                CGRect* pMyselfRect = &selfRect;
                CGFloat TheV_height = [ViewLayoutDesImp calc_height:selfDes->style[i] fetchRect:^CGRect *(RefView refView)
                                       {
                                           return pMyselfRect;
                                       }];
                selfRect.size.height = TheV_height;
                self.frame = selfRect;
                break;
            }
        }
        return YES;
    }
    return NO;
}

- (void)calcHeight
{
    if(![self calcHeightBase])
    {
        [self calcHeightInView];
    }
}

- (void)calcHeightInView
{
    CGRect selfRect = self.frame;
    NSMutableArray* subviews = [self.getWillLayoutSubviews mutableCopy];
    NSInteger count = subviews.count;
    if(!count)
    {
        return;
    }
    
    CGRect* pSelfRect = &selfRect;
    
    std::map<NSInteger,UIView*> assMap;
    
    BaseLayouter* layouter = [self getLayouter];
    if(layouter)
    {
        [subviews insertObject:layouter atIndex:layouter.indexOfSubview];
        count++;
    }
    
    NSMutableArray* leftLinesViews = [NSMutableArray array];
    
    for(NSInteger i=0; i<count; ++i)
    {
        UIView* curView = subviews[i];
        ViewLayoutDesImp* subLayoutDes = [curView getViewLayoutDesImp];
        if(!subLayoutDes)
        {
            continue;
        }
        
        CGRect rect = curView.frame;
        CGRect* pMyselfRect = &rect;
        CGFloat theTop = NILV;
        
        CGFloat theSetHeight = NILV;
        
        for(NSInteger styleIndex = 0; styleIndex<2; ++styleIndex)
        {
            LayoutStyle& style = subLayoutDes->style[styleIndex];
            if(style.mutableOri & ERefMutableHeight)
            {
                curView.frame = rect;
                [curView calcHeight];
                rect = curView.frame;
                theSetHeight = rect.size.height;
            }
            
            if(subLayoutDes->tag>0)
            {
                assMap[subLayoutDes->tag] = curView;
            }
            
            UIView* assView = assMap[style.asstag];
            CGRect assRect = assView.frame;
            
            CGRect* pAssRect = &assRect;
            
            if(style.asstag == 0 && style.layoutType != ELayoutNone)
            {
                if(style.topRef.refView == ERefViewNone
                   || style.topRef.refView == ERefParent
                   || style.topRef.refView == ERefScreen)
                {
                    
                    if(style.heightRef.refView == ERefViewNone
                       || style.heightRef.refView == ERefScreen
                       || style.heightRef.refView == ERefMyself)
                    {
                        TheV(height);
                        if(TheV_height >= NILV)
                        {
                            if( [curView isKindOfClass:[UILabel class]] )
                            {
                                curView.frame = rect;
                                if( ((UILabel*)curView).numberOfLines != 1 )
                                {
                                    [self spUpdateLayout:0];
                                }
                                [curView sizeToFit];
                                [self adjustRect:subLayoutDes rect:rect];
                                rect = curView.frame;
                                theSetHeight = rect.size.height;
                            }
                            else if ( [curView isKindOfClass: NSClassFromString(@"TQRichTextView")] )
                            {
                                theSetHeight = rect.size.height;
                            }
                            else if(theSetHeight >= NILV)
                            {
                                continue;
                            }
                        }
                        else
                        {
                            theSetHeight = TheV_height;
                            rect.size.height = TheV_height;
                        }
                    }
                    else if (style.heightRef.refView == ERefFriend)
                    {
                        BOOL contains = NO;
                        for(NSArray* arr in leftLinesViews)
                        {
                            if([arr containsObject:assView])
                            {
                                contains = YES;
                                break;
                            }
                        }
                        if(!contains)
                        {
                            continue;
                        }
                        TheV(height);
                        if(TheV_height >= NILV)
                        {
                            if( [curView isKindOfClass:[UILabel class]] )
                            {
                                curView.frame = rect;
                                [curView sizeToFit];
                                [self adjustRect:subLayoutDes rect:rect];
                                rect = curView.frame;
                                theSetHeight = rect.size.height;
                            }
                            else if(theSetHeight >= NILV)
                            {
                                continue;
                            }
                        }
                        else
                        {
                            theSetHeight = TheV_height;
                            rect.size.height = TheV_height;
                        }
                    }
                    else
                    {
                        continue;
                    }
                    TheV(top);
                    if(TheV_top >= NILV)
                    {
                        TheV_top = 0;
                    }
                    if(theTop >= NILV || theTop < TheV_top)
                    {
                        theTop = TheV_top;
                    }
                    rect.origin.y = theTop;
                    
                    if(curView.hidden && subLayoutDes->zeroRectWhenHidden)
                    {
                        rect.size.height = 0;
                    }
                    [self adjustRect:subLayoutDes rect:rect];
                    curView.frame = rect;
                    
                    NSMutableArray* array = [NSMutableArray array];
                    [leftLinesViews addObject:array];
                    [array addObject:curView];
                }
            }
            else if(assView && !style.align)
            {
                NSMutableArray* containsArray = nil;
                for(NSMutableArray* arr in leftLinesViews)
                {
                    if([arr containsObject:assView])
                    {
                        containsArray = arr;
                        break;
                    }
                }
                if(!containsArray)
                {
                    continue;
                }
                
                if(style.topRef.refView == ERefFriend
                   || style.topRef.refView == ERefViewNone)
                {
                    
                    if(style.heightRef.refView == ERefViewNone
                       || style.heightRef.refView == ERefScreen
                       || style.heightRef.refView == ERefFriend
                       )
                    {
                        TheV(height);
                        if(TheV_height >= NILV)
                        {
                            if( [curView isKindOfClass:[UILabel class]] )
                            {
                                curView.frame = rect;
                                [curView sizeToFit];
                                rect = curView.frame;
                                theSetHeight = rect.size.height;
                            }
                            else if(theSetHeight >= NILV)
                            {
                                continue;
                            }
                        }
                        else
                        {
                            theSetHeight = TheV_height;
                            rect.size.height = TheV_height;
                        }
                    }
                    else
                    {
                        continue;
                    }
                    
                    TheV(top);
                    if(TheV_top < NILV) {
                        if(style.topRef.refView == ERefViewNone)
                        {
                            if(style.alignType == EVertical)
                            {
                                TheV_top += CGRectGetMaxY(assRect);
                            }
                            else if(style.alignType == EHorizontal)
                            {
                                TheV_top += assRect.origin.y;
                            }
                        }
                        if(theTop >= NILV || theTop < TheV_top)
                        {
                            theTop = TheV_top;
                        }
                        rect.origin.y = theTop;
                        
                        if(curView.hidden && subLayoutDes->zeroRectWhenHidden)
                        {
                            rect.size.height = 0;
                        }
                        
                        curView.frame = rect;
                        [containsArray addObject:curView];
                    }
                }
            }
        }
    }
    
    CGFloat maxBottom = 0;
    for(NSArray* array in leftLinesViews)
    {
        for(UIView* curView in array)
        {
            ViewLayoutDesImp* subLayoutDes = [curView getViewLayoutDesImp];
            if(!subLayoutDes)
            {
                continue;
            }
            
            CGRect rect = curView.frame;
            CGRect* pMyselfRect = &rect;
            
            for(NSInteger styleIndex = 0; styleIndex<2; ++styleIndex)
            {
                LayoutStyle& style = subLayoutDes->style[styleIndex];
                
                UIView* assView = assMap[style.asstag];
                CGRect assRect = assView.frame;
                CGRect* pAssRect = &assRect;
                
                if (style.bottomRef.refView == ERefViewNone
                    || style.bottomRef.refView == ERefScreen
                    || style.bottomRef.refView == ERefParent)
                {
                    TheV(bottom);
                    if(TheV_bottom >= NILV)
                    {
                        TheV_bottom = 0;
                    }
                    if(assView)
                    {
                        TheV(top);
                        if(TheV_top >= NILV)
                        {
                            TheV_top = 0;
                        }
                        if (EVertical == style.alignType)
                        {
                            TheV_bottom += CGRectGetMaxY(assRect) + CGRectGetHeight(rect) + TheV_top;
                        }
                        else if (EHorizontal == style.alignType)
                        {
                            TheV_bottom += assRect.origin.y + CGRectGetHeight(rect) + TheV_top;
                        }
                    }
                    else
                    {
                        TheV_bottom += CGRectGetMaxY(rect);
                    }
                    if(TheV_bottom > maxBottom)
                    {
                        maxBottom = TheV_bottom;
                    }
                }
            }
        }
    }
    selfRect.size.height = maxBottom;
    self.frame = selfRect;
}

#undef TheV

- (void)adjustRect:(CGRect&)rect layoutDes:(ViewLayoutDesImp*)subLayoutDes mask:(NSInteger)constraintMask
{
    CGRect oRect = rect;
    
    if(rect.size.width > subLayoutDes->maxSize.width && subLayoutDes->maxSize.width>0)
    {
        rect.size.width = subLayoutDes->maxSize.width;
    }
    else if(rect.size.width < subLayoutDes->minSize.width)
    {
        rect.size.width = subLayoutDes->minSize.width;
    }
    
    if(rect.size.height > subLayoutDes->maxSize.height && subLayoutDes->maxSize.height>0)
    {
        rect.size.height = subLayoutDes->maxSize.height;
    }
    else if(rect.size.height < subLayoutDes->minSize.height)
    {
        rect.size.height = subLayoutDes->minSize.height;
    }
    
    if( constraintMask & EConstraintRight )
    {
        rect.origin.x = CGRectGetMaxX(oRect) - CGRectGetWidth(rect);
    }
    
    if( constraintMask & EConstraintBottom )
    {
        rect.origin.y = CGRectGetMaxY(oRect) - CGRectGetHeight(rect);
    }
}

/* private: */

#define TheV(__ori) \
CGFloat TheV_##__ori = [ViewLayoutDesImp calc_##__ori:layoutStyle fetchRect:^CGRect *(RefView refView)\
{\
    if(ERefParent == refView)\
    {\
        return &parentRect;\
    }\
    else if(ERefFriend == refView)\
    {\
        return &friendRect;\
    }\
    else if(ERefMyself == refView)\
    {\
        return &targetRect;\
    }\
    return NULL;\
}];

#define HASV(__ori) TheV(__ori) if( TheV_##__ori < NILV )
#define HASMASK(__M) (subLayoutDes->constraintMask & EConstraint##__M)

- (NSInteger)layoutInRect:(CGRect&)rect
                  target:(CGRect&)targetRect
                    type:(LayoutStyle&)layoutStyle
                     des:(ViewLayoutDesImp*)subLayoutDes
                    mask:(NSInteger&)constraintMask
                  parent:(CGRect&)parentRect
                  friend:(CGRect&)friendRect
{
    CGSize minSize = subLayoutDes->minSize;
    CGSize maxSize = subLayoutDes->maxSize;
    
    HASV(width)
    {
        CheckWidth(TheV_width, minSize, maxSize);
        targetRect.size.width = TheV_width;
        constraintMask |= EConstraintWidth;
    }
    
    HASV(height)
    {
        CheckHeight(TheV_height, minSize, maxSize);
        targetRect.size.height = TheV_height;
        constraintMask |= EConstraintHeight;
    }
    
    HASV(left)
    {
        targetRect.origin.x = rect.origin.x + TheV_left;
        constraintMask |= EConstraintLeft;
    }
    
    HASV(top)
    {
        targetRect.origin.y = rect.origin.y + TheV_top;
        constraintMask |= EConstraintTop;
    }
    
    HASV(right)
    {
        if (HASMASK(Left) && (!HASMASK(Width) || (layoutStyle.mutableOri & ERefMutableWidth)))
        {
            targetRect.size.width = CGRectGetMaxX(rect) - TheV_right - targetRect.origin.x;
            CheckWidth(targetRect.size.width, minSize, maxSize);
            EnAZ(targetRect.size.width);
            constraintMask |= EConstraintWidth;
        }
        else
        {
            targetRect.origin.x = CGRectGetMaxX(rect) - TheV_right - CGRectGetWidth(targetRect);
        }
        constraintMask |= EConstraintRight;
    }

    HASV(bottom)
    {
        if (HASMASK(Top) && (!HASMASK(Height) || (layoutStyle.mutableOri & ERefMutableHeight) ))
        {
            targetRect.size.height = CGRectGetMaxY(rect) - TheV_bottom - targetRect.origin.y;
            CheckHeight(targetRect.size.height, minSize, maxSize);
            EnAZ(targetRect.size.height);
            constraintMask |= EConstraintHeight;
        }
        else
        {
            targetRect.origin.y = CGRectGetMaxY(rect) - TheV_bottom - CGRectGetHeight(targetRect);
        }
        constraintMask |= EConstraintBottom;
    }
    
    HASV(center)
    {
        targetRect.origin.x = (CGRectGetWidth(rect) - CGRectGetWidth(targetRect)) / 2 + (rect.origin.x) + TheV_center;
        constraintMask |= EConstraintCenter;
    }
    
    HASV(middle)
    {
        targetRect.origin.y = (CGRectGetHeight(rect) - CGRectGetHeight(targetRect)) / 2 + (rect.origin.y) + TheV_middle;
        constraintMask |= EConstraintMiddle;
    }
    
    return constraintMask;
}

- (NSInteger)layoutBesideRect:(CGRect&)rect
                      target:(CGRect&)targetRect
                        type:(LayoutStyle&)layoutStyle
                         des:(ViewLayoutDesImp*)subLayoutDes
                        mask:(NSInteger&)constraintMask
                      parent:(CGRect&)parentRect
                      friend:(CGRect&)friendRect
{
    CGSize minSize = subLayoutDes->minSize;
    CGSize maxSize = subLayoutDes->maxSize;
    
    HASV(width)
    {
        CheckWidth(TheV_width, minSize, maxSize);
        targetRect.size.width = TheV_width;
        constraintMask |= EConstraintWidth;
    }
    
    HASV(height)
    {
        CheckHeight(TheV_height, minSize, maxSize);
        targetRect.size.height = TheV_height;
        constraintMask |= EConstraintHeight;
    }
    
    if( layoutStyle.alignType == EHorizontal)
    {
        HASV(left)
        {
            if (HASMASK(Right) && !HASMASK(Width))
            {
                CGFloat maxX = CGRectGetMaxX(targetRect);
                targetRect.origin.x = CGRectGetMaxX(rect) + (rect.size.width!=0?TheV_left:0);
                targetRect.size.width = maxX - targetRect.origin.x;
                CheckWidth(targetRect.size.width, minSize, maxSize);
                EnAZ(targetRect.size.width);
                constraintMask |= EConstraintWidth;
            }
            else
            {
                targetRect.origin.x = CGRectGetMaxX(rect) + (rect.size.width!=0?TheV_left:0);
            }
            constraintMask |= EConstraintLeft;
        }
        
        HASV(right)
        {
            if (HASMASK(Left) && !HASMASK(Width))
            {
                targetRect.size.width = (rect.origin.x) - (rect.size.width!=0?TheV_right:0) - targetRect.origin.x;
                CheckWidth(targetRect.size.width, minSize, maxSize);
                EnAZ(targetRect.size.width);
                constraintMask |= EConstraintWidth;
            }
            else
            {
                targetRect.origin.x = (rect.origin.x) - (rect.size.width!=0?TheV_right:0) - CGRectGetWidth(targetRect);
            }
            constraintMask |= EConstraintRight;
        }
        
        HASV(top)
        {
            if (HASMASK(Bottom) && !HASMASK(Height))
            {
                CGFloat maxY = CGRectGetMaxY(targetRect);
                targetRect.origin.y = (rect.origin.y) + (rect.size.height!=0?TheV_top:0);
                targetRect.size.height = maxY - targetRect.origin.y;
                CheckHeight(targetRect.size.height, minSize, maxSize);
                EnAZ(targetRect.size.height);
                constraintMask |= EConstraintHeight;
            }
            else
            {
                targetRect.origin.y = (rect.origin.y) + (rect.size.height!=0?TheV_top:0);
            }
            constraintMask |= EConstraintTop;
        }
        
        HASV(bottom)
        {
            if (HASMASK(Top) && !HASMASK(Height))
            {
                targetRect.size.height = CGRectGetMaxY(rect) - (rect.size.height!=0?TheV_bottom:0) - targetRect.origin.y;
                CheckHeight(targetRect.size.height, minSize, maxSize);
                EnAZ(targetRect.size.height);
                constraintMask |= EConstraintHeight;
            }
            else
            {
                targetRect.origin.y = CGRectGetMaxY(rect) - (rect.size.height!=0?TheV_bottom:0) - CGRectGetHeight(targetRect);
            }
            constraintMask |= EConstraintBottom;
        }
        
    }
    else
    {
        HASV(top)
        {
            if (HASMASK(Bottom) && !HASMASK(Height))
            {
                CGFloat maxY = CGRectGetMaxY(targetRect);
                targetRect.origin.y = CGRectGetMaxY(rect) + (rect.size.height!=0?TheV_top:0);
                targetRect.size.height = maxY - targetRect.origin.y;
                CheckHeight(targetRect.size.height, minSize, maxSize);
                EnAZ(targetRect.size.height);
                constraintMask |= EConstraintHeight;
            }
            else
            {
                targetRect.origin.y = CGRectGetMaxY(rect) + (rect.size.height!=0?TheV_top:0);
            }
            constraintMask |= EConstraintTop;
        }
        
        HASV(bottom)
        {
            if (HASMASK(Top) && !HASMASK(Height))
            {
                targetRect.size.height = (rect.origin.y) - (rect.size.height!=0?TheV_bottom:0) - targetRect.origin.y;
                CheckHeight(targetRect.size.height, minSize, maxSize);
                EnAZ(targetRect.size.height);
                constraintMask |= EConstraintHeight;
            }
            else
            {
                targetRect.origin.y = (rect.origin.y) - (rect.size.height!=0?TheV_bottom:0) - CGRectGetHeight(targetRect);
            }
            constraintMask |= EConstraintBottom;
        }
        
        HASV(left)
        {
            if (HASMASK(Right) && !HASMASK(Width))
            {
                CGFloat maxX = CGRectGetMaxX(targetRect);
                targetRect.origin.x = (rect.origin.x) + (rect.size.width!=0?TheV_left:0);
                targetRect.size.width = maxX - targetRect.origin.x;
                CheckWidth(targetRect.size.width, minSize, maxSize);
                EnAZ(targetRect.size.width);
                constraintMask |= EConstraintWidth;
            }
            else
            {
                targetRect.origin.x = (rect.origin.x) + (rect.size.width!=0?TheV_left:0);
            }
            
            constraintMask |= EConstraintLeft;
        }

        HASV(right)
        {
            if (HASMASK(Left) && !HASMASK(Width)) {
                targetRect.size.width = CGRectGetMaxX(rect) - (rect.size.width!=0?TheV_right:0) - targetRect.origin.x;
                CheckWidth(targetRect.size.width, minSize, maxSize);
                EnAZ(targetRect.size.width);
                constraintMask |= EConstraintWidth;
            }
            else
            {
                targetRect.origin.x = CGRectGetMaxX(rect) - (rect.size.width!=0?TheV_right:0) - CGRectGetWidth(targetRect);
            }
            constraintMask |= EConstraintRight;
        }
    }
    
    HASV(center)
    {
        targetRect.origin.x = (CGRectGetWidth(rect) - CGRectGetWidth(targetRect)) / 2 + (rect.origin.x) + TheV_center;
        constraintMask |= EConstraintCenter;
    }
    
    HASV(middle)
    {
        targetRect.origin.y = (CGRectGetHeight(rect) - CGRectGetHeight(targetRect)) / 2 + (rect.origin.y) + TheV_middle;
        constraintMask |= EConstraintMiddle;
    }
    return constraintMask;
}

@end
