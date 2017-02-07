//
//  CenterViewController.m
//  FishWeibo
//
//  Created by clip on 16/9/28.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "CenterViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
@interface CenterViewController ()<SinaWeiboRequestDelegate>


@end


@implementation CenterViewController


//-(void)viewWillAppear:(BOOL)animated{
//    //自适应
//    [self frameAdaption];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //请求数据
    [self loadUserData];
    
    [self setCellImage];
    
}

//- (void)frameAdaption{
////    _weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    _weiboBtn.frame = CGRectMake(0, 0, KScreenWidth/3, 60);
//    
//    
//    _attentionBtn.frame = CGRectMake(KScreenWidth/3, 0, KScreenWidth/3, 60);
//    _fansBtn .frame = CGRectMake(KScreenWidth*2/3, 0, KScreenWidth/3, 60);
//    
//    
//    _weiboNumber.frame = CGRectMake(0, 8, KScreenWidth/3, 21);
//    _attentionNumber.frame = CGRectMake(KScreenWidth/3, 8, KScreenWidth, 21);
//    _fansNumber.frame = CGRectMake(KScreenWidth*2/3, 8, KScreenWidth/3, 21);
//    
//    _weibo.frame = CGRectMake(0, 30, KScreenWidth/3, 21);
//    _attention.frame = CGRectMake(KScreenWidth/3, 30, KScreenWidth/3, 21);
//    _fans.frame =CGRectMake(KScreenWidth*2/3, 30, KScreenWidth/3, 21);
//}

#pragma mark -- 获取用户信息
//请求数据
- (void)loadUserData{
    
    //获取微博对象
    SinaWeibo *weibo = KFishWeibo;
    //判断当前扥估信息是否有效
    if (!weibo.isAuthValid) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录，是否现在登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [alert show];
    }
    
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"kWeiboAuthDataKey"];
    NSString *uid = userDic[@"userID"];
    NSDictionary *dic = @{@"uid":uid};
    
    [weibo requestWithURL:@"users/show.json" params:[dic mutableCopy] httpMethod:@"GET" delegate:self];
}

//接收数据
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    _dataDic = [[NSMutableDictionary alloc]init];
    _dataDic = (NSMutableDictionary *)result;
//    NSLog(@"%@",_dataDic);
    
    //填充数据
    [self writeData];

}

#pragma mark -- 填充数据
- (void)writeData{
    //头像图片
    [_headImage sd_setImageWithURL:_dataDic[@"profile_image_url"]];
    //用户名
    _userName.text = _dataDic[@"name"];
    //用户简介
    _userDescription.text = _dataDic[@"description"];
    //用户微博数
    _weiboNumber.text = [NSString stringWithFormat:@"%@", _dataDic[@"statuses_count"]];
    //用户关注数
    _attentionNumber.text = [NSString stringWithFormat:@"%@",_dataDic[@"friends_count"]];
    //用户粉丝数
    _fansNumber.text = [NSString stringWithFormat:@"%@",_dataDic[@"followers_count"]];
}

#pragma mark -- setCellImage
- (void)setCellImage{
    
    _myFriendsImage.image = [UIImage imageNamed:@"bulletscreen_icon_peoplelist@2x.png"];
    
    _myPhotoImage.image = [UIImage imageNamed:@"businesscard_icon_camera@2x.png"];
    
    _myCommentImage.image = [UIImage imageNamed:@"bulletscreen_icon_chattinglist@2x.png"];
    
    _myCollectImage.image = [UIImage imageNamed:@"card_icon_favorite_highlighted@2x.png"];
    
}


#pragma mark -- TableView代理方法









#pragma mark -- 提示框点击方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        SinaWeibo *weibo = KFishWeibo;
        [weibo logIn];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
