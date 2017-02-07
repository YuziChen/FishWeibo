//
//  WeiboCell.h
//  FishWeibo
//
//  Created by clip on 16/10/13.
//  Copyright © 2016年 clip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXLabel.h"
#import "WXPhotoBrowser.h"
@class WeiboModel;
@class WeiboCellLayout;
@interface WeiboCell : UITableViewCell<WXLabelDelegate,PhotoBrowerDelegate>
//微博单元格顶部用户信息
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet ThemeLabel *userName;
@property (weak, nonatomic) IBOutlet ThemeLabel *createTime;
@property (weak, nonatomic) IBOutlet ThemeLabel *source;


@property (nonatomic,strong) WXLabel *weiboTextLabel;//微博正文

//九个图片的数组
@property (nonatomic,strong) NSArray *imageViewArray;//微博图片数组

@property (nonatomic,strong) ThemeImageView *retweetedWeiboBgView;//转发微博
@property (nonatomic,strong) WXLabel *retweetedWeiboLabel;//转发微博文本

@property (nonatomic,strong) WeiboCellLayout *layout;

@end
