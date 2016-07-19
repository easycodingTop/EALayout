//
//  EasyDefine.h
//  EALayout
//
//  Created by easycoding on 16/7/18.
//  Copyright © 2016年 www.easycoding.top. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakBox : NSObject

@property (nonatomic, weak) id weakObj;

- (id)initWithHost:(id)host;

@end

#define DefAssObj(TYPE, proName, SET_NAME, POLICY) \
static const void* _K##proName = &_K##proName;\
- (void)SET_NAME:(TYPE)proName\
{\
    if(OBJC_ASSOCIATION_ASSIGN == POLICY)\
    {\
        objc_setAssociatedObject(self, _K##proName, [[WeakBox alloc] initWithHost:proName], OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
    }\
    else\
    {\
        objc_setAssociatedObject(self, _K##proName, proName, POLICY);\
    }\
}\
\
- (TYPE)proName\
{\
    TYPE ret = (TYPE)objc_getAssociatedObject(self, _K##proName);\
    if([ret isKindOfClass:[WeakBox class]])\
    {\
        ret = (TYPE)((WeakBox*)ret).weakObj;\
    }\
    return ret;\
}

