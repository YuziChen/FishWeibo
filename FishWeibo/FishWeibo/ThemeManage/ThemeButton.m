//
//  ThemeButton.m
//  FishWeibo
//
//  Created by clip on 16/10/9.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "ThemeButton.h"

@implementation ThemeButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [ super initWithFrame:frame];
    if ( self ) {
        //监听通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeNotificationName object:nil];
    }
    return  self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeNotificationName object:nil];
}

//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//改变主题
- (void)themeChange{
    UIImage *image=[[ThemeManage shareManage]themeImageWithName:_imageName];
    UIImage *bgImage=[[ThemeManage shareManage]themeImageWithName:_bgimgName];
    
    [self setImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:bgImage forState:UIControlStateNormal];
    
}

//改变图片名
- (void)setImageName:(NSString *)imageName{
    _imageName =imageName;
    [self themeChange];
}

- (void)setBgimgName:(NSString *)bgimgName{
    _bgimgName = bgimgName;
    [self themeChange];
}
@end
