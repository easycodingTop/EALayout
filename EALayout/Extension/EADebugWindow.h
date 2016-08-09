//
//  EADebugWindow.h
//  EALayoutLiteForOC
//
//  Created by easycoding on 15/7/21.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//
//  此文件只是用于DEBUG，主要是用来控制实时刷新的开关操作。

#if DEBUG

#ifndef EALayoutLiteForOC_EADebugWindow_h
#define EALayoutLiteForOC_EADebugWindow_h

#import <UIKit/UIKit.h>

@interface EADebugWindow : UIWindow

+ (instancetype)createDebugWindow;

- (void)setSkinPath:(NSString*)relativePath absolutePath:(NSString*)absolutePath;

@end

#endif //EALayoutLiteForOC_EADebugWindow_h

#endif //DEBUG


/*usage:*/
/*
- (void)enableSkinDebug
{
#if DEBUG
        //DEBUG状态下，创建一个控制条在界面顶部，用于开启自动刷新界面的功能，以便实时看到效果
        EADebugWindow* debugWin = [EADebugWindow createDebugWindow];
        debugWin.hidden = NO;
        
    #if TARGET_IPHONE_SIMULATOR
        //些处的设置为 资源文件在系统文件夹目录相对于当前文件的相对目录，此处  AppDelegate.m 与  Resources 同级了
        [debugWin setSkinPath:@"Resources" absolutePath:[@(__FILE__) stringByDeletingLastPathComponent]];
    #endif
        
#endif
    
}
*/
