//
//  UserModel.m
//  FishWeibo
//
//  Created by clip on 16/10/11.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

//用户自定义Key－属性名的映射列表
//当一个Json字典，转化为Model对象时，系统会检查当前类是否实现了modelCustomPropertyMapper方法
//如果实现了此方法，则通过这个方法，来获取一个映射列表
+ (NSDictionary *)modelCustomPropertyMapper{
    
    NSDictionary *dic= @{
                         @"userDescription":@"description"
                         };
    return  dic;
}


@end
