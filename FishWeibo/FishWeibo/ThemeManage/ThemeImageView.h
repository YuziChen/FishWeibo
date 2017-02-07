//
//  ThemeImageView.h
//  FishWeibo
//
//  Created by clip on 16/10/7.
//  Copyright © 2016年 clip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

@property (nonatomic,copy)NSString *imageName;

//图片拉伸点的设置
@property (nonatomic,assign) CGFloat leftCapWidth;
@property (nonatomic,assign) CGFloat topCapHeight;
@end
