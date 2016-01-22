//
//  SkinMgr.mm
//  EALayout
//
//  Created by easycoding on 15/7/9.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import "SkinMgr.h"
#import "SkinParser.h"

@implementation SkinMgr

-(SkinParser*)getParserByName:(NSString*)filename
{
    if(!filename)
    {
        filename = sp_common;
    }
    else
    {
        filename = [filename componentsSeparatedByString:@"."].lastObject;
    }
    
    NSString* filepath = [self.skinPath stringByAppendingFormat:@"/%@.json", filename];
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:filepath] )
    {
        filepath = [self.skinPath stringByAppendingFormat:@"/%@.json", sp_common];
    }
    return [self getParserByData:[NSData dataWithContentsOfFile:filepath]];
}

-(SkinParser*)getParserByData:(NSData *)data
{
    if(data)
    {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(dict)
        {
            return [[SkinParser alloc] init:dict];
        }
        else
        {
            NSLog(@"json文件格式可能有误,请使用工具检查(附工具:http://www.bejson.com/)");
        }
    }
    return nil;
}

-(NSString*)skinPath
{
    if(!_skinPath)
    {
        _skinPath = [NSBundle mainBundle].resourcePath;
    }
    return _skinPath;
}

extern CGRect S_rect;
+(instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    static SkinMgr* gSkinMgr = nil;
    dispatch_once(&pred, ^{
        gSkinMgr = [[SkinMgr alloc] init];
        S_rect = [UIScreen mainScreen].bounds;
    });
    return gSkinMgr;
}

@end
