//
//  UserModel.h
//  FishWeibo
//
//  Created by clip on 16/10/11.
//  Copyright © 2016年 clip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic,copy) NSString *screen_name;//用户昵称

@property (nonatomic,copy) NSString *name;

@property (nonatomic,assign) NSInteger friends_count;//关注数量

@property (nonatomic,copy) NSString *location;//所在城市

@property (nonatomic,copy) NSString *userDescription;//简介

@property (nonatomic,assign) NSInteger *followers_count;//粉丝数

@property (nonatomic,assign) NSString *gender;//性别

@property (nonatomic,copy)NSString *profile_image_url;//头像

@property (nonatomic,copy)NSString *profile_url;//微博URL

@property (nonatomic,assign)NSInteger *statuses_count;//微博数

@property (nonatomic,assign)NSInteger *urank;//用户等级



@end
