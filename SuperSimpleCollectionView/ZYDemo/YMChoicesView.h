//
//  YMChoicesView.h
//  ZYDemo
//
//  Created by yestinZhao on 2022/4/12.
//

#import <UIKit/UIKit.h>



@interface YMChoicesView : UITableView

+ (instancetype)view;

@property(nonatomic, copy) void(^didSelect)(NSIndexPath *idp) ;

@property (nonatomic, copy) NSArray <NSDictionary *>*choices;

@end

