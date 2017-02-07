//
//  EmoticonInputView.h
//  FishWeibo
//
//  Created by clip on 16/10/22.
//  Copyright © 2016年 clip. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScrollViewHeight 230
#define kPageViewHeight 20
#define kEmoticonWidth KScreenWidth/8
#define kEmoticonHeight kScrollViewHeight/4

//使用通知来传递数据  通知名
#define kEmoticonViewTouchEmoticonNotificationName @"kEmoticonViewTouchEmoticonNotificationName"

@interface EmoticonInputView : UIView

@end
