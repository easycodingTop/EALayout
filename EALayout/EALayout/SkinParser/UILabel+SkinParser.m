//
//  UILabel+SkinParser.m
//  EALayout
//
//  Created by splendourbell on 16/3/22.
//  Copyright © 2016年 easylayout. All rights reserved.
//

#import "UILabel+SkinParser.h"

@implementation UILabel(SkinParser)

DefineParseFun(text)
{
    self.text = [SkinParser ToLocalString:value];
}

@end
