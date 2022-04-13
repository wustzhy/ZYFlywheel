//
//  NSObject+Selected.m
//  Mingtian
//
//  Created by yestin on 16/12/8.
//  Copyright © 2016年 yestin. All rights reserved.
//

#import "NSObject+Selected.h"
#import <objc/runtime.h>

static const void *selectedKey = @"selectedKey";

@implementation NSObject (Selected)

- (void)setIsSelected:(BOOL)isSelected
{
    objc_setAssociatedObject(self, selectedKey, @(isSelected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSelected
{
    return [objc_getAssociatedObject(self, selectedKey) boolValue];
}

@end
