//
//  NSObject+zy_swizzle.h
//  StartPineapple
//
//  Created by yestinZhao on 2022/3/27.
//

#import <Foundation/Foundation.h>


@interface NSObject (zy_swizzle)

+ (void)zy_swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL;

@end

