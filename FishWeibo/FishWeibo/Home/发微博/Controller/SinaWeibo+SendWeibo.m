//
//  SinaWeibo+SendWeibo.m
//  FishWeibo
//
//  Created by clip on 16/10/21.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "SinaWeibo+SendWeibo.h"
#import "AFNetworking.h"

#define ksendTextWeiboApi @"https://api.weibo.com/2/statuses/update.json"
@implementation SinaWeibo (SendWeibo)


- (void)sendWeiboWithText:(NSString *)text parmas:(NSDictionary *)dic image:(UIImage *)image success:(successBlock)success filed:(filedBlock)filed{
    
    if (!self.isAuthValid) {
        
        return;
    }
    
    
    //判断文本是否为空
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length == 0) {
        
        return;
    }
    
    //access_token 拼接到字典中
    NSMutableDictionary *mDic = [dic mutableCopy];
    
    [mDic setObject:self.accessToken forKey:@"access_token"];
    
    //填入微博正文
    [mDic setObject:text forKey:@"status"];
    
    if ( image) {
        
        
    }else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:ksendTextWeiboApi parameters:[dic copy] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (success) {
                NSLog(@"发送成功");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (filed) {
                NSLog(@"发送失败");
            }
        }];
    }
    
    
    
}
@end
