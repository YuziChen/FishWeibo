//
//  MoreViewController.m
//  FishWeibo
//
//  Created by clip on 16/9/28.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "MoreViewController.h"
#import "AppDelegate.h"
#import "SDImageCache.h"
@interface MoreViewController ()<UIActionSheetDelegate>

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ThemeImageView *bgimageView=[[ThemeImageView alloc]initWithFrame:self.view.bounds];
    bgimageView.imageName=@"bg_detail.jpg";
    [self.view insertSubview:bgimageView atIndex:0];
    
    
    _image01.imageName=@"more_icon_theme.png";
    _image02.imageName=@"more_icon_feedback.png";
    _image03.imageName=@"more_icon_draft.png";
    _image04.imageName=@"more_icon_about.png";
    
    //设置文本字体
    _label01.colorName =kThemeTextColorName;
    _label02.colorName= kThemeTextColorName;
    _label03.colorName = kThemeTextColorName;
    _label04.colorName =kThemeTextColorName;
    _currentThemeNameLabel.colorName = kThemeTextColorName;
    _cacheLabel.colorName = kThemeTextColorName;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//界面即将显示
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self countCache];
    
    ThemeManage *manager =[ThemeManage shareManage];
    _currentThemeName.text=manager.currenName;
}



//计算缓存大小
- (void)countCache{
    NSUInteger cacheSize = [[SDImageCache sharedImageCache]getSize];
    _cacheSize.text=[NSString stringWithFormat:@"%.1fM",cacheSize/1024/1024.0];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击退出登录单元格
    if ( indexPath.section==2 && indexPath.row==0 ) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    //点击清理缓存单元格
    if (indexPath.section==1 && indexPath.row == 0) {
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"清理缓存" destructiveButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [action showInView:self.view];
    }
}

//提示框选择按钮点击方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self logOutWeibo];
          }
}
//清理缓存提示框点击方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [[SDImageCache sharedImageCache]cleanDisk];
        
        [self countCache];
        
        NSLog(@"清理成功");
    }
}

- (IBAction)logButton:(UIButton *)sender {
        //获取微博对象
        SinaWeibo *fish=KFishWeibo;
        
        //登录
        [fish logIn];
        
        //Oauth 2.0认证

}


//退出登录
- (void)logOutWeibo{
    //获取微博对象
    SinaWeibo *fishWeibo = KFishWeibo;
    //登出
    [fishWeibo logOut];
}
@end
