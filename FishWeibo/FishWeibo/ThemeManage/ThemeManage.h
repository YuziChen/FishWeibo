//
//  ThemeManage.h
//  FishWeibo
//
//  Created by clip on 16/10/7.
//  Copyright © 2016年 clip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ThemeManage : NSObject

@property (nonatomic,copy)NSString *currenName;//当前正在使用的主题名
@property (nonatomic,copy)NSDictionary *allThemeName;

@property (nonatomic,copy)NSDictionary *configColor;

+ (ThemeManage *)shareManage;

- (UIImage *)themeImageWithName:(NSString *)imageName;
- (UIColor *)themeColorWithName:(NSString *)colorName;
@end
