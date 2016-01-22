//
//  MatchPattern.mm
//  EALayout
//
//  Created by easycoding on 15/7/15.
//  Copyright (c) 2015年 www.easycoding.top. All rights reserved.
//

#import <vector>
#import <objc/runtime.h>
#import "MatchPattern.h"

typedef std::vector<std::pair<NSString*, ParseFunction> > MatchPatternList;
static MatchPatternList DefaultMatchPatterns;

static char MatchPatternsKey;

MatchPatternList* GetMatchPatternList(Class cls)
{
    MatchPatternList* list = nil;
    if(cls)
    {
        NSValue* value = objc_getAssociatedObject(cls, &MatchPatternsKey);
        list = static_cast<MatchPatternList*>(value.pointerValue);
    }
    return list;
}

bool AddMatchPattern(NSString* string, Class cls, ParseFunction fun)
{
    MatchPatternList* list = &DefaultMatchPatterns;
    if(cls)
    {
        NSValue* value = objc_getAssociatedObject(cls, &MatchPatternsKey);
        list = static_cast<MatchPatternList*>(value.pointerValue);
        if(!list)
        {
            list = new MatchPatternList();
            NSValue* listValue = [NSValue valueWithPointer:list];
            objc_setAssociatedObject(cls, &MatchPatternsKey, listValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    list->push_back(std::pair<NSString*, ParseFunction>(string, fun));
    return true;
}

bool RemoveMatchPattern(NSString* string, Class cls)
{
    MatchPatternList* list = NULL;
    if(cls)
    {
        NSValue* value = objc_getAssociatedObject(cls, &MatchPatternsKey);
        list = static_cast<MatchPatternList*>(value.pointerValue);
    }
    else
    {
        list = &DefaultMatchPatterns;
    }
    if(list)
    {
        for(auto iterator = list->begin(); iterator != list->end(); iterator++)
        {
            if(iterator->first.hash == string.hash)
            {
                list->erase(iterator);
                return true;
            }
        }
    }
    return false;
}

ParseFunction GetMatchPatternFunciton(NSString* string, Class cls)
{
    MatchPatternList* list = nil;
    if(cls)
    {
        NSValue* value = objc_getAssociatedObject(cls, &MatchPatternsKey);
        list = static_cast<MatchPatternList*>(value.pointerValue);
    }
    list = list ?: &DefaultMatchPatterns;
    for(auto iterator = list->begin(); iterator != list->end(); iterator++)
    {
        NSString* pattern = iterator->first;
        if(pattern.length <= string.length)
        {
            if(NSOrderedSame == [string compare:pattern options:NSCaseInsensitiveSearch
                                  range:NSMakeRange(string.length - pattern.length, pattern.length)])
            {
                return (*iterator).second;
            }
        }
    }
    if( list != &DefaultMatchPatterns)
    {
        return GetMatchPatternFunciton(string, nil);
    }
    return NULL;
}
