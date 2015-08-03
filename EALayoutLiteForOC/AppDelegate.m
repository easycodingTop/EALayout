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
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    [self.window makeKeyAndVisible];
    
#if DEBUG
    [self enableSkinDebug];
#endif
    return YES;
}

-(void) enableSkinDebug
{
    EADebugWindow* debugWin = [EADebugWindow createDebugWindow];
    debugWin.hidden = NO;
#if TARGET_IPHONE_SIMULATOR
    [debugWin setSkinPath:@"Resources" absolutePath:__FILE__];
#endif

}

@end
