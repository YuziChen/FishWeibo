//
//  WeiboModel.h
//  FishWeibo
//
//  Created by clip on 16/10/13.
//  Copyright © 2016年 clip. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;

@interface WeiboModel : NSObject


@property (nonatomic,copy) NSString *source;           //微博来源
@property (nonatomic,copy) NSString *created_at;       //发布时间
@property (nonatomic,copy) NSString *idstr;            //微博编号
@property (nonatomic,copy) NSString *text;             //微博文本

@property (nonatomic,assign) NSInteger reposts_count;    //转发数
@property (nonatomic,assign) NSInteger comments_count;   //评论数
@property (nonatomic,assign) NSInteger attitudes_count;  //点赞数

@property (nonatomic,copy) NSURL *thumbnail_pic;         //缩略图地址
@property (nonatomic,copy) NSURL *bmiddle_pic;           //中等尺寸图片地址
@property (nonatomic,copy) NSURL *original_pic;          //原图地址

@property (nonatomic,strong) NSArray *pic_urls;          //微博图片数组

@property (nonatomic,strong) UserModel *user;             //发微博的用户信息
@property (nonatomic,strong) WeiboModel *retweeted_status;//转发的微博

@property (nonatomic,copy) NSDictionary *geo;             //地理位置信息


@end
