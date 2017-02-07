//
//  ThemeImageView.m
//  FishWeibo
//
//  Created by clip on 16/10/7.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "ThemeImageView.h"

@implementation ThemeImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if ( self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeNotificationName object:nil];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeNotificationName object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setImageName:(NSString *)imageName{
    _imageName=[imageName copy];
    [self themeChange];
}
- (void)themeChange{
    //获取当前视图在当前主题下的图片
    
    //获取manage对象
    ThemeManage *manage = [ThemeManage shareManage];
    
    UIImage *image =[manage themeImageWithName:self.imageName];
    
    self.image = [image stretchableImageWithLeftCapWidth:_leftCapWidth topCapHeight:_topCapHeight];
}

@end
