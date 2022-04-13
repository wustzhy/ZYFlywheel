//
//  NSObject+CGSize.m
//  Mingtian
//
//  Created by yestin on 2018/5/7.
//  Copyright © 2018年 yestin. All rights reserved.
//

#import "NSObject+CGSize.h"
#import <objc/runtime.h>

static const void *CacheSizeKey = &CacheSizeKey;

@implementation NSObject (CGSize)

-(void)setCacheSize:(NSValue *)cacheSize
{
    objc_setAssociatedObject(self, CacheSizeKey, cacheSize, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)cacheSize
{
    return objc_getAssociatedObject(self, CacheSizeKey);
}

@end
