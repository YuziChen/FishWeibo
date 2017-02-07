//
//  ThemeLabel.m
//  FishWeibo
//
//  Created by clip on 16/10/10.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "ThemeLabel.h"

@implementation ThemeLabel

//监听通知
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeColorChange) name:kThemeNotificationName object:nil];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeColorChange) name:kThemeNotificationName object:nil];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


//主题切换
- (void)themeColorChange{
    //获取当前主题下的颜色
    UIColor *color=[[ThemeManage shareManage] themeColorWithName:_colorName];
    //设置颜色
    self.textColor=color;
}

//刷新颜色
- (void)setColorName:(NSString *)colorName{
    if (_colorName != colorName) {
        
        _colorName=colorName;
        
        [self themeColorChange];
    }
}
@end
