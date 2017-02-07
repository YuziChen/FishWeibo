//
//  SinaWeibo+SendWeibo.h
//  FishWeibo
//
//  Created by clip on 16/10/21.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "SinaWeibo.h"

//自定义block
typedef void(^successBlock) (id result);
typedef void (^filedBlock) (id error);

@interface SinaWeibo (SendWeibo)

- (void)sendWeiboWithText:(NSString *)text parmas:(NSDictionary *)dic image:(UIImage *)image success:(successBlock)success filed:(filedBlock)filed;

@end
