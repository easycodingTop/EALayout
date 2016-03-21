//
//  UIControl+SkinParser.m
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import "UIControl+SkinParser.h"
#import "SkinParser.h"

@implementation UIControl(SkinParser)

- (UIControlState)valueOfUIControlState:(NSString*)stateStr
{
    NSArray* stateStrArray = @[@"normal", @"highlighted", @"disabled", @"selected"];
    UIControlState stateValueArray[] = {
        UIControlStateNormal,
        UIControlStateHighlighted,
        UIControlStateDisabled,
        UIControlStateSelected
    };
    
    for(NSInteger i=0; i<stateStrArray.count; i++)
    {
        if(NSOrderedSame == [stateStr compare:stateStrArray[i] options:NSCaseInsensitiveSearch])
        {
            return stateValueArray[i];
        }
    }
    return UIControlStateNormal;
}

- (UIControlEvents)valueOfUIControlEvents:(NSString*)eventsStr
{
    NSArray* stateStrArray = @[@"Down",@"DownRepeat",@"DragInside",@"DragOutside",@"DragEnter",
                               @"DragExit",@"UpInside",@"UpOutside",@"Cancel",
                               @"",@"",@"",
                               @"ValueChanged",@"",@"",@"",
                               @"EditingDidBegin",@"EditingChanged",@"EditingDidEnd",@"EditingDidEndOnExit",
                               @"AllTouchEvents",@"AllEditingEvents"
                               ];
    
    for(NSInteger i=0; i<stateStrArray.count; i++)
    {
        if(NSOrderedSame == [eventsStr compare:stateStrArray[i] options:NSCaseInsensitiveSearch])
        {
            if( [stateStrArray[i] isEqualToString:@"AllTouchEvents"] )
            {
                return UIControlEventAllTouchEvents;
            }
            else if( [ stateStrArray[i] isEqualToString:@"AllEditingEvents"] )
            {
                return UIControlEventAllEditingEvents;
            }
            else
            {
                return UIControlEvents(1 << i);
            }
        }
    }
    return UIControlEventTouchUpInside;
}

DefineParseFun(addTarget)
{
    if ( isNSString(value) )
    {
        [self addTarget:parser.eventTarget action:NSSelectorFromString(value) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (isNSDictionary(value))
    {
        NSDictionary* dict = (NSDictionary*)value;
        for( NSString* key in dict)
        {
            UIControlEvents events = [self valueOfUIControlEvents:key];
            [self addTarget:parser.eventTarget action:NSSelectorFromString(dict[key]) forControlEvents:events];
        }
    }
}

@end
