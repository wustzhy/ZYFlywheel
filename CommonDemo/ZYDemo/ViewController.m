//
//  ViewController.m
//  ZYDemo
//
//  Created by yestinZhao on 2022/4/6.
//

#import "ViewController.h"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self configTableView];
  
}


- (void)configTableView {
  [self.view addSubview:({
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 88, 300, 600) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.showsVerticalScrollIndicator = NO;
//    tableView.showsHorizontalScrollIndicator = NO;
    //tableView.sectionFooterHeight = <#_UI(16)#>;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    //tableView.contentInset = UIEdgeInsetsMake(<#_UI(16)#>, 0, <#_UI(16)#>, 0);
//    tableView.scrollEnabled = NO;
    self.tableView = tableView;
    tableView;
  })];
}

#pragma mark - UITableView delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
  cell.textLabel.text = [NSString stringWithFormat:@"%@_%@", @(indexPath.section), @(indexPath.row)];
  return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

@end
  
