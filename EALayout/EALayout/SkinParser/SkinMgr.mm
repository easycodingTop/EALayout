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
{
    SkinParser* _cacheCommonParser;
    SkinParser* _cacheStyleParser;
    NSMutableArray<NSString*>* _jsonSearchPaths;
}

- (SkinParser*)getCommonParser
{
#ifdef DEBUG
    _cacheCommonParser = nil;
#endif
    if(!_cacheCommonParser)
    {
        _cacheCommonParser = [self getParserByName:@"common"];
    }
    return _cacheCommonParser;
}

- (SkinParser*)getStyleParser
{
#ifdef DEBUG
    _cacheStyleParser = nil;
#endif

    if(!_cacheStyleParser)
    {
        _cacheStyleParser = [self getParserByName:@"style"];
    }
    return _cacheStyleParser;
}

- (SkinParser*)getParserByName:(NSString*)filename
{
    if(!filename)
    {
        return [self getCommonParser];
    }
    else
    {
        filename = [filename componentsSeparatedByString:@"."].lastObject;
    }
    
    filename = [filename stringByAppendingString:@".json"];
    NSString* filepath = [self searchFiles:filename];
    if ( filepath )
    {
        return [self getParserByData:[NSData dataWithContentsOfFile:filepath]];
    }
    else if(![filename isEqualToString:@"common.json"])
    {
        return [self getCommonParser];
    }
    return nil;
}

- (NSString*)searchFiles:(NSString*)name
{
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSString* filepath = [_extensionPath stringByAppendingPathComponent:name];
    if(!filepath || ![fileMgr fileExistsAtPath:filepath])
    {
        filepath = [_rootPath stringByAppendingPathComponent:name];
        if(filepath && ![fileMgr fileExistsAtPath:filepath])
        {
            filepath = nil;
        }
    }
    return filepath;
}

- (SkinParser*)getParserByData:(NSData *)data
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
            NSLog(@"json文件格式可能有误,请使用工具检查(附工具:http://www.kjson.com)");
        }
    }
    return nil;
}

- (UIImage* __nullable)image:(NSString*)filename
{
    UIImage* image = nil;
    if(_extensionPath)
    {
        NSString* imagePath = [_extensionPath stringByAppendingPathComponent:filename];
        if(imagePath)
        {
            image = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    if(!image)
    {
        NSString* imagePath = [_rootPath stringByAppendingPathComponent:filename];
        if(imagePath)
        {
            image = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    return image;
}

extern CGRect S_rect;
+ (instancetype)sharedInstance
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
