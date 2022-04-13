//
//  YMChoicesView.m
//  ZYDemo
//
//  Created by yestinZhao on 2022/4/12.
//

#import "YMChoicesView.h"

@interface YMChoicesView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation YMChoicesView

+ (instancetype)view; {
  return [[self alloc]initWithFrame:CGRectMake(0, 88, 300, 300) style:UITableViewStylePlain];
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
  
  self = [super initWithFrame:frame style:style];
  if (self) {
    UITableView *tableView = self;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
  }
  return self;
}



#pragma mark - UITableView delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.choices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
  cell.textLabel.text = [NSString stringWithFormat:@"【%@_%@】 %@", @(indexPath.section), @(indexPath.row), self.choices[indexPath.row][@"title"]];
  cell.textLabel.font =  [UIFont systemFontOfSize:10];
  cell.textLabel.numberOfLines = 0;
  return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 40;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.didSelect) {
    self.didSelect(indexPath);
  }
}

@end
