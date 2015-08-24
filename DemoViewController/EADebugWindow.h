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

+(instancetype)createDebugWindow;

-(void)setSkinPath:(NSString*)relativePath absolutePath:(const char*)absolutePath;

@end


#endif

#endif //DEBUG
