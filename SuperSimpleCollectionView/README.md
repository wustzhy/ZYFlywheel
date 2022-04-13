## WHAT about me

`SuperSimpleCollectionView` is a super simple way of using collectionView.

When we programme to implement a requirement through CollectionView, `SuperSimpleCollectionView` help us that we no longer need to create XXCollectionView class file. Just Simply need to create XXCollectionViewCell class file, and call the initilize method of `ZYBaseCollectionView`.

> `SuperSimpleCollectionView`, 是一种超级简单使用`collectionView`的方式
> 当通过`collectionView`去实现某种列表需求时，`SuperSimpleCollectionView`帮助我们，不再需要创建各种命名的`XXCollectionView`类文件，仅需创建`XXCollectionViewCell`类文件，然后调用`ZYBaseCollectionView`的初始化方法即可。


## WHY I'm created

I'm created For coding least about CollectionView. For example, decrease all kinds of XXCollectionView files, save code of `UICollectionViewDelegate, UICollectionViewDataSource`'s methods.

> `SuperSimpleCollectionView`的存在，是为了在`CollectionView`上敲最少的代码。例如，减少了各种命名为`XXCollectionView`类的文件，节省了`UICollectionViewDelegate, UICollectionViewDataSource`代理方法的实现。


## Usage

### CollectionView of scrollDirection free with itemSpace not accuracy

初始化 滚动方向可设置的CollectionView，itemSpace设定值 ≤ 实际展示值
```
#import "ZYBaseCollectionView.h"

//初始化
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
  self.collectionView = collectionView;
  collectionView;
})]

//请求数据后，刷新UI
//responseData
[self.collectionView refreshWithData:responseData];
```

### CollectionView of scrollDirection Vertical with itemSpace accuracy

初始化 滚动方向为垂直方向的CollectionView，itemSpace设定值 = 实际展示值
```
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
  self.collectionView = collectionView;
  collectionView;
})];
```

### Features
#### 通过数据(Model)决定cell的默认选中状态
```
//模拟请求
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
```

#### 选中、取选回调
```
//__weak typeof(self) weakSelf = self; //@weakify(self);
collectionView.selectBlock = ^(BOOL isSelected, NSIndexPath *indexPath) {
  //@strongify(self);
  if (isSelected) {
    NSLog(@" ------- selected: %@", indexPath);
  } else {
    NSLog(@" ------- deSelected: %@", indexPath);
  }
};
```

#### 是否允许 选中/取选
```
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
```
