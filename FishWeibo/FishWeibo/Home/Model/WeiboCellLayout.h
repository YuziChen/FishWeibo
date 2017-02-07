//
//  WeiboCellLayout.h
//  FishWeibo
//
//  Created by clip on 16/10/14.
//  Copyright © 2016年 clip. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WeiboModel;

#define kCellTopViewHeight 60
#define kSpaceWidth 10
#define kImageViewWidth 200

@interface WeiboCellLayout : NSObject

//输入
@property (nonatomic,strong)WeiboModel *model;

//输出
@property (nonatomic,assign,readonly)CGRect weiboTextLabelFrame;//微博正文label frame

@property (nonatomic,assign,readonly)CGRect retweetedWeiboBgViewFrame;//转发微博frame
@property (nonatomic,assign,readonly)CGRect retweetedTextFrame;//妆发微博文本frame

@property (nonatomic,assign,readonly)CGFloat cellHeight;//微博单元格高度


//九个图片的frame
@property (nonatomic,strong,readonly)NSArray *imageViewFrameArray;
@end
