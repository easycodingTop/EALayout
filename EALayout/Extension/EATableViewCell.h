//
//  EATableViewCell.h
//  EALayoutLite
//
//  Created by easycoding on 15/7/21.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EATableViewCell : UITableViewCell

@end


@interface UITableViewCell (Layout)
- (CGFloat)autoCalcHeight:(UITableView*) tableView;
@end
