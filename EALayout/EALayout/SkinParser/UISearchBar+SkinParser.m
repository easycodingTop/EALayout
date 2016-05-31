//
//  UISearchBar+SkinParser.m
//  EALayout
//
//  Created by splendourbell on 16/3/22.
//  Copyright © 2016年 easylayout. All rights reserved.
//

#import "UISearchBar+SkinParser.h"

@implementation UISearchBar(SkinParser)

DefineParseFun(placeholder)
{
    self.placeholder = [SkinParser ToLocalString:value];
}

@end
