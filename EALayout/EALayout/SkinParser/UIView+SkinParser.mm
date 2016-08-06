//
//  UIView+SkinParser.m
//  EALayout
//
//  Created by easycoding on 15/7/17.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import <objc/message.h>
#import "UIView+SkinParser.h"
#import "ViewLayoutDesImp.h"
#import "NSObject+SkinParser.h"

@interface NSObject(SkinParser_pri)

- (void)parseValue:(id)value forKey:(NSString*)key parser:(SkinParser*)parser;

@end

@implementation UIView(SkinParser)

DefineParseFun(addSubview)
{
    for(NSDictionary* dict in (NSArray*)value)
    {
        if( isNSString(dict) )
        {
            NSString* viewKeyInfo = (NSString*)dict;
            NSArray* array = [viewKeyInfo componentsSeparatedByString:@"="];
            NSInteger repeat = 1;
            NSInteger offTag = 0;
            if(array.count>1)
            {
                repeat = [array[1] integerValue];
            }
            for(NSInteger i=0; i<repeat; i++)
            {
                UIView* subView = [parser parse:array[0] view:nil];
                int (*TypeMatch)(id, SEL, id) = (int (*)(id, SEL, id)) objc_msgSend;
                TypeMatch(self, @selector(addSubview:), subView);
                if(subView.tag>0)
                {
                    if(offTag == 0)
                    {
                        offTag = subView.tag;
                    }
                    else
                    {
                        subView.tag = ++offTag;
                    }
                }
            }
        }
        else
        {
            int (*TypeMatch)(id, SEL, id) = (int (*)(id, SEL, id)) objc_msgSend;
            TypeMatch(self, @selector(addSubview:), [parser parse:nil attr:dict]);
        }
    }
}

CGFloat setStyleValue(RefRule& rule, NSString* valueStr)
{
    const char* c_str = valueStr.UTF8String;
    CGFloat value = 0;
    if( !valueStr.length || isnumber(c_str[0]) || c_str[0] == '-' )
    {
        value = valueStr.floatValue;
        rule.refView = ERefViewNone;
        rule.refOri = ERefOriNone;
        rule.refOpt = ERefOptNone;
    }
    else
    {
        char refView_c, refOri_c, refOpt_c;
        float c_value = 0;
        int count = sscanf(c_str, "%c%c%c%f", &refView_c, &refOri_c, &refOpt_c, &c_value);
        if( count >= 2 )
        {
            switch (refView_c)
            {
                case 's':   rule.refView = ERefScreen;  break;
                case 'p':   rule.refView = ERefParent;  break;
                case 'f':   rule.refView = ERefFriend;  break;
                case 'm':   rule.refView = ERefMyself;  break;
                default:    rule.refView = ERefViewNone;break;
            }
            switch (refOri_c)
            {
                case 'l':   rule.refOri = ERefLeft;     break;
                case 'c':   rule.refOri = ERefCenter;   break;
                case 'r':   rule.refOri = ERefRight;    break;
                case 't':   rule.refOri = ERefTop;      break;
                case 'm':   rule.refOri = ERefMiddle;   break;
                case 'b':   rule.refOri = ERefBottom;   break;
                case 'w':   rule.refOri = ERefWidth;    break;
                case 'h':   rule.refOri = ERefHeight;   break;
                default:    rule.refOri = ERefOriNone;  break;
            }
            if( count >= 4)
            {
                switch (refOpt_c)
                {
                    case '+':  rule.refOpt = ERefAdd;      break;
                    case '-':  rule.refOpt = ERefSub;      break;
                    case '*':  rule.refOpt = ERefMul;      break;
                    case '/':  rule.refOpt = ERefDiv;      break;
                    default:   rule.refOpt = ERefOptNone;  break;
                }
                value = c_value;
            }
        }
    }
    return value;
}

NSInteger setLayoutStyle(LayoutStyle& style , NSString* value, NSInteger* mask)
{
    #define SetLayoutType(__type) style.layoutType = LayoutType(style.layoutType | (ELayout##__type))
    #define SetAlignType(__type) style.alignType = style.alignType?style.alignType:(__type)
    #define SetConstraintMask(__mask) *mask |= __mask
    
    NSInteger calcSizeMask = 0;
    NSArray* styleArray = [value componentsSeparatedByString:@","];
    
    for(NSString* key_value_str in styleArray)
    {
        #define NEED(substr) ([key rangeOfString:(NSString*) substr].length>0)
        NSArray* key_value = [key_value_str componentsSeparatedByString:@"="];
        NSString* key = key_value[0];
        NSString* value = nil;
        if(key_value.count>1)
        {
            value = key_value[1];
        }
        
        if NEED(sp_w)
        {
            SetConstraintMask(EConstraintWidth);
            if(value)
            {
                style.width = setStyleValue(style.widthRef, value);
            }
            else
            {
                style.mutableOri |= ERefMutableWidth;
            }
        }
        if NEED(sp_W)
        {
            style.mutableOri |= ERefMutableWidth;
            calcSizeMask |= ERefMutableWidth;
        }
        else if NEED(sp_h)
        {
            SetConstraintMask(EConstraintHeight);
            if(value)
            {
                style.height = setStyleValue(style.heightRef, value);
            }
            else
            {
                style.mutableOri |= ERefMutableHeight;
            }
        }
        if NEED(sp_H)
        {
            style.mutableOri |= ERefMutableHeight;
            calcSizeMask |= ERefMutableHeight;
        }
        else if NEED(sp_l)
        {
            SetConstraintMask(EConstraintLeft);
            SetLayoutType(Left);
            SetAlignType(EHorizontal);
            style.left = setStyleValue(style.leftRef, value);
        }
        else if NEED(sp_c)
        {
            SetConstraintMask(EConstraintCenter);
            SetLayoutType(Center);
            SetAlignType(EHorizontal);
            style.center = setStyleValue(style.centerRef, value);
        }
        else if NEED(sp_C)
        {
            SetConstraintMask(EConstraintCenter);
            SetLayoutType(Center);
            SetAlignType(EHorizontal);
            style.center = setStyleValue(style.centerRef, @"100000");
        }
        else if NEED(sp_r)
        {
            SetConstraintMask(EConstraintRight);
            SetLayoutType(Right);
            SetAlignType(EHorizontal);
            style.right = setStyleValue(style.rightRef, value);
        }
        else if NEED(sp_t)
        {
            SetConstraintMask(EConstraintTop);
            SetLayoutType(Top);
            SetAlignType(EVertical);
            style.top = setStyleValue(style.topRef, value);
        }
        else if NEED(sp_m)
        {
            SetConstraintMask(EConstraintMiddle);
            SetLayoutType(Middle);
            SetAlignType(EVertical);
            style.middle = setStyleValue(style.middleRef, value);
        }
        else if NEED(sp_b)
        {
            SetConstraintMask(EConstraintBottom);
            SetLayoutType(Bottom);
            SetAlignType(EVertical);
            style.bottom = setStyleValue(style.bottomRef, value);
        }
#undef NEED
    }
    return calcSizeMask;
}

NSInteger setLayoutStyle(LayoutStyle style[] , NSDictionary* dict, NSInteger* mask)
{
    NSInteger calcSizeMask = 0;
    id value = dict[sp_s];
    if isNSArray(value)
    {
        NSInteger index=0;
        for(NSDictionary* dict in value)
        {
            calcSizeMask |= setLayoutStyle(style[index], dict[sp_s], mask);
            style[index].asstag = [dict[sp_asstag] intValue];
            style[index].align = [dict[sp_align] boolValue];
            ++index;
        }
    }
    else if isNSString(value)
    {
        calcSizeMask |= setLayoutStyle(style[0], dict[sp_s], mask);
        style[0].asstag = [dict[sp_asstag] intValue];
        style[0].align = [dict[sp_align] boolValue];
    }
    return calcSizeMask;
}

#pragma mark layout
DefineParseFun(layout)
{
    if isNSDictionary(value)
    {
        ViewLayoutDesImp* layoutDes = (ViewLayoutDesImp*)[self createViewLayoutDesIfNil];
        NSDictionary* dict = value;
        NSInteger calcSizeMask = setLayoutStyle(layoutDes->style, dict, &layoutDes->constraintMask);
        
        layoutDes->calcOnlyOneTimeMask = calcSizeMask;
        
        if( dict[sp_minSize] )
            { layoutDes->minSize = toSize(dict[sp_minSize]); }
        
        if( dict[sp_maxSize] )
            { layoutDes->maxSize = toSize(dict[sp_maxSize]); }
        
        if( dict[sp_minW] )
            { layoutDes->minSize.width = [dict[sp_minW] floatValue];}
        
        if( dict[sp_minH] )
            {layoutDes->minSize.height = [dict[sp_minH] floatValue];}
        
        if( dict[sp_maxW] )
            {layoutDes->maxSize.width = [dict[sp_maxW] floatValue];}
        
        if( dict[sp_maxH] )
            { layoutDes->maxSize.width = [dict[sp_maxH] floatValue];}
        
        if( dict[sp_tag] )
            {layoutDes->tag = [dict[sp_tag] integerValue];}
    }
    else if isNSString(value)
    {
        ViewLayoutDesImp* layoutDes = (ViewLayoutDesImp*)[self createViewLayoutDesIfNil];
        setLayoutStyle(layoutDes->style[0], (NSString*)value, &layoutDes->constraintMask);
    }
}

DefineParseFun(zeroRectWhenHidden)
{
    ViewLayoutDesImp* des = (ViewLayoutDesImp*)[self createViewLayoutDesIfNil];
    des->zeroRectWhenHidden = [value boolValue];
}

- (UIReturnKeyType)valueOfUIReturnKeyType:(NSString*)keyType
{
    NSArray* stateStrArray = @[@"default", @"go", @"google", @"join", @"next", @"route", @"search", @"send", @"yahoo", @"done", @"call"];
    
    for(NSInteger i=0; i<stateStrArray.count; i++)
    {
        if(NSOrderedSame == [keyType compare:stateStrArray[i] options:NSCaseInsensitiveSearch])
        {
            return UIReturnKeyType(i);
        }
    }
    return UIReturnKeyDefault;
}

DefineParseFun(returnKeyType)
{
    int (*TypeMatch)(id, SEL, UIReturnKeyType) = (int (*)(id, SEL, UIReturnKeyType)) objc_msgSend;
    TypeMatch(self, @selector(setReturnKeyType:), (UIReturnKeyType)(@([self valueOfUIReturnKeyType:value]).integerValue));
}

static const void* KStrTag = &KStrTag;
DefineParseFun(strTag)
{
    [self setStrTag:value];
}

- (void)setStrTag:(id)strTagHashable
{
    objc_setAssociatedObject(self, KStrTag, strTagHashable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)strTag
{
    return objc_getAssociatedObject(self,KStrTag);
}

/*
 @strTag 一个可被hash的对象
 */
- (UIView*)viewWithStrTag:(id)strTagHashable
{
    return [self viewWithStrTagHash:[strTagHashable hash]];
}

- (UIView*)viewWithStrTagHash:(NSUInteger)strTagHash
{
    if ([self.strTag hash] == strTagHash)
    {
        return self;
    }
    else
    {
        NSArray* subViews = self.subviews;
        for(UIView* view in subViews)
        {
            if([view.strTag hash] == strTagHash)
            {
                return view;
            }
            UIView* subView = [view viewWithStrTagHash:strTagHash];
            if(subView)
            {
                return subView;
            }
        }
        return nil;
    }
}

/**
 @breif 可以给View以绑定一个数据key.
 */
static const void* KAutoDataBindTag = &KAutoDataBindTag;
DefineParseFun(autoDataBind)
{
    if(isNSDictionary(value))
    {
        AutoDataBind* autoDataBind = [AutoDataBind new];
        autoDataBind.keyMap = value;
        self.autoDataBind = autoDataBind;
    }
}

- (void)setAutoDataBind:(AutoDataBind*)autoBindKeys
{
    objc_setAssociatedObject(self, KAutoDataBindTag, autoBindKeys, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AutoDataBind*)autoDataBind
{
    return objc_getAssociatedObject(self,KAutoDataBindTag);
}

- (void)autoDataBind:(id)data checkMust:(BOOL)check parser:(SkinParser*)parser
{
    AutoDataBind* autoDataBind = self.autoDataBind;
    NSDictionary* keyMap = autoDataBind.keyMap;
    for(NSString* proKey in keyMap)
    {
        BOOL must = [proKey characterAtIndex:0] == '@';
    
        NSString* realKey = proKey;
    
        if(!check || must)
        {
            if(must)
            {
                realKey = [proKey substringFromIndex:1];
            }
        
            NSArray<NSString*>* keyPathAndSelector = [keyMap[proKey] componentsSeparatedByString:@":"];
            NSString* keyPath = keyPathAndSelector[0];
            SEL selector = NULL;
            if(keyPathAndSelector.count > 1)
            {
                selector = NSSelectorFromString( keyPathAndSelector[1] );
            }
            id dstValue = [data valueForKeyPath:keyPath];
            if(selector)
            {
                id (*TypeMatch)(id, SEL) = (id (*)(id, SEL)) objc_msgSend;
                dstValue = TypeMatch(dstValue, selector);
            }
            [self parseValue:dstValue forKey:realKey parser:parser];
        }
    }
    NSArray* subViews = self.subviews;
    for(UIView* view in subViews)
    {
        [view autoDataBind:data checkMust:check parser:parser];
    }
}

@end

@implementation UIView(ForTag)

- (UIView*)objectForKeyedSubscript:(NSString*)key
{
    return [self viewWithStrTag:key];
}

- (UIView*)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [self viewWithTag:idx];
}

@end
