//
//  WeiboModel.m
//  FishWeibo
//
//  Created by clip on 16/10/13.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"
@implementation WeiboModel


- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    //获取微博正文
    NSString *weiboText = self.text;
    //使用正则表达式
    NSString *regex = @"\\[\\w+\\]";
    
    NSArray *array = [weiboText componentsMatchedByRegex:regex];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    
    NSArray *emoticons = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSString *str in array) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chs=%@",str];
        
        NSArray *result = [emoticons filteredArrayUsingPredicate:predicate];
        
        if (result.count == 1) {
            
            NSDictionary *emoDic = [result firstObject];
            //获取图片名
            NSString *imageName = emoDic[@"png"];
            //拼接字符串
            NSString *iamgeUrl = [NSString stringWithFormat:@"<image url = '%@'>",imageName];
            //字符串的替换
            weiboText = [weiboText stringByReplacingOccurrencesOfRegex:str withString:iamgeUrl];
        }
        
        self.text = [weiboText copy];
    }
    
    
    return YES;
}
@end
