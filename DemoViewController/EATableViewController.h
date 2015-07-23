//
//  EATableViewController.h
//  EALayoutLiteForOC
//
//  Created by easycoding on 15/7/21.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#import "EAViewController.h"

extern NSString* defaultCell;

@interface EATableViewController : EAViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView* tableView;

-(void)resetTableHeaderView:(UIView*)tableHeaderView;

-(UITableViewCell*)createCell:(NSString*)identifier;

-(UITableViewCell*) createCell;

-(UITableViewCell*)createCell:(NSString*)identifier created:(void (^)(UITableViewCell* cell)) created;

-(UITableViewCell*)createCacheCell:(NSString*)identifier;

@end
