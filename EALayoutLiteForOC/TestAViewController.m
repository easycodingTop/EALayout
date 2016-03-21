//
//  TestAViewController.m
//  EALayoutLiteForOC
//
//  Created by splendourbell on 16/3/11.
//  Copyright © 2016年 easycoding. All rights reserved.
//

#import "TestAViewController.h"

@interface TestAViewController ()

@end

@implementation TestAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ButtonUpInsideAction:(UIButton*)button
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)ButtonOutsideAction
{
    NSLog(@"%s", "ButtonOutsideAction");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
