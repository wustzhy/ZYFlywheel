# ZYProjects


## WHY create [ScrollView滚动停止的回调](https://github.com/wustzhy/ZYProjects/tree/master/ScrollDidEndHook)

iOS没有提供`ScrollView滚动停止的回调`的api，然而许多场景是需要它的，eg:
* 淘宝商品信息流列表，达到一定的滚动步进 / 滚动停止时，封面为可播放的商品卡片们，会以一定规律切换播放next
* 滚动停止时，控制一些视图的展示隐藏，如`去顶部`按钮
* ...

SO, 制作一个 放任意处可以使用的轮子。

## Usage
```
 __weak typeof(self) weakSelf = self;
  [self.tableView setScrollDidEnd:^{
    NSLog(@"滚动停止 -------tableView.contentOffset.y: %@", @(weakSelf.tableView.contentOffset.y));
  }];
```

