//
//  SkinParser.mm
//  EALayout
//
//  Created by easycoding on 15/7/9.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import <objc/message.h>
#import "SkinParser.h"
#import "MatchPattern.h"
#import "NSObject+SkinParser.h"

FOUNDATION_EXPORT double EALayoutVersionNumber = 0.0;
FOUNDATION_EXPORT const char* EALayoutVersionString = "0.0";

@interface NSObject()

- (void)parseValue:(id)value forKey:(NSString*)key parser:(SkinParser*)parser;

@end

@implementation SkinParser
{
    NSDictionary* _dict;
}

+ (instancetype)getParserByName:(NSString*)filename
{
    return [[SkinMgr sharedInstance] getParserByName:filename];
}

+ (instancetype)getParserByData:(NSData*)data
{
    return [[SkinMgr sharedInstance] getParserByData:data];
}

- (instancetype)init:(NSDictionary*)dict
{
    if(self = [super init])
    {
        _dict = dict;
    }
    return self;
}

- (UIView*)parse:(NSString*)viewname view:(UIView*)view
{
    NSDictionary* dict = _dict[viewname];
    if(!_isRootParser && (!dict || [dict[sp_extend] integerValue]))
    {
        SkinParser* parser = [[SkinMgr sharedInstance] getParserByName:sp_common];
        parser.isRootParser = YES;
        view = [parser parse:viewname view:view];
    }
    return [self parse:view attr:_dict[viewname]];
}

- (UIView*)parse:(NSString*)key
{
    return [self parse:key view:nil];
}

- (UIView*)parse:(UIView*)view attr:(NSDictionary*)dict
{
    if isNSDictionary(dict)
    {
        if(!view)
        {
            view = createView(self, dict);
        }
        
        if(dict[sp_extendView])
        {
            view = [self parse:dict[sp_extendView] view:view];
        }

        for( NSString* key in dict )
        {
            [view parseValue:dict[key] forKey:key parser:self];
        }
    }
    else if isNSString(dict)
    {
        view = [self parse:(NSString *)dict view:view];
    }
    return view;
}

#pragma mark basevalue read

- (UIImage*)imageWithName:(NSString*)name key:(NSString*)key
{
    return toImage([self valueWithName:name key:key]);
}

- (UIImage*)imageWithPath:(NSString*)path
{
    return toImage(path);
}

- (UIColor*)colorWithName:(NSString*)name key:(NSString*)key
{
    return toColor([self valueWithName:name key:key]);
}

- (id)valueWithName:(NSString*)name key:(NSString*)key
{
    NSDictionary* dict = _dict[name];
    id value = dict[key];
    if(!value)
    {
        value = dict[sp_other][key];
        if(!value)
        {
            if(!_isRootParser && (!dict || [dict[sp_extend] integerValue]))
            {
                SkinParser* parser = [[SkinMgr sharedInstance] getParserByName:sp_common];
                parser.isRootParser = YES;
                value = [parser valueWithName:name key:key];
            }
        }
    }
    return value;
}

UIView* createView(SkinParser* parser, NSDictionary* dict)
{
    Class cls = NSClassFromString( dict[sp_class] );
    return [[cls alloc] init];
}

UIColor* ArrayToColor(NSArray* array)
{
    CGFloat r = ((NSNumber*)array[0]).floatValue;
    CGFloat g = ((NSNumber*)array[1]).floatValue;
    CGFloat b = ((NSNumber*)array[2]).floatValue;
    CGFloat a = 1.0;
    
    if( array.count > 3)
    {
        a = ((NSNumber*)array[3]).floatValue;
    }
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

UIColor* StringToColor(NSString* string)
{
    NSInteger offset = 1;
    UIColor* color = nil;
    
    if( [string hasPrefix:@"#"] || !(offset++) || [string hasPrefix:@"0x"] )
    {
        unsigned long value = strtoul([string UTF8String]+offset, NULL, 16);
        CGFloat a = ((value >> 24) & 0xFF) / 255.0;
        CGFloat r = ((value >> 16) & 0xFF) / 255.0;
        CGFloat g = ((value >> 8 ) & 0xFF) / 255.0;
        CGFloat b = ((value      ) & 0xFF) / 255.0;
        color = [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    else
    {
        SEL sel = NSSelectorFromString(string);
        if( [UIColor respondsToSelector:sel] )
        {
            color = [UIColor performSelector:sel];
        }
    }
    return color;
}

+ (UIColor*)StringToColor:(NSString*)string
{
    return StringToColor(string);
}

#pragma mark toXXXX Convert Function
CGSize toSize(NSArray* array)
{
    return CGSizeMake([array[0] floatValue],
                      [array[1] floatValue]
                      );
}

CGRect toRect(NSArray* array)
{
    return CGRectMake([array[0] floatValue],
                      [array[1] floatValue],
                      [array[2] floatValue],
                      [array[3] floatValue]
                      );
}

UIColor* toColor(id value)
{
    UIColor* color = nil;
    if isNSArray(value)
    {
        color = ArrayToColor(value);
    }
    else if isNSString(value)
    {
        color = StringToColor(value);
    }
    return color;
}

UIFont* toFont(id value)
{
    UIFont* font = nil;
    if (isNSString(value) || isNSNumber(value) )
    {
        font = [UIFont systemFontOfSize: [value floatValue]];
    }
    else if isNSDictionary(value)
    {
        CGFloat size = [value[sp_size] floatValue];
        if ( [value[sp_name] isEqualToString:sp_bold] )
        {
            font = [UIFont boldSystemFontOfSize:size];
        }
        else if( [value[sp_name] isEqualToString:sp_italic] )
        {
            font = [UIFont italicSystemFontOfSize:size];
        }
        else if( !value[sp_name] || [value[sp_name] isEqualToString:sp_system])
        {
            font = [UIFont systemFontOfSize: size];
        }
        else
        {
            font = [UIFont fontWithName:value[sp_name] size:size];
        }
    }
    return font;
}

UIImage* colorToImage(UIColor* color)
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

UIImage* toImage(id value)
{
    UIImage* image = nil;
    if isNSString(value)
    {
        NSString* imagefile = [[SkinMgr sharedInstance].skinPath stringByAppendingPathComponent:value];
        image = [UIImage imageWithContentsOfFile:imagefile];
    }
    else if isNSDictionary(value)
    {
        NSDictionary* dict = value;
        
        if(dict[@"color"])
        {
            image = colorToImage(toColor(dict[@"color"]));
        }
        else
        {
            NSString* imagefile = [[SkinMgr sharedInstance].skinPath stringByAppendingPathComponent:dict[sp_name]];
            image = [UIImage imageWithContentsOfFile:imagefile];
            
            if(dict[sp_resizeCap])
            {
                CGRect rect = toRect(dict[sp_resizeCap]);
                UIEdgeInsets* inset = (UIEdgeInsets*)&rect;
                
                if(NSOrderedSame == [dict[sp_mode] compare:@"tile" options:NSCaseInsensitiveSearch])
                {
                    image = [image resizableImageWithCapInsets:(*inset) resizingMode:(UIImageResizingModeTile)];
                }
                else if (NSOrderedSame == [dict[sp_mode] compare:@"stretch" options:NSCaseInsensitiveSearch])
                {
                    image = [image resizableImageWithCapInsets:(*inset) resizingMode:(UIImageResizingModeStretch)];
                }
                else
                {
                    image = [image resizableImageWithCapInsets:(*inset)];
                }
            }
        }
    }
    return image;
}

NSString* toString(id value)
{
    return [NSString stringWithFormat:@"%@", value];
}

UIView* toView(id value, SkinParser* parser)
{
    return [parser parse:nil attr:value];
}

UITextFieldViewMode toViewMode(id value, SkinParser* parser)
{
    NSArray* modeStrArray = @[@"never", @"whileEditing", @"unlessEditing", @"always"];
    for(NSInteger i=0; i<modeStrArray.count; i++)
    {
        if(NSOrderedSame == [value compare:modeStrArray[i] options:NSCaseInsensitiveSearch])
        {
            return UITextFieldViewMode(i);
        }
    }
    return UITextFieldViewModeNever;
}

#pragma mark ParseFunctions

id MakeColorValue(id value, SkinParser* parser)
{
    return toColor(value);
}

id MakeRectValue(id value, SkinParser* parser)
{
    return [NSValue valueWithCGRect:toRect(value)];
}

id MakeImageValue(id value, SkinParser* parser)
{
    return toImage(value);
}

id MakeSizeValue(id value, SkinParser* parser)
{
    return [NSValue valueWithCGSize:toSize(value)];
}

id MakeInsetValue(id value, SkinParser* parser)
{
    CGRect rect = toRect(value);
    UIEdgeInsets* insets = (UIEdgeInsets*)&rect;
    return [NSValue valueWithUIEdgeInsets:*insets];
}

id MakeFontValue(id value, SkinParser* parser)
{
    return toFont(value);
}

id MakeViewValue(id value, SkinParser* parser)
{
    return toView(value, parser);
}

id MakeViewModeValue(id value, SkinParser* parser)
{
    return @(toViewMode(value, parser));
}

+ (void)initialize
{
    AddMatchPattern(@"color",   nil, MakeColorValue);   //UIColor
    AddMatchPattern(@"image",   nil, MakeImageValue);   //UIImage
    AddMatchPattern(@"font",    nil, MakeFontValue);    //UIFont
    AddMatchPattern(@"frame",   nil, MakeRectValue);    //CGRect
    AddMatchPattern(@"size",    nil, MakeSizeValue);    //CGSize
    AddMatchPattern(@"Insets",  nil, MakeInsetValue);   //UIEdgeInsets
    AddMatchPattern(@"Inset",   nil, MakeInsetValue);   //UIEdgeInsets
    AddMatchPattern(@"View",    nil, MakeViewValue);    //UIView
    AddMatchPattern(@"ViewMode",nil, MakeViewModeValue);//UITextFieldViewMode
}

@end
