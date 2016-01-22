//
//  UITableView+SkinParser.mm
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import "UITableView+SkinParser.h"

@implementation UITableView(SkinParser)

-(UITableViewCellSeparatorStyle)valueOfUITableViewCellSeparatorStyle:(NSString*)style
{
    NSArray* styleStrArray = @[@"none", @"line", @"lineEtched"];
    for(NSInteger i=0; i<styleStrArray.count; i++)
    {
        if(NSOrderedSame == [style compare:styleStrArray[i] options:NSCaseInsensitiveSearch])
        {
            return UITableViewCellSeparatorStyle(i);
        }
    }
    return UITableViewCellSeparatorStyleNone;
}

DefineParseFun(separatorStyle)
{
    [self setValue:@([self valueOfUITableViewCellSeparatorStyle:value]) forKey:@"separatorStyle"];
}

@end
