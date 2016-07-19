//
//  UISearchBar+SkinParser.m
//  EALayout
//
//  Created by easycoding on 16/3/22.
//  Copyright © 2016年 www.easycoding.top. All rights reserved.
//

#import "UISearchBar+SkinParser.h"
#import <objc/runtime.h>

@implementation UISearchBar(SkinParser)

DefineParseFun(placeholder)
{
    self.placeholder = [SkinParser ToLocalString:value];
}

- (UITextField*)textField
{
    static void* textFieldKey = &textFieldKey;
    
    UITextField* theTextField = (UITextField*)objc_getAssociatedObject(self, textFieldKey);
    
    if(!theTextField && self.subviews.count)
    {
        self.placeholder = self.placeholder;
        UIView* needRemoveView = nil;
        for (UIView* view in self.subviews[0].subviews)
        {
            if ([view isKindOfClass:[UITextField class]])
            {
                UITextField *textFieldObject = (UITextField *)view;
                theTextField = textFieldObject;
            }
            else if(!needRemoveView && [view isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                needRemoveView = view;
            }
        }
        [needRemoveView removeFromSuperview];
        objc_setAssociatedObject(self, textFieldKey, theTextField, OBJC_ASSOCIATION_ASSIGN);
    }
    return theTextField;
}

DefineParseFun(backgroundColor)
{
    UIColor* bgcolor = toColor(value);
    
    UIColor* hookColor = [UIColor clearColor];
    super.backgroundColor = hookColor;
    float  version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version < 7.1)
    {
        [ self setBarTintColor:hookColor];
    }
    self.textField.backgroundColor = bgcolor;
}

@end
