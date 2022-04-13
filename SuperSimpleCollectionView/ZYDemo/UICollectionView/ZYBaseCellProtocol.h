//
//  ZYBaseCellProtocol.h
//  deepLeaper
//
//  Created by yestin on 2019/9/26.
//  Copyright © 2019 dler. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol ZYBaseCellProtocol <NSObject>

@required
- (void)refreshWithData:(id)data;

@optional
+ (BOOL)shouldSelectWithData:(id)data;
+ (BOOL)shouldDeSelectWithData:(id)data;
-(NSIndexPath *)indexPath;
-(void)setIndexPath:(NSIndexPath *)ip;

@end


#pragma mark - CollectionCell
@protocol ZYBaseCollectionCellProtocol <ZYBaseCellProtocol>

@required
+ (CGSize)sizeWithData:(id)data ;

@end


#pragma mark - TableCell
@protocol ZYBaseTableCellProtocol <ZYBaseCellProtocol>

@required
+ (CGFloat)heightWithData:(id)data ;

@optional
-(void)subviewClickBlock:(void(^)(UIView *))block;
- (void)setExtraData:(id)data; //除item之外的data，另加的用于所有cell的公共数据

@end
