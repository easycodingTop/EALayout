//
//  EAViewController.h
//  EALayoutLiteForOC
//
//  Created by easycoding on 15/7/21.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#ifndef EALayoutLiteForOC_EAViewController_h
#define EALayoutLiteForOC_EAViewController_h

#import <EALayout/EALayout.h>

extern NSString* EA_selfView;  // 解析为 self.view
extern NSString* EA_tableView;
extern NSString* EA_tableHeaderView;

typedef enum UpdateTitleMask {
    EUpdateTitle   = 1,
    EUpdateLeft    = 1<<1,
    EUpdateMiddle  = 1<<2,
    EUpdateRight   = 1<<3,
    EUpdateBg      = 1<<4,
    EUpdateAll     = EUpdateTitle | EUpdateLeft | EUpdateMiddle | EUpdateRight | EUpdateBg
    
} UpdateTitleMask;

@interface EAViewController : UIViewController

@property (nonatomic, strong) SkinParser* skinParser;

@property (nonatomic, strong) UIView* titleBgView;
@property (nonatomic, strong) UIView* titleLeftView;
@property (nonatomic, strong) UIView* titleMiddleView;
@property (nonatomic, strong) UIView* titleRightView;

@property (nonatomic, strong) UIView* topLayoutView;
@property (nonatomic, strong) UIView* contentHeaderLayoutView;
@property (nonatomic, strong) UIView* contentLayoutView;
@property (nonatomic, strong) UIView* bottomLayoutView;

-(void) freshSkin;

@end 

#endif
