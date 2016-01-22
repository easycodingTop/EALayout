//
//  UISegmentedControl+SkinParser.h
//  EALayout
//
//  Created by easycoding on 15/8/15.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import "UIControl+SkinParser.h"

@interface UISegmentedControl(SkinParser)

/**
 @key[String]:titles
 @value[Array]:title数组
 @example
    Array :
        "titles":["title1","title2","title3"]
 */
DefineParseFun(titles);

/**
 @key[String]:dividerImage
 @value[Dictionary]:不同状态对应的图片
 @brief left,right  默认normal ["normal", "highlighted", "disabled", "selected"]
        metrics 默认default, ["default","compact","defaultPrompt","compactPrompt"]
 @example
      "dividerImage":{
        "image":"image.png",
        "left":"normal",
        "right":"normal",
        "metrics":"default"
        }
 */
DefineParseFun(dividerImage);

/**
 @key[String]:titleTextAttributes
 @value[Dictionary]:不同状态对应属性
 @brief Dictionary:状态包含["normal", "highlighted", "disabled", "selected"]
        状态对应值也为 Dictionary
 @example
  "titleTextAttributes":{
      "normal":
       {
        "NSForegroundColorAttributeName":"redColor",
        "NSFontAttributeName":{"size":14,"name":"bold"}
       },
      "selected":
       {
        "NSForegroundColorAttributeName":"greenColor",
        "NSFontAttributeName":15
       }
 }
 @todo 现在只解析了 NSForegroundColorAttributeName, NSFontAttributeName, 待有时间再添加
 */
DefineParseFun(titleTextAttributes);

@end
