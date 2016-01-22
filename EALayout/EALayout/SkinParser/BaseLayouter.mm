//
//  BaseLayouter.mm
//  EALayout
//
//  Created by easycoding on 15/7/9.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import "BaseLayouter.h"
#import "ViewLayoutDes.h"
#import "UIView+Layout.h"

@interface BaseLayouter()

@property(nonatomic, weak) UIView* hostView;

@end

@implementation BaseLayouter

-(id)init
{
    if( self = [super init] )
    {
        _layoutViews = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addSubview:(UIView*)view
{
    if(self.hostView)
    {
        if(_layoutViews.lastObject)
        {
            [self.hostView insertSubview:view aboveSubview:_layoutViews.lastObject];
        }
        else
        {
            [self.hostView insertSubview:view atIndex:_indexOfSubview];
        }
    }
    [_layoutViews addObject:view];
}

-(void)remove:(UIView*)view
{
    [_layoutViews removeObject:view];
    [view removeFromSuperview];
}

-(BOOL)didLayoutView:(UIView*)view
{
    if(_layoutViews.lastObject == view)
    {
        [self layout];
        return NO;
    }
    return YES;
}

-(void)willLayoutView:(UIView*)view
{
    
}

-(void)layout
{
    
}

-(void)didMoveToSuperview
{
    UIView* superView = self.superview;
    if(superView)
    {
        self.hostView = superView;
        
        _indexOfSubview = superView.subviews.count - 1;
        
        for(NSInteger i=0; i<_layoutViews.count; ++i)
        {
            [superView addSubview:_layoutViews[i]];
        }
        ViewLayoutDes* layoutDes = [superView createViewLayoutDesIfNil];
        layoutDes.layouter = self;
        [self removeFromSuperview];
    }
}

-(void)removeAllViews
{
    for(UIView* view in _layoutViews)
    {
        [view removeFromSuperview];
    }
    [_layoutViews removeAllObjects];
}

@end
