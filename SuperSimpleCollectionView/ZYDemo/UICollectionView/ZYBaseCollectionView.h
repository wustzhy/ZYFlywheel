//
//  ZYBaseCollectionView.h
//  Mingtian
//
//  Created by yestin on 2018/4/26.
//  Copyright © 2018年 yestin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYBaseCellProtocol.h"


@protocol ZYBaseCollectionViewDelegateProtocol <NSObject>

-(void)out_scrollViewDidScroll:(UIScrollView *)scrollView ;

@end


@interface ZYBaseCollectionView : UICollectionView
/*
 实例化：
    cellClass: 必须 遵循 ZYCellProtocol
 */

/// EqualSpaceFlowLayout 左对齐 垂直方向滚动
+ (instancetype) collectionViewLeftAlignWithFrame:(CGRect)frame
                                        itemSpace:(CGFloat)itemSpace
                                        lineSpace:(CGFloat)lineSpace
                                        cellClass:(Class<ZYBaseCollectionCellProtocol>)cellClass;

/// UICollectionViewFlowLayout 固定间距 【注意：水平方向时 itemSpace、lineSpace颠倒】
+ (instancetype) collectionCenterAlignViewWithFrame:(CGRect)frame
                                          itemSpace:(CGFloat)itemSpace
                                          lineSpace:(CGFloat)lineSpace
                                          cellClass:(Class<ZYBaseCollectionCellProtocol>)cellClass
                                    scrollDirection:(UICollectionViewScrollDirection)scrollDirection;

- (void)refreshWithData:(NSArray *)data; //供给数据 并刷新
- (NSArray *)getData; //获取数据

/**
 isSelected: yes表示选中，no表示取选
 */
@property (nonatomic , copy) void(^selectBlock)(BOOL isSelected, NSIndexPath *indexPath);
@property (nonatomic , copy) BOOL(^shouldSelectBlock)(BOOL isSelected, NSIndexPath *indexPath);

-(NSArray <NSIndexPath *>*)selectedIPs; //选中的cells's indexpaths


//setDelegate:是NS_UNAVAILABLE，使用这个属性，将需要使用的代理方法
@property (nonatomic, weak) id<ZYBaseCollectionViewDelegateProtocol> out_delegate;

- (instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (void)setDelegate:(id<UICollectionViewDelegate>)delegate NS_UNAVAILABLE;
-(void)setDataSource:(id<UICollectionViewDataSource>)dataSource NS_UNAVAILABLE;

@end
