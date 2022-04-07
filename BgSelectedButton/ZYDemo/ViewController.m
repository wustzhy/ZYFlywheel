//
//  ViewController.m
//  ZYDemo
//
//  Created by yestinZhao on 2022/4/6.
//

#import "ViewController.h"
#import "YMBaseButton.h"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  

  [self.view addSubview:({
    YMBaseButton *button = [[YMBaseButton alloc] initWithFrame:CGRectMake(0, 100, 100, 60)];
    [button setTitle:@"hello normal" forState:UIControlStateNormal];
    [button setTitle:@"hello selected" forState:UIControlStateSelected];
    //[button setImage:[UIImage imageNamed:@"<#icon#>"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(helloButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    // corner
    button.layer.cornerRadius = button.bounds.size.height / 2;
    button.layer.masksToBounds = YES;
    // border
    button.layer.borderColor = [UIColor blueColor].CGColor;
    button.layer.borderWidth = 1;
    
    //-test
    button.backgroundColor = [UIColor blueColor];
    button.selectedBgColor = [UIColor redColor];
    
    button;
  })];
  
  
}

- (void)helloButtonClick:(UIButton *)button {
  NSLog(@"%s \n -------", __func__);
  
  button.selected = !button.selected;
}


@end
  
