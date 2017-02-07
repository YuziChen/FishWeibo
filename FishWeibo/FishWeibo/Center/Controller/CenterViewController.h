//
//  CenterViewController.h
//  FishWeibo
//
//  Created by clip on 16/9/28.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "BaseViewController.h"

@interface CenterViewController : UITableViewController
@property (nonatomic,strong)NSMutableDictionary *dataDic;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userDescription;

@property (weak, nonatomic) IBOutlet UILabel *weiboNumber;
@property (weak, nonatomic) IBOutlet UILabel *attentionNumber;
@property (weak, nonatomic) IBOutlet UILabel *fansNumber;
@property (weak, nonatomic) IBOutlet UILabel *weibo;
@property (weak, nonatomic) IBOutlet UILabel *attention;
@property (weak, nonatomic) IBOutlet UILabel *fans;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIButton *fansBtn;
@property (weak, nonatomic) IBOutlet UIImageView *myCommentImage;

@property (weak, nonatomic) IBOutlet UIImageView *myFriendsImage;
@property (weak, nonatomic) IBOutlet UIImageView *myPhotoImage;
@property (weak, nonatomic) IBOutlet UIImageView *myCollectImage;


@end
