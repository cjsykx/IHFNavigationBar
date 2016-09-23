//
//  ViewController.m
//  IHFNavigationBar
//
//  Created by chenjiasong on 16/9/18.
//  Copyright © 2016年 Cjson. All rights reserved.
//

#import "ViewController.h"
#import "IHFNavigationBar.h"
#import "IHFBarButtonItem.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationBar.title = @"首页";
    self.navigationBar.titleColor = [UIColor lightGrayColor];
//    [self setTypeOfSideBar];
    [self setRightBarItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTypeOfSideBar {
    
    self.navigationBar.leftBarButtonItemAction = IHFLeftBarButtonItemActionOfShowSideBar;
    self.navigationBar.leftBarTintColor = [UIColor redColor];
    
    CGFloat kSlideBarWidth = 270;
    // Create Content of SideBar
    UIView *sideBarContentview =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSlideBarWidth, self.view.frame.size.height)];
    
    UIButton *aView = [[UIButton alloc] init];
    aView.frame = CGRectMake(30, 30, 30, 30);
    aView.backgroundColor = [UIColor redColor];
    [sideBarContentview addSubview:aView];
    [aView addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
    
    sideBarContentview.backgroundColor = [UIColor lightGrayColor];
    
    self.navigationBar.sideBarContentView = sideBarContentview;
}

- (void)setRightBarItems {
    IHFBarButtonItem *item1 = [[IHFBarButtonItem alloc] initWithTitle:@"游记" target:self action:@selector(didClick:)];
       IHFBarButtonItem *item2 = [[IHFBarButtonItem alloc] initWithTitle:@"右边" target:self action:@selector(didClick:)];
    self.navigationBar.rightBarButtonItems = [NSArray arrayWithObjects:item1,item2, nil];
}

- (void)didClick:(UIButton *)sender {
    NSLog(@"click");
}

@end
