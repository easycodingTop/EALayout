//
//  FlowLayout.mm
//  EALayout
//
//  Created by easycoding on 15/8/10.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import "FlowLayout.h"
#import "UIView+Layout.h"
#import "ViewLayoutDesImp.h"

#define CenterFitWidth 100000

@implementation FlowLayout
{
    BOOL needCalcHeight;
}

-(id)init
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

-(void)layout
{
    NSArray* layoutViews = self.layoutViews;
    NSArray* viewLines = [self posOfGroupViews:layoutViews];
    [self layout:layoutViews lines:viewLines];
}

/**
 @param layoutViews需要布局的所有views
 @retval 返回一个行信息的数组. 
         [0]是行起始view在 layoutViews中的位置
         [1]是当前行view数量
         [2]是行总共所占宽度，包含中间间隔
         [3]是当前行中，最高控件的高度
 @brief 将layoutViews 分组，同时适配宽度和高度，并返回分组结果
 */
-(NSMutableArray*)posOfGroupViews:(NSArray*)layoutViews
{
    if(!layoutViews.count) return nil;
    
    CGRect frame = self.frame;
    NSUInteger count = layoutViews.count;
    
    CGFloat totalWidth = 0;
    CGFloat maxHeight = 0;
    
    NSUInteger startPos = 0;
    
    NSMutableArray* arrayLinePos = [NSMutableArray array];
    
    CGFloat center = style[0].center < NILV ? style[0].center : 0;
    if(style[0].layoutType & ELayoutCenter && center == CenterFitWidth)
    {
        _spacingSize.width = 0;
    }
    
    // [0] posInLine [1]count [2]maxWidth(include spacing) [3]maxHeight
    NSMutableArray* lineInfo = [NSMutableArray arrayWithObjects:@(0),@(0),@(0),@(0), nil];
    [arrayLinePos addObject:lineInfo];
    
    for(NSUInteger i = 0; i < count; i++)
    {
        UIView* view = layoutViews[i];
        CGRect rect = view.frame;
        
        if(_rowHeight>0 && sizeMode & ESizeFillHeight) rect.size.height = _rowHeight;
        
        CGFloat curLength = totalWidth + CGRectGetWidth(rect);
        
        if(curLength > CGRectGetWidth(frame))
        {
            NSUInteger countInLine = i - startPos;
            startPos = i;
            if(0 == countInLine)
            {
                maxHeight = MAX(maxHeight, rect.size.height);
                lineInfo[2] = @(curLength);
                lineInfo[3] = @(maxHeight);
                startPos++;
                countInLine = 1;
            }
            else
            {
                i--;
            }
            lineInfo[1] = @(countInLine);
            [self layoutFillWidth:layoutViews countInLine:countInLine startPos:[lineInfo[0] integerValue] lineInfo:lineInfo];
            
            if(startPos < count)
            {
                lineInfo = [NSMutableArray arrayWithObjects:@(startPos),@(0),@(0),@(0), nil];
                [arrayLinePos addObject:lineInfo];
            }
            totalWidth = 0;
            maxHeight = 0;
        }
        else
        {
            maxHeight = MAX(maxHeight, rect.size.height);
            lineInfo[2] = @(curLength);
            lineInfo[3] = @(maxHeight);
            totalWidth = curLength + _spacingSize.width;
            if(i == count-1)
            {
                NSUInteger countInLine = i - startPos + 1;
                lineInfo[1] = @(countInLine);
                [self layoutFillWidth:layoutViews countInLine:countInLine startPos:startPos lineInfo:lineInfo];
            }
        }
    }
    return arrayLinePos;
}

/**
 @brief 适配行中view的宽度。平均分配当前行中控件的宽度
 @todo 后面看是否需要添加 按比例或者其它什么规则进行宽度分配
 */
-(void)layoutFillWidth:(NSArray*)layoutViews countInLine:(NSInteger)countInLine startPos:(NSInteger)startPos lineInfo:(NSMutableArray*)lineInfo
{
    CGFloat lineHeight = [lineInfo[3] floatValue];
    if(sizeMode & ESizeFillWidth)
    {
        CGRect frame = self.frame;
        CGFloat avgWidth = (CGRectGetWidth(frame) - _spacingSize.width * (countInLine-1)) / countInLine;
        for(NSUInteger j=0;j<countInLine;j++)
        {
            UIView* viewInLine = layoutViews[j+startPos];
            CGRect rect = viewInLine.frame;
            rect.size.width = avgWidth;
            if(sizeMode & ESizeFillHeight)
            {
                rect.size.height = lineHeight;
            }
            viewInLine.frame = rect;
        }
        lineInfo[2] = @(CGRectGetWidth(frame));
    }
    else if(sizeMode & ESizeFillHeight)
    {
        for(NSUInteger j=0;j<countInLine;j++)
        {
            UIView* viewInLine = layoutViews[j+startPos];
            CGRect rect = viewInLine.frame;
            rect.size.height = lineHeight;
            viewInLine.frame = rect;
        }
    }
}

void calcWidthAndHeightDep(UIView* view, CGRect& rect)
{
    CGRect* pMyselfRect = &rect;
    for(NSInteger styleIndex = 0; styleIndex<2; ++styleIndex)
    {
        ViewLayoutDesImp* subLayoutDes = [view getViewLayoutDesImp];
        LayoutStyle& style = subLayoutDes->style[styleIndex];
        
        if( style.heightRef.refView == ERefMyself)
        {
            CGFloat TheV_height = [ViewLayoutDesImp calc_height:style fetchRect:^CGRect *(RefView) {
                return pMyselfRect;
            }];
            rect.size.height = TheV_height;
        }
        if( style.widthRef.refView == ERefMyself)
        {
            CGFloat TheV_width = [ViewLayoutDesImp calc_width:style fetchRect:^CGRect *(RefView) {
                return pMyselfRect;
            }];
            rect.size.width = TheV_width;
        }
    }
}

-(void)layout:(NSArray*)layoutViews lines:(NSArray*)viewLines
{
    NSUInteger numberOfLines = viewLines.count;
    
    CGFloat width = CGRectGetWidth(self.frame);
    
    CGFloat left = style[0].left < NILV ? style[0].left : 0;
    CGFloat center = style[0].center < NILV ? style[0].center : 0;
    CGFloat right = style[0].right < NILV ? style[0].right : 0;

    CGFloat (^getXOff)(CGFloat, NSUInteger) = ^CGFloat (CGFloat maxWidth, NSUInteger countInLine){
        
        if(style[0].layoutType & ELayoutLeft || (ELAYOUT_HOR_FLAG & style[0].layoutType) == ELayoutNone)
        {
            return left + self.frame.origin.x;
        }
        else if(style[0].layoutType & ELayoutCenter)
        {
            CGFloat theCenter = center;
            if(CenterFitWidth == theCenter)
            {
                if(countInLine > 1)
                {
                    _spacingSize.width = (width - maxWidth) / (countInLine - 1);
                    return 0;
                }
                theCenter = 0;
            }
            return (width - maxWidth) / 2 + theCenter + self.frame.origin.x;
        }
        else if(style[0].layoutType & ELayoutRight)
        {
            return width - maxWidth - right + self.frame.origin.x;
        }
        return 0;
    };
    
    CGFloat yOff = 0;
    
    for(NSUInteger i=0; i<numberOfLines; i++)
    {
        NSInteger posOfLine = [viewLines[i][0] integerValue];
        NSInteger countInLine = [viewLines[i][1] integerValue];
        CGFloat maxWidth = [viewLines[i][2] floatValue];
        CGFloat rowHeight = [viewLines[i][3] floatValue];

        CGFloat xOff = getXOff(maxWidth, countInLine);
        
        if(_rowHeight > 0)
        {
            rowHeight = _rowHeight;
        }
        
        for(NSUInteger j=0; j<countInLine; j++)
        {
            UIView* view = layoutViews[j+posOfLine];
            CGRect rect = view.frame;
            rect.origin.x = xOff;
            
            if(style[0].layoutType & ELayoutTop || (ELAYOUT_VER_FLAG & style[0].layoutType) == ELayoutNone)
            {
                CGFloat top = style[0].top < NILV ? style[0].top : 0;
                rect.origin.y = yOff + top + self.frame.origin.y;
            }
            else if(style[0].layoutType & ELayoutMiddle)
            {
                CGFloat middle = style[0].middle < NILV ? style[0].middle : 0;
                rect.origin.y = (rowHeight - CGRectGetHeight(rect)) / 2 + yOff + middle + self.frame.origin.y;
            }
            else if(style[0].layoutType & ELayoutBottom)
            {
                CGFloat bottom = style[0].bottom < NILV ? style[0].bottom : 0;
                rect.origin.y = rowHeight + yOff - bottom - CGRectGetHeight(rect) + self.frame.origin.y;
            }
            
            calcWidthAndHeightDep(view, rect);
            view.frame = rect;
            
            xOff += CGRectGetWidth(rect) + _spacingSize.width;
        }
        yOff += rowHeight + _spacingSize.height;
    }
    
    if(needCalcHeight)
    {
        CGRect frame = self.frame;
        frame.size.height = yOff - _spacingSize.height;
        self.frame = frame;
    }
}

-(void)calcHeightInView
{
    needCalcHeight = YES;
}

@end
