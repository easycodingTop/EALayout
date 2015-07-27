//
//  EATableViewController.m
//  EALayoutLiteForOC
//
//  Created by easycoding on 15/7/21.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#import "EATableViewController.h"
#import "EATableViewCell.h"

@interface EATableViewController ()

@property (nonatomic, strong) NSMutableDictionary* cacheViews;

@end

@implementation EATableViewController

NSString* defaultCell = @"defaultCell";

-(void)loadView{
    [super loadView];
    self.cacheViews = [NSMutableDictionary dictionary];
    [self createTableView];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self createCell:defaultCell];
}
    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
    
-(UITableView*) createTableView {
    _tableView = (UITableView*)[self.skinParser parse:EA_tableView];
    [self.contentLayoutView removeFromSuperview];
    self.contentLayoutView = _tableView;
    if(_tableView) {
        [self.view addSubview:_tableView];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIView* headerView = [self.skinParser parse:EA_tableHeaderView];
    [self resetTableHeaderView:headerView];
    return _tableView;
}

-(void)resetTableHeaderView:(UIView*)tableHeaderView  {
    CGRect rect = self.view.frame;
    tableHeaderView.frame = rect;
    [tableHeaderView spUpdateLayout];
    [tableHeaderView calcHeight];
    _tableView.tableHeaderView = nil;
    _tableView.tableHeaderView = tableHeaderView;
}

-(UITableViewCell*) createCell {
    return [self createCell:defaultCell];
}
    
-(UITableViewCell*)createCell:(NSString*)identifier {
    return [self createCell:identifier created:nil];
}

-(UITableViewCell*)createCell:(NSString*)identifier created:(void (^)(UITableViewCell* cell)) created {
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[EATableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.skinParser parse:identifier view:cell];
        if(created) {
            created(cell);
        }
    }
    return cell;
}

-(UITableViewCell*)createCacheCell:(NSString*)identifier {
    
    NSString* dentifier_cache = [identifier stringByAppendingString:@"_cache"];
    UITableViewCell* cacheView = (UITableViewCell*)self.cacheViews[dentifier_cache];
    
    if (!cacheView) {
        cacheView = [_tableView dequeueReusableCellWithIdentifier:(NSString*)dentifier_cache];
        if (!cacheView) {
            cacheView = [[EATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dentifier_cache];
            [self.skinParser parse:identifier view:cacheView];
        }
        cacheView.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cacheViews[dentifier_cache] = cacheView;
    }
    return cacheView;
}

@end
