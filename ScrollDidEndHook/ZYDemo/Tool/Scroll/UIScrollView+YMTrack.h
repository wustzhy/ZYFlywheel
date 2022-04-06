//
//  UIScrollView+YMTrack.h
//  StartPineapple
//
//  Created by yestinZhao on 2022/3/29.
//

#import <UIKit/UIKit.h>




@interface UIScrollView (YMTrack)

- (void)setScrollDidEnd:(void(^)(void))scrollDidEnd;

@end


