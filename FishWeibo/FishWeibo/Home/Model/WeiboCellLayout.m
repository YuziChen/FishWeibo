//
//  WeiboCellLayout.m
//  FishWeibo
//
//  Created by clip on 16/10/14.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "WeiboCellLayout.h"
#import "WeiboModel.h"
#import "WXLabel.h"

@implementation WeiboCellLayout

-(void)setModel:(WeiboModel *)model{
    
    if (_model == model) {
        return;
    }
    
    _model = model;
    
    _cellHeight = 0;
    
    //计算微博正文label frame
    NSString *textStr = _model.text;
    
//    CGSize maxSize = CGSizeMake(KScreenWidth-20, 1000);
//    //创建属性字典
//    NSDictionary *dic = @{
//                          NSFontAttributeName : [UIFont systemFontOfSize:15]};
//    //获得文本自适应的frame
//    CGRect rect = [textStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
//    //获得文本自适应frame的高度
//    CGFloat weiboTextHeight = rect.size.height;
    CGFloat weiboTextHeight = [WXLabel getTextHeight:[UIFont systemFontOfSize:15].pointSize width:KScreenWidth-20 text:textStr lineSpace:5];
    //计算frame
    CGRect textFrame = CGRectMake(kSpaceWidth, kCellTopViewHeight, KScreenWidth-kSpaceWidth*2, weiboTextHeight);
    
    _weiboTextLabelFrame = textFrame;
    
    
    _cellHeight =kCellTopViewHeight + kSpaceWidth + weiboTextHeight ;
    
  
    
    //-------------------------计算转发微博的frame--------------
    
    if (_model.retweeted_status) {
        
        
        WeiboModel *retweetedWeibo = _model.retweeted_status;
        
        NSString *retweetedWeiboText = retweetedWeibo.text;
//
//        CGSize retTextMaxSize = CGSizeMake(KScreenWidth-kSpaceWidth*4, 1000);
//        
//        NSDictionary *retDic = @{
//                              NSFontAttributeName : [UIFont systemFontOfSize:13]};
//
//        CGRect retWeiboRect = [retweetedWeiboText boundingRectWithSize:retTextMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:retDic context:nil];
//        
//        CGFloat retWeiboHeight = retWeiboRect.size.height;
        CGFloat retWeiboHeight = [WXLabel getTextHeight:[UIFont systemFontOfSize:13].pointSize width:KScreenWidth-kSpaceWidth*4 text:retweetedWeiboText lineSpace:5];
        _retweetedTextFrame = CGRectMake(2*kSpaceWidth, 2*kSpaceWidth+CGRectGetMaxY(textFrame), KScreenWidth-4*kSpaceWidth, retWeiboHeight);
        
        _retweetedWeiboBgViewFrame = CGRectMake(kSpaceWidth, CGRectGetMaxY(textFrame)+kSpaceWidth, KScreenWidth-2*kSpaceWidth, retWeiboHeight+2*kSpaceWidth);
        
        //判断转发微博是否有图片
        
        CGFloat imageHeight = [self layoutNineImageViewWithImageCount:_model.retweeted_status.pic_urls.count ImageTop:CGRectGetMaxY(_retweetedTextFrame)+kSpaceWidth imageViewWidth:KScreenWidth - kSpaceWidth *4];
        
        _retweetedWeiboBgViewFrame.size.height += imageHeight ;

        _cellHeight += retWeiboHeight+3*kSpaceWidth +imageHeight;
        
    }else{
        _retweetedWeiboBgViewFrame = CGRectZero;
        _retweetedTextFrame = CGRectZero;
        
        //-----------------------计算微博图片frame--------------------
        
        _cellHeight += [self layoutNineImageViewWithImageCount:_model.pic_urls.count ImageTop:CGRectGetMaxY(_weiboTextLabelFrame)+kSpaceWidth imageViewWidth:KScreenWidth -2 * kSpaceWidth];
    }
}



//自动布局九个图片
- (CGFloat)layoutNineImageViewWithImageCount:(NSInteger)count ImageTop:(CGFloat)top imageViewWidth:(CGFloat)width{
    
    //确定图片之间的空隙
    CGFloat imageSpace = 5.0;
    
    //判断传入的图片是否合理
    if (count > 9 || count <= 0) {
        _imageViewFrameArray = nil;
        return 0;
    }
    
    //确定图片的行数
    NSInteger imageLine = (count -1)/3 + 1;
    //确定图片的列数
    NSInteger imageColumn = 0;
    //确定图片的宽度
    CGFloat imageWidth = 0;
    
    if (count == 1) {
        imageColumn = 1;
        imageWidth = width * 0.7;
    }else if (count == 2  || count  == 4){
        imageColumn = 2;
        imageWidth = (width - imageSpace)/2;
    }else{
        imageColumn = 3;
        imageWidth = ( width - 2*imageSpace )/3;
    }

    
    CGFloat leftSpace = (KScreenWidth - width)/2;
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0 ; i < imageLine; i++) {
        for (NSInteger j = 0 ; j < imageColumn ; j++) {
            //i 表示行数
            //j 表示列数
            NSInteger index = i*imageColumn+j;
            if ( index >= count  ) {
                break;
            }
            CGRect rect = CGRectMake(leftSpace + (imageWidth + imageSpace )*j, top +(imageWidth + imageSpace)*i , imageWidth, imageWidth);
//            NSLog(@"%@",NSStringFromCGRect(rect));
            //将rect包装成NSValue
            NSValue *value = [NSValue valueWithCGRect:rect];
            [mArray addObject:value];
        }
    }
    
    
    while (mArray.count < 9) {
        NSValue *value = [NSValue valueWithCGRect:CGRectZero];
        [mArray addObject:value];
    }
    
    _imageViewFrameArray = [mArray copy];
    
    
    return imageLine*(imageWidth + imageSpace)+kSpaceWidth;
    
}






















@end
