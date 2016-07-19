//
//  EasyDefine.m
//  EALayout
//
//  Created by easycoding on 16/7/18.
//  Copyright © 2016年 www.easycoding.top. All rights reserved.
//

#import "EasyDefine.h"


@implementation WeakBox

- (id)initWithHost:(id)host
{
    if(self = [super init])
    {
        self.weakObj = host;
    }
    return self;
}

@end

