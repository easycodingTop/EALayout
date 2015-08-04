//
//  UIControl+SkinParser.h
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#import "SkinParser.h"

@interface UIControl(SkinParser)

/*
 @key[String]:addTarget
 @value[Dictionary/String]: 不同状态所对应事件,绑定对象为, 当前parser.eventTarget,通常设置当前viewController
 @brief 绑定事件响应函数,事件为 [
        "Down","DownRepeat","DragInside","DragOutside","DragEnter",
        "DragExit","UpInside","UpOutside","Cancel",
        "ValueChanged",
        "EditingDidBegin","EditingChanged","EditingDidEndOnExit","AllTouchEvents","AllEditingEvents"]
        详情见  UIControlEvents 枚举
 @example Dictionary:
        "addTarget":{
            "UpInside":"aUpAction:",
            "DragOutside":"dragOutAction"
        }
        String:   {"addTarget":"aUpAction:"} 给"UpInside"事件响应 "aUpAction:"消息
 */
DefineParseFun(addTarget);

@end
