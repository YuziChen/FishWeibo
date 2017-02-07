//
//  EmoticonView.m
//  FishWeibo
//
//  Created by clip on 16/10/22.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "EmoticonView.h"
#import "EmoticonInputView.h"
#import "Emoticons.h"
@implementation EmoticonView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}



- (void)drawRect:(CGRect)rect{
    if (_emoticonArray.count == 0 || _emoticonArray.count>32 ) {
        return;
    }
    for (NSInteger i = 0; i<4; i++) {
        for (NSInteger j =0 ; j<8; j++) {
            //计算frame
            CGRect frame = CGRectMake(KScreenWidth/8 * j, kScrollViewHeight /4 *i, KScreenWidth/8, kScrollViewHeight/4);
            //计算图片下标
            NSInteger index = i * 8 + j;
            //绘制图片
            //绘制完成
            if (index >= _emoticonArray.count) {
                return;
            }
            Emoticons *emoticon = _emoticonArray[index];
            UIImage *image = [UIImage imageNamed:emoticon.png];
            //绘制图片
            [image drawInRect:frame];
        }
    }
}


//点击方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取点击位置
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    //根据坐标值计算是哪一个表情
    NSInteger i = location.x/(KScreenWidth/8);
    NSInteger j = location.y/(kScrollViewHeight/4);
    
    NSInteger index = j * 8 + i ;
    if ( index < _emoticonArray.count) {
        Emoticons *emoticon = _emoticonArray[index];
        
        NSDictionary *dic = @{@"chs":emoticon.chs};
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kEmoticonViewTouchEmoticonNotificationName object:nil userInfo:dic];
    }
}
@end
