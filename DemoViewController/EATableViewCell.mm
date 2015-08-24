//
//  EATableViewCell.m
//  EALayoutLite
//
//  Created by splendourbell on 15/7/21.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#import "EATableViewCell.h"
#import <EALayout/EALayout.h>

@implementation EATableViewCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //Tableview在计算完 cell的frame后，会调用此函数进行布局
    //添加此行是为了 在系统调用了布局后，可以进行EALayout的布局功能
    [self spUpdateLayout];
}

@end
