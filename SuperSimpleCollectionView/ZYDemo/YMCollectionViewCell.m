//
//  YMCollectionViewCell.m
//  ZYDemo
//
//  Created by yestinZhao on 2022/4/8.
//

#import "YMCollectionViewCell.h"
#import "NSObject+CGSize.h"


@interface YMCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end


@implementation YMCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor yellowColor];
    [self initViews];
  }
  return self;
}

- (void)initViews;
{
  [self.contentView addSubview:({
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 130-5, 90)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor redColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    self.titleLabel = label;
    label;
  })];
}

#pragma mark - ZYBaseCellProtocol
- (void)refreshWithData:(NSObject *)data; { //data一般为ViewModel or Model
  //Class ModelCls = NSClassFromString(@"YMModel");
  //[data isKindOfClass:ModelCls];
  
  if ([data respondsToSelector:@selector(title)]) {
    self.titleLabel.text = [data performSelector:@selector(title)];
  }
}

#pragma mark - ZYBaseCollectionCellProtocol
//A方式
//放这里计算，也行。在`sizeForItemAtIndexPath:`方法被调用，仅第一次调用会发生计算(可能耗时)。
//更好的计算时机，是在子线程请求完数据返回时 立即计算，缓存到cacheSize里。见后面的B方式
+ (CGSize)sizeWithData:(NSObject *)data {
  CGSize result;
  if (data.cacheSize) {
    result = [data.cacheSize CGSizeValue];
  }else {
    //计算
    result = CGSizeMake(140, 100); //arc4random_uniform(2) ? 140 : 
    //缓存
    data.cacheSize = [NSValue valueWithCGSize:result];
  }
  return result;
}
//B方式
//size计算发生在请求返回时，是在子线程请求完数据后 立即计算，缓存到cacheSize里
//+ (CGSize)sizeWithData:(NSObject *)data {
//  return data.cacheSize.CGSizeValue;
//}

-(void)setSelected:(BOOL)selected {
  [super setSelected:selected];
  
  self.backgroundColor = selected ? [UIColor blueColor] : [UIColor yellowColor];
}

@end
