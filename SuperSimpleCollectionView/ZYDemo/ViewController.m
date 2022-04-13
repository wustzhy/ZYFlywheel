//
//  ViewController.m
//  ZYDemo
//
//  Created by yestinZhao on 2022/4/6.
//

#import "ViewController.h"
#import "ZYBaseCollectionView.h"
#import "YMCollectionViewCell.h"
#import "YMModel.h"
#import "NSObject+Selected.h"
#import "YMChoicesView.h"

@interface ViewController ()

@property (nonatomic, strong) YMChoicesView *choicesView;

@property (nonatomic, strong) ZYBaseCollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  [self.view addSubview:({
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 44)];
    label.font = [UIFont systemFontOfSize:10 weight:UIFontWeightSemibold];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"极简CollectionView用法，无须创建XXCollectionView类";
    label;
  })];
  
  
  [self.view addSubview:({
    YMChoicesView * view = [YMChoicesView view];
    self.choicesView = view;
    view;
  })];
  NSArray <NSDictionary *>*titleAndFunction = @[
    @{@"title": @"滚动方向可设置的CollectionView，布局时的实际itemSpace值会超过设定值（苹果UICollectionView）",
      @"func": NSStringFromSelector(@selector(initCollectionViewScrollDirectionFree))},
    @{@"title": @"itemSpace会严格按照设定值去布局，仅限垂直方向滚动的CollectionView（EqualSpaceFlowLayout）",
      @"func": NSStringFromSelector(@selector(initCollectionViewScrollDirectionVerticalWhileItemSpaceAcurrate))},
    @{@"title": @"通过数据决定cell的默认选中状态，eg.单选CollectionView",
      @"func": NSStringFromSelector(@selector(initCollectionViewWithDefaultSelectedItem))},
    @{@"title": @"通过数据决定cell的默认选中状态，eg.多选CollectionView",
      @"func": NSStringFromSelector(@selector(initCollectionViewMultipleSelectionWithDefaultSelectedItems))},
  ];
  __weak typeof(self) weakSelf = self;
  self.choicesView.didSelect = ^(NSIndexPath *idp) {
    [weakSelf performSelector:NSSelectorFromString(titleAndFunction[idp.row][@"func"])];
  };
  self.choicesView.choices = titleAndFunction;

  
  //选择第1个
  dispatch_async(dispatch_get_main_queue(), ^{
    NSIndexPath *idp = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.choicesView selectRowAtIndexPath:idp animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.choicesView.delegate tableView:self.choicesView didSelectRowAtIndexPath:idp];
    //[self.choicesView cellForRowAtIndexPath:idp].selected = YES;
  });
}

- (void)initCollectionViewScrollDirectionFree {
    [self initCollectionView1];
    
    //请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      NSMutableArray *mArr = [NSMutableArray array];
      for (int i = 0; i < 15; i++) {
        YMModel *mdl = [YMModel new];
        NSString *title = i%2 ? @"支持Selected状态换背景色、(按下反馈)高亮态背景色变化的YMBaseButton" : @"监听UIScrollView滚动停止的回调";
        mdl.title = [NSString stringWithFormat:@"%@. %@", @(i), title];
        [mArr addObject:mdl];
      }
      [self.collectionView refreshWithData:mArr];
    });
}

- (void)initCollectionViewScrollDirectionVerticalWhileItemSpaceAcurrate {

    [self initCollectionView2];
    
    //请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      NSMutableArray *mArr = [NSMutableArray array];
      for (int i = 0; i < 15; i++) {
        YMModel *mdl = [YMModel new];
        NSString *title = i%2 ? @"支持Selected状态换背景色、(按下反馈)高亮态背景色变化的YMBaseButton" : @"监听UIScrollView滚动停止的回调";
        mdl.title = [NSString stringWithFormat:@"%@. %@", @(i), title];
        [mArr addObject:mdl];
      }
      [self.collectionView refreshWithData:mArr];
    });
}

- (void)initCollectionViewWithDefaultSelectedItem {
  [self initCollectionView1];
  
  //请求
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    NSMutableArray *mArr = [NSMutableArray array];
    for (int i = 0; i < 15; i++) {
      YMModel *mdl = [YMModel new];
      NSString *title = i%2 ? @"支持Selected状态换背景色、(按下反馈)高亮态背景色变化的YMBaseButton" : @"监听UIScrollView滚动停止的回调";
      mdl.title = [NSString stringWithFormat:@"%@. %@", @(i), title];
      mdl.isSelected = i == 2 ; //-test: 第2个默认选中
      [mArr addObject:mdl];
    }
    [self.collectionView refreshWithData:mArr];
  });
}

- (void)initCollectionViewMultipleSelectionWithDefaultSelectedItems {
  
  [self initCollectionView2];
  
  //请求
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    NSMutableArray *mArr = [NSMutableArray array];
    for (int i = 0; i < 15; i++) {
      YMModel *mdl = [YMModel new];
      NSString *title = i%2 ? @"支持Selected状态换背景色、(按下反馈)高亮态背景色变化的YMBaseButton" : @"监听UIScrollView滚动停止的回调";
      mdl.title = [NSString stringWithFormat:@"%@. %@", @(i), title];
      mdl.isSelected = i == 2 || i == 4; //-test: 第2、4个默认选中
      [mArr addObject:mdl];
    }
    [self.collectionView refreshWithData:mArr];
  });
}




//滚动方向可设置的CollectionView
- (void)initCollectionView1 {
  
  [self.collectionView removeFromSuperview];
  
  [self.view addSubview:({
    
    ZYBaseCollectionView *collectionView =
    [ZYBaseCollectionView collectionCenterAlignViewWithFrame:CGRectMake(0, self.view.bounds.size.height/2, 320, self.view.bounds.size.height/2)
                                                   itemSpace:10 lineSpace:5
                                                   cellClass:[YMCollectionViewCell class] scrollDirection:UICollectionViewScrollDirectionHorizontal];
    //UICollectionViewScrollDirectionHorizontal时 itemSpace是行间距，会 ≥ 设定值10
    //UICollectionViewScrollDirectionVertical时 itemSpace是列间距，会 ≥ 设定值10
    //若要严格按照itemSpace值布局，则从collectionView的宽/高更新上着手，eg: 列数*cellWidth + (列数-1)*itemSpace +contentInset.left + contentInset.right = collectionViewWidth
    
    collectionView.backgroundColor = [UIColor systemGray2Color];
    collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    //collectionView.allowsSelection = NO;
    //collectionView.allowsMultipleSelection = YES;
    //__weak typeof(self) weakSelf = self; //@weakify(self);
    collectionView.selectBlock = ^(BOOL isSelected, NSIndexPath *indexPath) {
      //@strongify(self);
      if (isSelected) {
        NSLog(@" ------- selected: %@", indexPath);
      } else {
        NSLog(@" ------- deSelected: %@", indexPath);
      }
    };
    
    self.collectionView = collectionView;
    collectionView;
  })];
  
  //若使用Mansory布局方式，前面初始化时`collectionCenterAlignViewWithFrame:`传CGRectZero即可
//  [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.edges.mas_equalTo(UIEdgeInsetsZero);
//  }];
  
}

//垂直方向滚动的CollectionView，布局时itemSpace会严格按照设定的值 （苹果api却不是）
- (void)initCollectionView2 {
  
  [self.collectionView removeFromSuperview];
  
  [self.view addSubview:({
    
    ZYBaseCollectionView *collectionView =
    [ZYBaseCollectionView collectionViewLeftAlignWithFrame:CGRectMake(0, self.view.bounds.size.height/2+10, 300, self.view.bounds.size.height/2-10)
                                                   itemSpace:10 lineSpace:5
                                                   cellClass:[YMCollectionViewCell class] ];
    collectionView.backgroundColor = [UIColor systemGray6Color];
    collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    //collectionView.allowsSelection = NO;
    collectionView.allowsMultipleSelection = YES; //-test: 多选
    //__weak typeof(self) weakSelf = self; //@weakify(self);
    collectionView.selectBlock = ^(BOOL isSelected, NSIndexPath *indexPath) {
      //@strongify(self);
      if (isSelected) {
        NSLog(@" ------- selected: %@", indexPath);
      } else {
        NSLog(@" ------- deSelected: %@", indexPath);
      }
    };
    
    __weak typeof(self) weakSelf = self;
    collectionView.shouldSelectBlock = ^BOOL(BOOL isSelected, NSIndexPath *indexPath) {
      //是否允许选中
      if (indexPath.row == 0 && isSelected) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:@"点击第0个想要选中，但被拒绝" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction: [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
        return NO;
      } else if ( indexPath.row == 2 && !isSelected) { //是否允许取选
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:@"点击第2个想要取消选中，但被拒绝" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction: [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
        return NO;
      } else {
        return YES;
      }
    };
    
    self.collectionView = collectionView;
    collectionView;
  })];
  
  //若使用Mansory布局方式，前面初始化时`collectionCenterAlignViewWithFrame:`传CGRectZero即可
//  [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.edges.mas_equalTo(UIEdgeInsetsZero);
//  }];
  
}


@end
  
