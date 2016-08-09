//
//  EAViewController.h
//  EALayoutLiteForOC
//
//  Created by easycoding on 15/7/21.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#ifndef EALayoutLiteForOC_EAViewController_h
#define EALayoutLiteForOC_EAViewController_h

#import "EALayout.h"

typedef enum UpdateTitleMask {
    EUpdateTitle   = 1,
    EUpdateLeft    = 1<<1,
    EUpdateMiddle  = 1<<2,
    EUpdateRight   = 1<<3,
    EUpdateBg      = 1<<4,
    EUpdateAll     = EUpdateTitle | EUpdateLeft | EUpdateMiddle | EUpdateRight | EUpdateBg
    
} UpdateTitleMask;

@interface EAViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

/*
*/
@property (nonatomic, copy) NSString* skinFileName;
@property (nonatomic, strong) SkinParser* skinParser;

@property (nonatomic, strong) UIView* titleBgView;
@property (nonatomic, strong) UIView* titleLeftView;
@property (nonatomic, strong) UIView* titleMiddleView;
@property (nonatomic, strong) UIView* titleRightView;

@property (nonatomic, strong) UIView* topLayoutView;
@property (nonatomic, strong) UIView* contentHeaderLayoutView;
@property (nonatomic, strong) UIView* contentLayoutView;
@property (nonatomic, strong) UIView* bottomLayoutView;

- (void) freshSkin;

@property (nonatomic, strong)UITableView* tableView;

- (void)resetTableHeaderView:(UIView*)tableHeaderView;

- (UITableViewCell*)createCell:(NSString*)identifier;

- (UITableViewCell*)createCell:(NSString*)identifier created:(void (^)(UITableViewCell* cell)) created;

- (UITableViewCell*)createCacheCell:(NSString*)identifier;

@end 

#endif
