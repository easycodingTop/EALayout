//
//  AppDelegate.m
//  EALayoutLiteForOC
//
//  Created by easycoding on 15/7/21.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "EADebugWindow.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    [self.window makeKeyAndVisible];

    [self enableSkinDebug];
    return YES;
}

-(void) enableSkinDebug
{
#if DEBUG
    //DEBUG状态下，创建一个控制条在界面顶部，用于开启自动刷新界面的功能，以便实时看到效果
    EADebugWindow* debugWin = [EADebugWindow createDebugWindow];
    debugWin.hidden = NO;
    
#if TARGET_IPHONE_SIMULATOR
    //些处的设置为 资源文件在系统文件夹目录相对于当前文件的相对目录，此处  AppDelegate.m 与  Resources 同级了
    [debugWin setSkinPath:@"Resources" absolutePath:__FILE__];
#endif

#endif

}

@end
