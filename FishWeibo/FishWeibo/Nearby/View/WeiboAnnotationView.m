//
//  WeiboAnnotationView.m
//  FishWeibo
//
//  Created by clip on 16/10/21.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiboAnnotation.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"
@implementation WeiboAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self crrateSubView];
    }
    return self;
}

- (void)crrateSubView{
    
    //创建视图
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    _bgImageView.image = [UIImage imageNamed:@"nearby_map_photo_bg.png"];
    [self addSubview:_bgImageView];
    
    _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8.5, 50, 50)];
    //设置圆角边框
    _userImageView.layer.cornerRadius = 5;
    _userImageView.layer.masksToBounds = YES;
    [_bgImageView addSubview:_userImageView];
    _userImageView.backgroundColor = [UIColor blueColor];
    
    //位置标注点在地图中所对应的点 为标注视图的左上角点，要将背景视图的底部中点移动到(0,0)
    _bgImageView.center = CGPointZero;
    _bgImageView.bottom = 0;
    
}


- (void)setAnnotation:(id<MKAnnotation>)annotation{
    [super setAnnotation:annotation];
    
    WeiboAnnotation *weiboAnnotation = (WeiboAnnotation *)annotation;
    WeiboModel *model = weiboAnnotation.model;
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:model.user.profile_image_url]];
    
}







@end
