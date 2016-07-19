//
//  ViewController.m
//  EALayoutLiteForOC
//
//  Created by easycoding on 15/7/21.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#import "ViewController.h"
#import "UIView+binddata.h"

@interface ViewController ()

@end

@implementation ViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (NSString*)getText:(NSInteger)row
{
    switch (row % 5)
    {
        case 0:
            return @"这是一行文字";
        case 1:
            return @"这里是两行文字\n两行";
        case 2:
            return @"这里三行文字\n第二行\n第三行";
        case 3:
            return @"不知道会是多少行，手机屏幕宽度不同可能行数不同";
        case 4:
            return @"这里是大量的文字，但是只会显示前四行,这里是大量的文字，但是只会显示前四行,这里是大量的文字，但是只会显示前四行,这里是大量的文字，但是只会显示前四行,这里是大量的文字，但是只会显示前四行,这里是大量的文字，但是只会显示前四行,这里是大量的文字，但是只会显示前四行,这里是大量的文字，但是只会显示前四行,这里是大量的文字，但是只会显示前四行,这里是大量的文字，但是只会显示前四行,这里是大量的文字，但是只会显示前四行,这里是大量的文字，但是只会显示前四行,这里是大量的文字，但是只会显示前四行,这里是大量的文字，但是只会显示前四行,这里是大量的文字，但是只会显示前四行,这里是大量的文字，但是只会显示前四行";
        default:
            break;
    }
    return @"";
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        UITableViewCell* cell = [self createCell:@"cell"];
        [cell bindByStrTag:@"titleLabel" data:[NSString stringWithFormat:@"我是第%zd行Title", indexPath.row]];
        [cell bindByTag:7002 data:[NSString stringWithFormat:@"我是第%zd行DetailText", indexPath.row]];
        return cell;
        
    }
    else
    {
        UITableViewCell* cell = [self createCell:@"customCell"];
        [cell bindByStrTag:@"multLineText" data:[self getText:indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( 0 == indexPath.row )
    {
        NSNumber* number = [self.skinParser valueWithName:@"cell" key:@"height"];
        if(number)
        {
            return [number floatValue];
        }
        else
        {
            UITableViewCell* cell = [self createCacheCell:@"cell"];
            [cell bindByStrTag:@"titleLabel" data:[NSString stringWithFormat:@"我是第%zd行Title", indexPath.row]];
            [cell bindByTag:7002 data:[NSString stringWithFormat:@"我是第%zd行DetailText", indexPath.row]];
            CGRect frame = cell.frame;
            frame.size.width = tableView.frame.size.width;
            cell.frame = frame;
            [cell spUpdateLayout];
            [cell calcHeight];
            return cell.frame.size.height;
        }
    }
    else
    {
        
        UITableViewCell* cell = [self createCacheCell:@"customCell"];
        [cell bindByStrTag:@"multLineText" data:[self getText:indexPath.row]];
        CGRect frame = cell.frame;
        frame.size.width = tableView.frame.size.width;
        cell.frame = frame;
        [cell spUpdateLayout];
        [cell calcHeight];
        return cell.frame.size.height;
    }
}

- (void)TabButtonAction:(UIButton*)button
{
    for(int i=0;i<4;i++)
    {
        UIButton* otherButton = (UIButton*)[button.superview viewWithTag:8001+i];
        otherButton.selected = false;
        [otherButton viewWithTag:1001].hidden = true;
    }
    button.selected = true;
    [button viewWithTag:1001].hidden = false;
}

- (void)AlterLabelText:(UIButton*)button
{
    button.selected = !button.selected;
    UILabel* label = (UILabel*)[self.tableView.tableHeaderView viewWithStrTag:@"contentText"];
    if(button.selected)
    {
        label.text = @"这里的文字是自动计算大小";
    }
    else
    {
        label.text = @"这里的文字是自动计算大小, 并且父view也是可以根据文字自动计算大小，无需代码计算";
    }
    [self resetTableHeaderView:self.tableView.tableHeaderView];
}

@end



