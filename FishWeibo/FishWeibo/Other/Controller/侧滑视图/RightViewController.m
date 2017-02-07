//
//  RightViewController.m
//  FishWeibo
//
//  Created by clip on 16/10/10.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "RightViewController.h"
#import "BaseNavigationController.h"
#import "SendWeiboViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UIViewController+MMDrawerController.h"
@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建图片背景视图
    ThemeImageView *bgImageView = [[ThemeImageView alloc]initWithFrame:self.view.frame];
    
    bgImageView.imageName = @"mask_bg.jpg";
    
    [self.view insertSubview:bgImageView atIndex:0];
    
    [self creatButton];
    //创建按钮
}

- (void)creatButton{
    
    CGFloat buttonWidth = 50;
    CGFloat space = 15;
    
    for (NSInteger i = 0; i < 5; i++) {
        
        ThemeButton *btn = [ThemeButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(space, i*(buttonWidth+space) + space, buttonWidth, buttonWidth);
        
        [self.view addSubview:btn];
        
        NSString *name = [NSString stringWithFormat:@"newbar_icon_%li.png",i+1];
        
        btn.bgimgName=name;
        if (i == 0) {
            [btn addTarget: self action:@selector(changeToSendAction:) forControlEvents:UIControlEventTouchUpInside];
        }

    }
    
    
    //下面两个按钮
    //点位按钮
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = CGRectMake(space, KScreenHeight-3*(buttonWidth+space), buttonWidth, buttonWidth);
    [mapBtn setImage:[UIImage imageNamed:@"btn_map_location"] forState:UIControlStateNormal];
    
    [self.view addSubview:mapBtn];
    
    //二维码按钮
    UIButton *prBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    prBtn.frame = CGRectMake(space, KScreenHeight-2*(buttonWidth+space), buttonWidth, buttonWidth);
    [prBtn setImage:[UIImage imageNamed:@"qr_btn"] forState:UIControlStateNormal];
    
    [self.view addSubview:prBtn];
    
    
}


- (void)changeToSendAction:(ThemeButton *)btn{
    SendWeiboViewController *send = [[SendWeiboViewController alloc]init];
    
    BaseNavigationController *sendNavi = [[BaseNavigationController alloc]initWithRootViewController:send];
    
    [self presentViewController:sendNavi animated:YES completion:^{
        //弹出动画完成后  收起MMDrawer的侧边栏
        //获取MMDrawer
        MMDrawerController *mmd = self.mm_drawerController;
        //关闭右侧界面
        [mmd closeDrawerAnimated:YES completion:nil];

    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
