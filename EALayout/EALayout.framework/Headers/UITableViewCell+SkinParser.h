//
//  UITableViewCell+SkinParser.h
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

#ifndef __UITABLEVIEWCELL_SKINPARSER_H__
#define __UITABLEVIEWCELL_SKINPARSER_H__

#import <Foundation/Foundation.h>
#import "UIView+SkinParser.h"

@interface UITableViewCell(SkinParser)

/*
 @key[String]:accessoryType
 @value[String]:[none | disclosureIndicator | detailDisclosureButton | checkmark | DetailButton]
 @brief 详见系统 UITableViewCellAccessoryType 枚举
 @example "accessoryType":"checkmark"
 */
DefineParseFun(accessoryType);

/*
 @key[String]:addSubview
 @value[Array]: subviews
 @brief 将子view 添加到  self.contentView上
 @example "addSubview":[{"class":"UIView"},{"class":"UIView"}]
 */
DefineParseFun(addSubview);

/*
 @key[String]:selectionStyle
 @value[String]:[none | blue | gray | default]
 @brief 详见系统 UITableViewCellSelectionStyle 枚举
 @example "selectionStyle":"blue"
 */
DefineParseFun(selectionStyle);

@end

#endif //__UITABLEVIEWCELL_SKINPARSER_H__
