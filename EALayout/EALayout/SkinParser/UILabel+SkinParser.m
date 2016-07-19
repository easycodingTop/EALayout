//
//  UILabel+SkinParser.m
//  EALayout
//
//  Created by easycoding on 16/3/22.
//  Copyright © 2016年 www.easycoding.top. All rights reserved.
//

#import "UILabel+SkinParser.h"

@implementation UILabel(SkinParser)

DefineParseFun(text)
{
    self.text = [SkinParser ToLocalString:value];
}

@end
