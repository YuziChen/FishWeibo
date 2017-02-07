//
//  BaseViewController.m
//  FishWeibo
//
//  Created by clip on 16/9/28.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置主题背景
    ThemeImageView *bgimage=[[ThemeImageView alloc]initWithFrame:self.view.bounds];
    bgimage.imageName=@"bg_detail.jpg";
    [self.view insertSubview:bgimage atIndex:0];
    [self customBcakButton];
}


//自定义返回按钮
- (void)customBcakButton{
    if (self.navigationController.viewControllers.count>=2) {
    ThemeButton *backBtn =[ThemeButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(0, 0, 60, 44);
    backBtn.bgimgName=@"titlebar_button_back_9.png";
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    
    //包装成导航栏Item
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    //设置成导航栏左边按钮
    self.navigationItem.leftBarButtonItem=item;
    
    [backBtn addTarget:self action:@selector(backToUp) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)backToUp{
    [self.navigationController popToRootViewControllerAnimated:YES];
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
