//
//  YMBaseButton.m
//  StartPineapple
//
//  Created by yestinZhao on 2021/12/22.
//

#import "YMBaseButton.h"

@interface YMBaseButton()

/// 标记此次背景色改变 来自于setHighlighted方法
@property(nonatomic, assign)BOOL isBgColorChangeBySetStatus;
/// RD设置的源背景色，normal状态
@property(nonatomic, strong)UIColor *normalBgColor;

/// 标记此次背景色改变 来自于setHighlighted方法
@property(nonatomic, assign)BOOL isAlphaChangeByInnerSetHighlighted;
/// RD设置的alpha
@property(nonatomic, assign)CGFloat normalAlpha;

@end

@implementation YMBaseButton

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.normalAlpha = 1;
  }
  return self;
}

-(void)setAlpha:(CGFloat)alpha {
  [super setAlpha:alpha];
  if (!self.isAlphaChangeByInnerSetHighlighted) {
    self.normalAlpha = alpha;
  }
  self.isAlphaChangeByInnerSetHighlighted = NO;
}

-(void)setSelected:(BOOL)selected {
  [super setSelected:selected];
  
  if (self.selectedBgColor && self.normalBgColor) {
    [self inner_setBackgroundColor:selected ? self.selectedBgColor : self.normalBgColor];
  }
  
}

-(void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];
  
  if (self.selected && self.selectedBgColor) {
    [self inner_setBackgroundColor:self.selectedBgColor];
  } else {
    if (self.normalBgColor) {
      [self inner_setBackgroundColor:self.normalBgColor];
    }
  }
  
  if (highlighted) {
    [self inner_setAlpha:self.normalAlpha * 0.5];
  } else {
    [self inner_setAlpha:self.normalAlpha];
  }
}

-(void)inner_setAlpha:(CGFloat)alpha {
  self.isAlphaChangeByInnerSetHighlighted = YES;
  self.alpha = alpha;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
  [super setBackgroundColor:backgroundColor];
  
  if (!self.isBgColorChangeBySetStatus) {
    self.normalBgColor = backgroundColor;
  }
  self.isBgColorChangeBySetStatus = NO;
}


-(void)inner_setBackgroundColor:(UIColor *)backgroundColor {
  self.isBgColorChangeBySetStatus = YES;
  self.backgroundColor = backgroundColor;
}

@end
