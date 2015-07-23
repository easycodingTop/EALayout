//
//  UITableView+SkinParser.h
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#import "SkinParser.h"

@interface UITableView(SkinParser)

/*
 @key[String]:separatorStyle
 @value[String]:[none | line | lineEtched]
 @brief 详见系统 UITableViewCellSeparatorStyle 枚举
 @example "separatorStyle":"line"
 */
DefineParseFun(separatorStyle);

@end
