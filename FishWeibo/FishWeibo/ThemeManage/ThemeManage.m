//
//  ThemeManage.m
//  FishWeibo
//
//  Created by clip on 16/10/7.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "ThemeManage.h"
#define kCurrentThemeName @"kCurrentThemeName"

static ThemeManage *themeManage = nil;
@implementation ThemeManage

#pragma mark -- 单例类的创建
+ (ThemeManage *)shareManage{
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        if (themeManage==nil) {
            themeManage = [[super allocWithZone:nil]init];
        }
    });
    
    return themeManage;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self shareManage];
}

- (instancetype)copy{
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        _currenName=[[NSUserDefaults standardUserDefaults]objectForKey:kCurrentThemeName];
        if (_currenName==nil) {
            _currenName=@"猫爷";
        }
        
        //加载主题配置列表
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"theme" ofType:@"plist"];
        _allThemeName = [[NSDictionary alloc]initWithContentsOfFile:filePath];
        
        //加载颜色配置文件
        [self loadConfigColor];
    }
    return self;
}

#pragma mark -- 改变主题
- (void)setCurrenName:(NSString *)currenName{
    
    if ( ![_currenName isEqualToString:currenName]) {
        _currenName=[currenName copy];
        
        //每当主题切换，重新加载图片
        [self loadConfigColor];
        
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:kThemeNotificationName object:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:_currenName forKey:kCurrentThemeName];
    }
}

#pragma mark -- 获取图片
- (UIImage *)themeImageWithName:(NSString *)imageName{
    
    //拼接图片名
    NSString *imgName=[NSString stringWithFormat:@"%@/%@",_allThemeName[_currenName],imageName];
    
    return [UIImage imageNamed:imgName];
}


#pragma mark -- 读取config.plist字体颜色文件
- (void)loadConfigColor{
    //获取程序文件包根路径
    NSString *bundlePth = [[NSBundle mainBundle]resourcePath];
    //目标文件路径
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/config.plist",bundlePth,_allThemeName[_currenName]];
    
    //加载文件
    _configColor = [[NSDictionary alloc]initWithContentsOfFile:filePath];
}

//获取颜色
- (UIColor *)themeColorWithName:(NSString *)colorName{
    
    NSDictionary *dic=self.configColor[colorName];
    
    if (dic==nil) {
        return [UIColor blackColor];
    }
    CGFloat red = [[dic objectForKey:@"R"] floatValue];
    CGFloat green = [[dic objectForKey:@"G"] floatValue];
    CGFloat blue = [[dic objectForKey:@"B"] floatValue];
    
    UIColor *color =[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    
    return color;
}
@end
