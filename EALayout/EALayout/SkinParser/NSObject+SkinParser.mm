//
//  NSObject+SkinParser.mm
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import <objc/message.h>
#import "MatchPattern.h"
#import "NSObject+SkinParser.h"

@implementation NSObject(SkinParser)

- (id)matchValue:(id)value forKey:(NSString*)key parser:(SkinParser*)parser
{
    ParseFunction parseFun = GetMatchPatternFunciton(key, [self class]);
    if(parseFun)
    {
        return parseFun(value, parser);
    }
    return value;
}

- (void)parseValue:(id)value forKey:(NSString*)key parser:(SkinParser*)parser
{
    NSRange range = [key rangeOfString:@"."];
    if( range.length == 0 )
    {
        SEL attrSetFun = NSSelectorFromString([key stringByAppendingString:@":parser:"]);
        if([self respondsToSelector:attrSetFun])
        {
            int (*TypeMatch)(id, SEL, id, id) = (int (*)(id, SEL, id, id)) objc_msgSend;
            TypeMatch(self, attrSetFun, value, parser);
        }
        else
        {
            id retV = [self matchValue:value forKey:key parser:parser];
            if(retV)
            {
                [self setValue:retV forKey:key];
            }
        }
    }
    else
    {
        id subProKey = [key substringToIndex:range.location];
        id subSubProKeys = [key substringFromIndex:range.location+1];
        id subHost = [self valueForKey:subProKey];
        int (*TypeMatch)(id, SEL, id, id, id) = (int (*)(id, SEL, id, id, id)) objc_msgSend;
        TypeMatch(subHost, _cmd, value, subSubProKeys, parser);
    }
}

DefineParseFun(textAlignment)
{
    NSTextAlignment alignment = NSTextAlignmentLeft;
    if isNSString(value)
    {
        NSString* align = value;
        if ( [sp_center isEqualToString:align] )
        {
            alignment = NSTextAlignmentCenter;
        }
        else if ( [sp_right isEqualToString:align] )
        {
            alignment = NSTextAlignmentRight;
        }
        else if([sp_left isEqualToString:align])
        {
            alignment = NSTextAlignmentLeft;
        }
    }
    else
    {
        alignment = (NSTextAlignment)[value integerValue];
    }
    [self setValue:@(alignment) forKey:@"textAlignment"];
}

DefineParseFun(linkStyle)
{
    [parser parse:value view:(UIView*)self];
    SkinParser* styleParser = [[SkinMgr sharedInstance] getParserByName:sp_style];
    styleParser.isRootParser = YES;
    [styleParser parse:value view:(UIView*)self];
}

#define NOUSEDFUN(x) DefineParseFun(x){}

NOUSEDFUN(class);
NOUSEDFUN(extend);
NOUSEDFUN(other);
NOUSEDFUN(extendView);

#undef NOUSEDFUN

@end
