//
//  UIView+SkinParser.h
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#ifndef __UIVIEW_SKINPARSER_H__
#define __UIVIEW_SKINPARSER_H__

#import <Foundation/Foundation.h>
#import "SkinParser.h"

@interface UIView(SkinParser)

/**
 @brief 可以给View设置一个 String类型的tag, 更具识别性。
 */
@property (nonatomic, strong) NSString* strTag;

/**
 @key[String]:addSubview
 @value[Array]: subviews
 @brief 调用 view的 addSubview方法，添加子view
 @example "addSubview":[{"class":"UIView"},{"class":"UIView"}]
 */
DefineParseFun(addSubview);

/**
 @key[String]:zeroRectWhenHidden
 @value[Bool]:true / false
 @brief 目前主要针对 LinerLayout中， 隐藏过后的view,是否参与占位布局。 默认true,不参与布局
 @example "zeroRectWhenHidden":false
 */
DefineParseFun(zeroRectWhenHidden);

/**
 @key[String]:returnKeyType
 @value[String]: [default|go|google|join|next|route|search|send|yahoo|done|call]
 @brief 设置键盘右下角键 类型，详情见 UIReturnKeyType
 @example   "returnKeyType":"done"
 */
DefineParseFun(returnKeyType);

/**
 @key[String]:strTag
 @value[String]:string
 @brief 控件的tag属性为一数字，通常可读性差
        所以增加了 string类型的tag,可以通过 viewWithStrTag: 进行查找，规则同viewWithTag:
 @example "strTag":"startButton"    [view viewWithStrTag:@"startButton"]
 */
DefineParseFun(strTag);

/**
 @strTag 一个可被hash的对象
 */
-(UIView*)viewWithStrTag:(id)strTagHashable;

/**
 @key[String]:layout
 @value[Dictionary]:ayout描述，仅最多支持两个Layout.
 @brief 对子view进行布局. Layout规则具体见Layout规范文档
 @example
        "layout":{"s":"l=10,t,w=50,h=mw"}
 OR     "layout":{"s":[{"s":"l=10,t"},
                        {"s":"r=10","asstag":1}]
                 }
 @details
        layout支持的属性 {"s":"l,r,c,t,b,m,w,h","tag":0,"asstag":0,"align":true}
        l=0 ==> left
            可省略掉=0,即l,其它同理. w与h除外。 w=0与w不等价
        r ==> right
        c ==> center 注:只是描述 水平居中。 c=10,即水平居中后再偏移10个位置单位
        t ==> top
        b ==> bottom
        m ==> middle 注:只是描述 垂直居中。 m=-5,即垂直居中后再向上偏移5个位置单位
 
        w ==> width
        h ==> height
            h=10 表示高度为10.   
            h 直接只写h, 表示根据subviews的描述自动计算大小(如果subviews的layout可以计算出来的话)
            UILabel,不写w,h也可以自动计算大小
            w与h同理
            如果同时指定了 l,r,w 的值。则优先w的值
 
        tag 
            标识layout,以便其它layout可以查找到
        asstag 默认为0，即对应父view
            布局时 所依赖的其它view布局器tag
 
        {"s":"l,r,t,b,w=$w,h=mw*2"}
            w=$w
                其实 $可为 s p f m 4个值。
            s即screen. 
                引用 screen屏幕的某个属性, sw表示引屏幕宽度
            p即parent.  
                引用 parent父view的某个属性 ph-100 表示父view的 高度减100
            f即friend.  
                引用 friend同级view的某个属性，即asstag对应的view
                fl+10 即相对于所依赖view的 frame.origin.x + 10
            m即自身.    
                引用 自身的某个属性 通常是 高度引用宽度，以便适配屏幕宽度变化后，高度自动变化
                h=mw*0.618 相当于 h与w保持一个黄金比例。
            四则运算
                只支持  + - * / 后跟一常量
        align
            只在 asstag非0时有效,即不是相对于父view
            是否以对齐方式布局
            =============== example 1 ===============
            viewA.layout : {"s":"l,t=100,w=100,h=100","tag":1}
            viewB.layout : {"s":"l=10,t=5,w=fw/2,h=50","asstag":1,"align":$align}
            当 $align = false时,非对齐方式
                viewB.frame.origin.x = viewA.frame.origin.x + viewA.frame.size.width + 10
                viewB.frame.origin.y = viewA.frame.origin.y + 5
                viewB.frame.size.width = viewA.frame.size.width / 2
                viewB.frame.size.height = 50
            当 $align = true时，即对齐方式
                 viewB.frame.origin.x = viewA.frame.origin.x + 10
                 viewB.frame.origin.y = viewA.frame.origin.y + 5
                 viewB.frame.size.width = viewA.frame.size.width / 2
                 viewB.frame.size.height = 50
            =============== example 2 ===============
             viewA.layout : {"s":"l,t=100,w=100,h=100","tag":1}
             viewB.layout : {"s":"t=5,l=10,w=fw/2,h=50","asstag":1,"align":$align}
             当 $align = false时,非对齐方式
                 viewB.frame.origin.y = viewA.frame.origin.y + viewA.frame.size.height + 5
                 viewB.frame.origin.x = viewA.frame.origin.x + 10
                 viewB.frame.size.width = viewA.frame.size.width / 2
                 viewB.frame.size.height = 50
             当 $align = true时，即对齐方式
                 viewB.frame.origin.y = viewA.frame.origin.y + 5
                 viewB.frame.origin.x = viewA.frame.origin.x + 10
                 viewB.frame.size.width = viewA.frame.size.width / 2
                 viewB.frame.size.height = 50
            ================请注意上述ViewB中 l,t 的顺序 区别===================
            当asstag非0时, 
                在layout中  如果先出现 l,t,c 中的任意一个，则表示该布局是水平的，这样会考虑被依赖view的宽度。
                           后面跟的 t,b 则表示与顶部或者底部的对齐偏移量。m则为 垂直方面上居中。
                           先出现 t,b,m 与上同理
 
 */
DefineParseFun(layout);

@end

#endif //__UIVIEW_SKINPARSER_H__
