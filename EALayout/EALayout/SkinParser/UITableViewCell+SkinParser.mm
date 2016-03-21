//
//  UITableViewCell+SkinParser.mm
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import "UITableViewCell+SkinParser.h"

@implementation UITableViewCell(SkinParser)

- (UITableViewCellAccessoryType)valueOfUITableViewCellSeparatorStyle:(NSString*)type
{
    NSArray* typeStrArray = @[@"none", @"disclosureIndicator", @"detailDisclosureButton",@"checkmark", @"DetailButton"];
    for(NSInteger i=0; i<typeStrArray.count; i++)
    {
        if(NSOrderedSame == [type compare:typeStrArray[i] options:NSCaseInsensitiveSearch])
        {
            return UITableViewCellAccessoryType(i);
        }
    }
    return UITableViewCellAccessoryNone;
}

DefineParseFun(accessoryType)
{
    [self setValue:@([self valueOfUITableViewCellSeparatorStyle:value]) forKey:@"accessoryType"];
}

- (UITableViewCellSelectionStyle)valueOfUITableViewCellSelectionStyle:(NSString*)style
{
    NSArray* styleStrArray = @[@"none", @"blue", @"gray",@"default"];
    for(NSInteger i=0; i<styleStrArray.count; i++)
    {
        if(NSOrderedSame == [style compare:styleStrArray[i] options:NSCaseInsensitiveSearch])
        {
            return UITableViewCellSelectionStyle(i);
        }
    }
    return UITableViewCellSelectionStyleNone;
}

DefineParseFun(selectionStyle)
{
    [self setValue:@([self valueOfUITableViewCellSeparatorStyle:value]) forKey:@"selectionStyle"];
}

DefineParseFun(addSubview)
{
    [self.contentView addSubview:value parser:parser];
}

- (NSArray*)getWillLayoutSubviews
{
    return self.contentView.subviews;
}

- (UIView*)getWillLayoutSuperview
{
    return self.contentView;
}

- (BaseLayouter*)getLayouter
{
    BaseLayouter* layouter = [[self getWillLayoutSuperview] getLayouter];
    if(!layouter)
    {
        for (BaseLayouter* view in self.getWillLayoutSubviews)
        {
            if ([view isKindOfClass:[BaseLayouter class]])
            {
                return view;
            }
        }
    }
    return layouter;
}

@end
