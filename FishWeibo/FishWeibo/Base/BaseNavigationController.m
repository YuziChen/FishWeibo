//
//  BaseNavigationController.m
//  FishWeibo
//
//  Created by clip on 16/9/29.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏不透明
    self.navigationBar.translucent=NO;
    //监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeNotificationName object:nil];
    CGFloat systemVersion=[[UIDevice currentDevice].systemVersion floatValue];
    
    if (systemVersion>=7.0) {
        NSString *imageName= @"mask_titlebar64.png";
        UIImage *image=[[ThemeManage shareManage]themeImageWithName:imageName];
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }else{
        NSString *imageName =@"mask_titlebar@2x.png";
        
        UIImage *image=[[ThemeManage shareManage]themeImageWithName:imageName];
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    self.navigationBar.shadowImage=[[UIImage alloc]init];
    
    
    //社会导航栏的字体和颜色
    NSDictionary *dic=@{NSFontAttributeName:[UIFont systemFontOfSize:20 weight:8],
                        NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationBar.titleTextAttributes=dic;
}
- (void)themeChange{
    CGFloat systemVersion=[[UIDevice currentDevice].systemVersion floatValue];
    
    if (systemVersion>=7.0) {
        NSString *imageName= @"mask_titlebar64.png";
        UIImage *image=[[ThemeManage shareManage]themeImageWithName:imageName];
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }else{
        NSString *imageName =@"mask_titlebar@2x.png";
        
        UIImage *image=[[ThemeManage shareManage]themeImageWithName:imageName];
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}

//设置状态栏的样式
- (UIStatusBarStyle )preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
