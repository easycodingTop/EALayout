//
//  UISegmentedControl+SkinParser.mm
//  EALayout
//
//  Created by easycoding on 15/8/15.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import "UISegmentedControl+SkinParser.h"

@interface UIControl()
- (UIControlState)valueOfUIControlState:(NSString*)stateStr;
@end

@implementation UISegmentedControl(SkinParser)

DefineParseFun(titles)
{
    NSArray* titleArray = (NSArray*)value;
    NSUInteger count = titleArray.count;
    for(NSUInteger i=0; i<count; i++)
    {
        [self insertSegmentWithTitle:titleArray[i] atIndex:i animated:NO];
    }
}

DefineParseFun(dividerImage)
{
    NSDictionary* dict = (NSDictionary*)value;
    UIImage* image = toImage(dict[@"image"]);
    UIControlState leftState = [self valueOfUIControlState:dict[@"left"]];
    UIControlState rightState = [self valueOfUIControlState:dict[@"right"]];
    
    NSString* metricsString = dict[@"metrics"];
    UIBarMetrics metrics = UIBarMetricsDefault;
    if([metricsString isKindOfClass:[NSString class]])
    {
        if(0 == strcasecmp(metricsString.UTF8String, "default"))
        {
            metrics = UIBarMetricsDefault;
        }
        else if(0 == strcasecmp(metricsString.UTF8String, "compact"))
        {
            metrics = UIBarMetricsCompact;
        }
        else if(0 == strcasecmp(metricsString.UTF8String, "defaultPrompt"))
        {
            metrics = UIBarMetricsDefaultPrompt;
        }
        else if(0 == strcasecmp(metricsString.UTF8String, "compactPrompt"))
        {
            metrics = UIBarMetricsCompactPrompt;
        }
    }
    else
    {
        metrics = (UIBarMetrics)[metricsString integerValue];
    }
    
    [self setDividerImage:image forLeftSegmentState:leftState rightSegmentState:rightState barMetrics:metrics];
}

DefineParseFun(titleTextAttributes)
{
    NSDictionary* dict = (NSDictionary*)value;
    for(NSString* key in dict)
    {
        UIControlState state = [self valueOfUIControlState:key];
        NSDictionary* valueDict = dict[key];
        NSMutableDictionary* attrDict = [NSMutableDictionary dictionary];
        for(NSString* valueItemKey in valueDict)
        {
            if([valueItemKey isEqualToString:NSForegroundColorAttributeName])
            {
                attrDict[valueItemKey] = toColor(valueDict[valueItemKey]);
            }
            else if([valueItemKey isEqualToString:NSFontAttributeName])
            {
                attrDict[valueItemKey] = toFont(valueDict[valueItemKey]);
            }
        }
        [self setTitleTextAttributes:attrDict forState:state];
    }
}

@end
