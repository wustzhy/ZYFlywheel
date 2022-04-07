//
//  YMBaseButton.h
//  StartPineapple
//
//  Created by yestinZhao on 2021/12/22.
//

/**
 * 支持 按下反馈- 透明度*0.5 变浅
 */
#import <UIKit/UIKit.h>



@interface YMBaseButton : UIButton

/// 支持设置selected状态的背景色【在按下高亮状态下 正常展示该背景色】
@property(nonatomic, strong)UIColor *selectedBgColor;

@end

