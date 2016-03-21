//
//  LinerLayout.mm
//  EALayout
//
//  Created by easycoding on 15/7/9.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import "LinerLayout.h"
#import "UIView+Layout.h"
#import "ViewLayoutDesImp.h"

@implementation LinerLayout

- (id)init
{
    if(self = [super init])
    {
        for(NSInteger i=0; i<(sizeof(style[0]) / sizeof(style)); ++i)
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

- (NSArray*)needLayoutViews
{
    NSMutableArray* retArray = nil;
    for(NSInteger i=0; i < self.layoutViews.count; ++i)
    {
        UIView* view = self.layoutViews[i];
        ViewLayoutDesImp* des = [view getViewLayoutDesImp];

        if(view.hidden && ( !des || des->zeroRectWhenHidden) )
        {
            retArray = [NSMutableArray array];
            break;
        }
    }
    
    if(retArray)
    {
        for(NSInteger i=0; i < self.layoutViews.count; ++i)
        {
            UIView* view = self.layoutViews[i];
            ViewLayoutDesImp* des = [view getViewLayoutDesImp];
            if(!view.hidden || (des && !des->zeroRectWhenHidden) )
            {
                [retArray addObject:view];
            }
        }
        return retArray;
    }
    else
    {
        return self.layoutViews;
    }
}

- (void)willLayoutView:(UIView*)view
{
    if(EVertical == style[0].alignType)
    {
        if(ESizeFillWidth == sizeMode)
        {
            CGRect rect = view.frame;
            rect.size.width = CGRectGetWidth(self.frame);
            view.frame = rect;
        }
    }
    else
    {
        if(ESizeFillHeight == sizeMode)
        {
            CGRect rect = view.frame;
            rect.size.height = CGRectGetHeight(self.frame);
            view.frame = rect;
        }
    }
}

- (void)layout
{
    if(self.needLayoutViews.count)
    {
        if(EVertical == style[0].alignType)
        {
            [self VLLayout];
        }
        else
        {
            [self HLLayout];
        }
    }
}

- (void)VLLayout
{
    if( ESizeFixed == sizeMode || ESizeFillWidth == sizeMode )
    {
        if(style[0].layoutType & ELayoutMiddle)
        {
            [self layoutForMiddle];
        }
        else if(style[0].layoutType & ELayoutBottom)
        {
            [self layoutForBottom];
        }
        else
        {
            [self layoutForTop];
        }
    }
    else
    {
        [self layoutForFillHeight];
    }
}

#define setRectAndLayout \
do\
{\
    if(CGSizeEqualToSize(view.frame.size, rect.size))\
    {\
        view.frame = rect;\
    }\
    else\
    {\
        view.frame = rect;\
        [view spUpdateLayout];\
    }\
} while(0)

- (void)layoutForFillHeight
{
    NSInteger count = self.needLayoutViews.count;
    CGRect bound = self.frame;
    CGFloat offset = bound.origin.y;
    
    CGFloat totalHeight = 0;
    NSMutableArray* mutableArray = [NSMutableArray array];
    
    for(NSInteger i = 0; i<count; ++i)
    {
        UIView* view = self.needLayoutViews[i];
        ViewLayoutDes* des = [view getViewLayoutDes];
        
        if(des && [des top:0] < NILV)
        {
            totalHeight += [des top:0];
        }
        
        if(des && [des bottom:0] < NILV)
        {
            totalHeight += [des bottom:0];
        }
        
        if(des && [des height:0] < NILV)
        {
            CGRect rect = view.frame;
            rect.size.height = [des height:0];
            setRectAndLayout;
            totalHeight += rect.size.height;
        }
        else if (des && [des middle:0] < NILV)
        {
            CGRect rect = view.frame;
            rect.size.height = [des middle:0] * CGRectGetHeight(bound);
            setRectAndLayout;
            totalHeight += rect.size.height;
        }
        else
        {
            [mutableArray addObject:view];
        }
    }
    
    CGFloat avgHeight = 0;
    if(mutableArray.count)
    {
        avgHeight = ((CGRectGetHeight(bound)-totalHeight) - self.spacing*(count-1)) / mutableArray.count;
    }
    
    for(UIView* view in mutableArray)
    {
        CGRect rect = view.frame;
        rect.size.height = avgHeight;
        setRectAndLayout;
    }
    
    for(NSInteger i = 0; i<count; ++i)
    {
        UIView* view = self.needLayoutViews[i];
        CGRect rect = view.frame;
        ViewLayoutDes* des = [view getViewLayoutDes];
        if(des && [des top:0] < NILV)
        {
            offset += [des top:0];
        }
        rect.origin.y = offset;
        [self layoutForHor:bound rect:rect];
        setRectAndLayout;
        
        if(des && [des bottom:0] < NILV)
        {
            offset += [des bottom:0];
        }
        offset += CGRectGetHeight(rect) + self.spacing;
    }
}

- (void)layoutForTop
{
    CGRect bound = self.frame;
    NSInteger count = self.needLayoutViews.count;
    CGFloat offset = bound.origin.y;
    
    for(NSInteger i = 0; i<count; ++i)
    {
        UIView* view = self.needLayoutViews[i];
        CGRect rect = view.frame;
        ViewLayoutDes* des = [view getViewLayoutDes];
        if(des && [des top:0] < NILV)
        {
            offset += [des top:0];
        }
        
        rect.origin.y = offset;
        if (des && [des middle:0] < NILV)
        {
            rect.size.height = [des middle:0] * CGRectGetHeight(bound);
        }
        
        [self layoutForHor:bound rect:rect];
        setRectAndLayout;
        if(des && [des bottom:0] < NILV)
        {
            offset += [des bottom:0];
        }
        offset += CGRectGetHeight(rect) + self.spacing;
    }
}

- (void)layoutForMiddle
{
    CGRect bound = self.frame;
    NSInteger count = self.needLayoutViews.count;
    CGFloat contentH = 0;
    
    for(NSInteger i = 0; i<count; ++i)
    {
        
        UIView* view = self.needLayoutViews[i];
        CGRect rect = view.frame;
        ViewLayoutDes* des = [view getViewLayoutDes];
        if(des && [des top:0] < NILV)
        {
            contentH += [des top:0];
        }
        if(des && [des bottom:0] < NILV)
        {
            contentH += [des bottom:0];
        }
        if (des && [des middle:0] < NILV)
        {
            rect.size.height = [des middle:0] * CGRectGetHeight(bound);
            setRectAndLayout;
        }
        contentH += CGRectGetHeight(rect);
    }
    contentH += (count-1) * self.spacing;
    
    CGFloat offset = (CGRectGetHeight(bound) - contentH) / 2 + bound.origin.y;
    
    for(NSInteger i = 0; i<count; ++i)
    {
        UIView* view = self.needLayoutViews[i];
        CGRect rect = view.frame;
        ViewLayoutDes* des = [view getViewLayoutDes];
        if(des && [des top:0] < NILV)
        {
            offset += [des top:0];
        }
        rect.origin.y = offset;
        [self layoutForHor:bound rect:rect];
        setRectAndLayout;
        if(des && [des bottom:0] < NILV)
        {
            offset += [des bottom:0];
        }
        offset += CGRectGetHeight(rect) + self.spacing;
    }
}

- (void)layoutForBottom
{
    CGRect bound = self.frame;
    NSInteger count = self.needLayoutViews.count;
    CGFloat offset = CGRectGetMaxY(bound);
    for(NSInteger i = count-1; i>=0; --i)
    {
        UIView* view = self.needLayoutViews[i];
        CGRect rect = view.frame;
        ViewLayoutDes* des = [view getViewLayoutDes];
        if (des && [des middle:0] < NILV)
        {
            rect.size.height = [des middle:0] * CGRectGetHeight(bound);
        }
        
        offset = offset - CGRectGetHeight(rect);
        if(des && [des bottom:0] < NILV)
        {
            offset -= [des bottom:0];
        }
        
        rect.origin.y = offset;
        [self layoutForHor:bound rect:rect];
        setRectAndLayout;
        
        if(des && [des top:0] < NILV)
        {
            offset -= [des top:0];
        }
        offset -= self.spacing;
    }
}

- (void)layoutForHor:(CGRect&)bound rect:(CGRect&)rect
{
    if(ESizeFillWidth & sizeMode)
    {
        rect.origin.x = bound.origin.x;
        rect.size.width = CGRectGetWidth(bound);
    }
    else
    {
        if(style[0].layoutType & ELayoutLeft)
        {
            rect.origin.x = style[0].left + bound.origin.x;
        }
        else if(style[0].layoutType & ELayoutCenter)
        {
            rect.origin.x = (CGRectGetWidth(bound) - CGRectGetWidth(rect)) / 2 + style[0].center + bound.origin.x;
        }
        else if(style[0].layoutType & ELayoutRight)
        {
            rect.origin.x = (CGRectGetMaxX(bound) - CGRectGetWidth(rect)) - style[0].right;
        }
        else
        {
            rect.origin.x = bound.origin.x;
        }
    }
}

#pragma mark HLLayout

- (void)HLLayout
{
    if( ESizeFixed == sizeMode || ESizeFillHeight == sizeMode)
    {
        if(style[0].layoutType & ELayoutCenter)
        {
            [self layoutForCenter];
        }
        else if(style[0].layoutType & ELayoutRight)
        {
            [self layoutForRight];
        }
        else
        {
            [self layoutForLeft];
        }
    }
    else
    {
        [self layoutForFillWidth];
    }
}

- (void)layoutForFillWidth
{
    NSInteger count = self.needLayoutViews.count;
    CGRect bound = self.frame;
    CGFloat offset = bound.origin.x;
    
    CGFloat totalWidth = 0;
    NSMutableArray* mutableArray = [NSMutableArray array];
    
    for(NSInteger i = 0; i<count; ++i)
    {
        UIView* view = self.needLayoutViews[i];
        ViewLayoutDes* des = [view getViewLayoutDes];
        
        if(des && [des left:0] < NILV)
        {
            totalWidth += [des left:0];
        }
        if(des && [des right:0] < NILV)
        {
            totalWidth += [des right:0];
        }
        
        if (des && [des center:0] < NILV)
        {
            CGRect rect = view.frame;
            rect.size.width = [des center:0] * CGRectGetWidth(bound);
            setRectAndLayout;
            totalWidth += rect.size.width;
        }
        else
        {
            [mutableArray addObject:view];
        }
    }
    
    CGFloat avgWidth = 0;
    if(mutableArray.count)
    {
        avgWidth = ((CGRectGetWidth(bound)-totalWidth) - self.spacing*(count-1)) / mutableArray.count;
    }
    for(UIView* view in mutableArray)
    {
        CGRect rect = view.frame;
        rect.size.width = avgWidth;
        setRectAndLayout;
    }
    
    for(NSInteger i = 0; i<count; ++i)
    {
        UIView* view = self.needLayoutViews[i];
        CGRect rect = view.frame;
        ViewLayoutDes* des = [view getViewLayoutDes];
        if(des && [des left:0] < NILV)
        {
            offset += [des left:0];
        }
        
        rect.origin.x = offset;
        [self layoutForVer:bound rect:rect];
        setRectAndLayout;
        if(des && [des right:0] < NILV)
        {
            offset += [des right:0];
        }
        offset += CGRectGetWidth(rect) + self.spacing;
    }
}

- (void)layoutForLeft
{
    CGRect bound = self.frame;
    NSInteger count = self.needLayoutViews.count;
    CGFloat offset = bound.origin.x;
    
    for(NSInteger i = 0; i<count; ++i)
    {
        UIView* view = self.needLayoutViews[i];
        CGRect rect = view.frame;
        ViewLayoutDes* des = [view getViewLayoutDes];
        if(des && [des left:0] < NILV)
        {
            offset += [des left:0];
        }
        
        rect.origin.x = offset;
        if (des && [des center:0] < NILV)
        {
            rect.size.width = [des center:0] * CGRectGetWidth(bound);
        }
        
        [self layoutForVer:bound rect:rect];
        setRectAndLayout;
        if(des && [des right:0] < NILV)
        {
            offset += [des right:0];
        }
        offset += CGRectGetWidth(rect) + self.spacing;
    }
}

- (void)layoutForCenter
{
    CGRect bound = self.frame;
    NSInteger count = self.needLayoutViews.count;
    CGFloat contentW = 0;
    
    for(NSInteger i = 0; i<count; ++i)
    {
        UIView* view = self.needLayoutViews[i];
        CGRect rect = view.frame;
        ViewLayoutDes* des = [view getViewLayoutDes];
        
        if(des && [des left:0] < NILV)
        {
            contentW += [des left:0];
        }
        if(des && [des right:0] < NILV)
        {
            contentW += [des right:0];
        }
        
        if (des && [des center:0] < NILV)
        {
            rect.size.width = [des center:0] * CGRectGetWidth(bound);
            setRectAndLayout;
        }
        contentW += CGRectGetWidth(rect);
    }
    contentW += (count-1) * self.spacing;
    
    CGFloat offset = (CGRectGetWidth(bound) - contentW) / 2 + bound.origin.x;
    
    for(NSInteger i = 0; i<count; ++i)
    {
        
        UIView* view = self.needLayoutViews[i];
        CGRect rect = view.frame;
        ViewLayoutDes* des = [view getViewLayoutDes];
        if(des && [des left:0] < NILV)
        {
            offset += [des left:0];
        }
        rect.origin.x = offset;
        [self layoutForVer:bound rect:rect];
        setRectAndLayout;
        if(des && [des right:0] < NILV)
        {
            offset += [des right:0];
        }
        offset += CGRectGetWidth(rect) + self.spacing;
    }
}

- (void)layoutForRight {
    CGRect bound = self.frame;
    NSInteger count = self.needLayoutViews.count;
    CGFloat offset = CGRectGetMaxX(bound);
    
    for(NSInteger i = count-1; i>=0; --i)
    {
        UIView* view = self.needLayoutViews[i];
        CGRect rect = view.frame;
        ViewLayoutDes* des = [view getViewLayoutDes];
        if (des && [des center:0] < NILV)
        {
            rect.size.width = [des center:0] * CGRectGetWidth(bound);
        }
        offset = offset - CGRectGetWidth(rect);
        
        if(des && [des right:0] < NILV)
        {
            offset -= [des right:0];
        }
        rect.origin.x = offset;
        [self layoutForVer:bound rect:rect];
        setRectAndLayout;
        if(des && [des left:0] < NILV)
        {
            offset -= [des left:0];
        }
        offset -= self.spacing;
    }
}

- (void)layoutForVer:(CGRect&)bound rect:(CGRect&)rect
{
    if(ESizeFillHeight & sizeMode)
    {
        rect.origin.y = bound.origin.y;
        rect.size.height = CGRectGetHeight(bound);
    }
    else
    {
        if(style[0].layoutType & ELayoutTop)
        {
            rect.origin.y = style[0].top + bound.origin.y;
        }
        else if(style[0].layoutType & ELayoutMiddle)
        {
            rect.origin.y = (CGRectGetHeight(bound) - CGRectGetHeight(rect)) / 2 + style[0].middle + bound.origin.y;
        }
        else if(style[0].layoutType & ELayoutBottom)
        {
            rect.origin.y = (CGRectGetMaxY(bound) - CGRectGetHeight(rect)) - style[0].bottom;
        }
        else
        {
            rect.origin.y = bound.origin.y;
        }
    }
}

@end
