//
//  EADebugWindow.h
//  EALayoutLiteForOC
//
//  Created by easycoding on 15/7/21.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#ifndef EALayoutLiteForOC_EADebugWindow_h
#define EALayoutLiteForOC_EADebugWindow_h

#import <UIKit/UIKit.h>

@interface EADebugWindow : UIWindow

+(instancetype)createDebugWindow;

-(void)setSkinPath:(NSString*)relativePath absolutePath:(const char*)absolutePath;

@end


#endif
