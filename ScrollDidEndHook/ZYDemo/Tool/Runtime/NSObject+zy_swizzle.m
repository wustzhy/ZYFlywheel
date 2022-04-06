//
//  NSObject+zy_swizzle.m
//  StartPineapple
//
//  Created by yestinZhao on 2022/3/27.
//

#import "NSObject+zy_swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (zy_swizzle)

+ (void)zy_swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL {
  
  Class class = [self class];
  
  Method originalMethod = class_getInstanceMethod(class, originalSEL);
  Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
  
  BOOL didAddMethod =
  class_addMethod(class,
                  originalSEL,
                  method_getImplementation(swizzledMethod),
                  method_getTypeEncoding(swizzledMethod));
  
  if (didAddMethod) {
      class_replaceMethod(class,
                          swizzledSEL,
                          method_getImplementation(originalMethod),
                          method_getTypeEncoding(originalMethod));
  } else {
      method_exchangeImplementations(originalMethod, swizzledMethod);
  }
}

@end
