//
//  ZYBaseCollectionView.m
//  Mingtian
//
//  Created by yestin on 2018/4/26.
//  Copyright © 2018年 yestin. All rights reserved.
//

#import "ZYBaseCollectionView.h"
#import "EqualSpaceFlowLayout.h"
#import "NSObject+Selected.h"
#import "NSObject+CGSize.h"

#pragma mark -  CollectionView

@interface ZYBaseCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic , assign) Class cellClass;
@property (nonatomic , strong) NSArray  *data;

@property (nonatomic , assign) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical

@property (nonatomic, strong) NSMutableArray <NSIndexPath *>*selectedIndexPaths;
@end

@implementation ZYBaseCollectionView

#pragma mark - life
// EqualSpaceFlowLayout 左对齐
+ (instancetype) collectionViewLeftAlignWithFrame:(CGRect)frame
                                        itemSpace:(CGFloat)itemSpace
                                        lineSpace:(CGFloat)lineSpace
                                        cellClass:(Class)cellClass;
{
    EqualSpaceFlowLayout* flowLayout = [[EqualSpaceFlowLayout alloc] init];
    flowLayout.betweenOfCell = itemSpace;
    flowLayout.minimumLineSpacing = lineSpace;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //EqualSpaceFlowLayout的contentSize默认inset.bottom = 10 无法更改
    ZYBaseCollectionView * selfView =  [[ZYBaseCollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    
    [selfView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
    selfView.cellClass = cellClass;
    return selfView;
}

// UICollectionViewFlowLayout
+ (instancetype) collectionCenterAlignViewWithFrame:(CGRect)frame
                                          itemSpace:(CGFloat)itemSpace
                                          lineSpace:(CGFloat)lineSpace
                                          cellClass:(Class)cellClass
                                    scrollDirection:(UICollectionViewScrollDirection)scrollDirection;
{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    if (scrollDirection != UICollectionViewScrollDirectionVertical) {
        flowLayout.scrollDirection = scrollDirection;
    }

    flowLayout.minimumInteritemSpacing = itemSpace;
    flowLayout.minimumLineSpacing = lineSpace;
    
    flowLayout.sectionInset = UIEdgeInsetsZero;
    ZYBaseCollectionView * selfView =  [[ZYBaseCollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    
    [selfView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
    selfView.cellClass = cellClass;
    return selfView;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - open
- (void)refreshWithData:(NSArray *)data;
{
    self.data = data;
    [self reloadData];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *ip = [NSIndexPath indexPathForItem:idx inSection:0];
            BOOL needAdd = ( [(NSObject *)obj respondsToSelector:@selector(isSelected)]
                            && ([obj isSelected]) );
            if (needAdd && ![self.selectedIndexPaths containsObject:ip]) {
                [self.selectedIndexPaths addObject:ip];
            }
        }];
    });
}

- (NSArray *)getData {
  return self.data;
}

-(NSArray <NSIndexPath *>*)selectedIPs; {
    return self.selectedIndexPaths;
}

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.data.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {

    UICollectionViewCell <ZYBaseCollectionCellProtocol>*cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.cellClass) forIndexPath:indexPath];
    
    NSObject *item = self.data[indexPath.item];
    [cell refreshWithData:item];
    
    if (item.isSelected) { //第一次 手指单选时，选中另一个会 取消 第一次isSelected==yes的 cell
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSObject *item = self.data[indexPath.item];
    if (item.cacheSize) {
        return item.cacheSize.CGSizeValue;
    }else {
        return [self.cellClass sizeWithData:item];// 需要 #import "ZYBaseCollectionCellProtocol"
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSObject *item = self.data[indexPath.item];
    item.isSelected = YES;
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(ZYBaseCollectionCellProtocol)]) {
        [cell performSelector:@selector(refreshWithData:) withObject:item];
    }
    
    if (![self.selectedIndexPaths containsObject:indexPath]) {
        [self.selectedIndexPaths addObject:indexPath];
    }
    
    if (self.selectBlock) {
        self.selectBlock(YES,indexPath);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSObject *item = self.data[indexPath.item];
    item.isSelected = NO;
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(ZYBaseCollectionCellProtocol)]) {
        [cell performSelector:@selector(refreshWithData:) withObject:item];
    }
    
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        [self.selectedIndexPaths removeObject:indexPath];
    }
    
    if (self.selectBlock) {
        self.selectBlock(NO,indexPath);
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath; {
    
    if (self.shouldSelectBlock) {
        return self.shouldSelectBlock(YES,indexPath);
    }
    
    return YES;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.shouldSelectBlock) {
      return self.shouldSelectBlock(NO,indexPath);
  }
  
  return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.out_delegate) {
        [self.out_delegate out_scrollViewDidScroll:scrollView];
    }
}

-(NSMutableArray <NSIndexPath *>*)selectedIndexPaths {
    if (!_selectedIndexPaths) {
        _selectedIndexPaths = [NSMutableArray array];
    }
    return _selectedIndexPaths;
}
@end

