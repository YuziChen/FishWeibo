//
//  MainTabBarController.m
//  FishWeibo
//
//  Created by clip on 16/9/28.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()
{
    ThemeImageView *_selectImageView;
}

@end

@implementation MainTabBarController


- (instancetype)init{
    self=[super init];
    if (self) {
        [self createViewControllers];
        [self customTabbar];
    }
    return  self;
}

//从故事板读取子控制器
- (void)createViewControllers{
    
    NSArray *nameArray=@[@"Home",
                         @"Message",
                         @"Nearby",
                         @"Center",
                         @"More"];
    
    NSMutableArray *ContrlsArray=[[NSMutableArray alloc]init];
    for (NSString *nameStr in nameArray) {
        
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:nameStr bundle:[NSBundle mainBundle]];
        
        UINavigationController *navi=[storyBoard instantiateViewControllerWithIdentifier:nameStr];
        
        [ContrlsArray addObject:navi];
    }
    self.viewControllers=[ContrlsArray copy];
}

//自定义标签栏按钮
- (void)customTabbar{

    //设置标签栏的背景图片
    ThemeImageView *tabBarBgimageView=[[ThemeImageView alloc]initWithFrame:CGRectMake(0, -5, KScreenWidth, 54)];
    tabBarBgimageView.imageName=@"mask_navbar.png";
    
    [self.tabBar insertSubview:tabBarBgimageView atIndex:0];
    
    //删除原有的按钮
    for (UIView *view in self.tabBar.subviews) {
        
        //判断获得的视图是否是tabbar上的按钮
        Class className=NSClassFromString(@"UITabBarButton");
        
        if ([view isKindOfClass:className]) {
            //是的话删除
            [view removeFromSuperview];
        }
    }
    
    //定义按钮的宽度
    CGFloat btnWidth=KScreenWidth/5;
    
    //自定义添加按钮
    for (NSInteger i=0; i<5; i++) {
        
        ThemeButton *button=[ThemeButton buttonWithType:UIButtonTypeCustom];
        
        button.frame=CGRectMake(i*btnWidth, 0,btnWidth, 49);
        
        button.tag=100+i;
        
        //拼接图片名
        NSString *imageName=[NSString stringWithFormat:@"home_tab_icon_%li.png",i+1];
        
        button.imageName=imageName;
        
        //将按钮添加到tabbar上
        [self.tabBar addSubview:button];
        
        //给按钮添加点击方法
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    //创建选中图片
    _selectImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, 0, btnWidth, 49)];
    _selectImageView.imageName=@"home_bottom_tab_arrow.png";
    
    [self.tabBar insertSubview:_selectImageView atIndex:1];
    
    //标签栏阴影
    self.tabBar.shadowImage=[[UIImage alloc]init];
}

//按钮点击事件，切换视图控制器
- (void)btnAction:(UIButton *)btn{
    
    self.selectedIndex=btn.tag-100;
    //选中图片的移动动画
    [UIView animateWithDuration:0.3 animations:^{
        _selectImageView.center=btn.center;
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
