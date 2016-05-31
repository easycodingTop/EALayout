//
//  UITextField+SkinParser.mm
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import "UITextField+SkinParser.h"

@implementation UITextField(SkinParser)

- (UITextBorderStyle)valueOfUITextBorderStyle:(NSString*)style
{
    NSArray* styleStrArray = @[@"none", @"line", @"bezel", @"roundedRect"];
    for(NSInteger i=0; i<styleStrArray.count; i++)
    {
        if(NSOrderedSame == [style compare:styleStrArray[i] options:NSCaseInsensitiveSearch])
        {
            return UITextBorderStyle(i);
        }
    }
    return UITextBorderStyleNone;
}

DefineParseFun(placeholder)
{
    self.placeholder = [SkinParser ToLocalString:value];
}

DefineParseFun(borderStyle)
{
    [self setValue:@([self valueOfUITextBorderStyle:value]) forKey:@"borderStyle"];
}

- (UIKeyboardType)valueOfUIKeyboardType:(NSString*)style
{
    NSArray* keyboardTypeStrArray = @[@"Default", @"ASCIICapable", @"NumbersAndPunctuation", @"URL", @"NumberPad", @"PhonePad", @"NamePhonePad", @"EmailAddress", @"DecimalPad", @"Twitter", @"WebSearch"];
    
    for(NSInteger i=0; i<keyboardTypeStrArray.count; i++)
    {
        if(NSOrderedSame == [style compare:keyboardTypeStrArray[i] options:NSCaseInsensitiveSearch])
        {
            return UIKeyboardType(i);
        }
    }
    return UIKeyboardTypeDefault;
}

DefineParseFun(keyboardType)
{
    self.keyboardType = [self valueOfUIKeyboardType:value];
}

DefineParseFun(enablesReturnKeyAutomatically)
{
    self.enablesReturnKeyAutomatically = [value boolValue];
}

@end
