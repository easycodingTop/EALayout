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

-(void)layoutSubviews {
    [super layoutSubviews];
    [self spUpdateLayout];
}

@end
