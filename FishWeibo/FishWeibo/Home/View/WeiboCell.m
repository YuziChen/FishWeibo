//
//  WeiboCell.m
//  FishWeibo
//
//  Created by clip on 16/10/13.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "WeiboCell.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"
#import "WeiboCellLayout.h"
#import "WXLabel.h"
#import "WXPhotoBrowser.h"
#import "ThemeManage.h"
#import "RegexKitLite.h"
#import "LinkWebViewController.h"
@implementation WeiboCell


//label的懒加载
-(UILabel *)weiboTextLabel{
    if (_weiboTextLabel == nil) {
        
        _weiboTextLabel = [[WXLabel alloc]initWithFrame:CGRectZero];
        
        _weiboTextLabel.font = [UIFont systemFontOfSize:15];
        
        _weiboTextLabel.numberOfLines = 0;
        //签订协议
        _weiboTextLabel.wxLabelDelegate = self;
        
        _weiboTextLabel.linespace = 5;
        
        [self.contentView addSubview:_weiboTextLabel];
    }
    return _weiboTextLabel;
}
////图片的懒加载
//- (UIImageView *)weiboImageView{
//    if (_weiboImageView == nil) {
//        
//        _weiboImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        
//        [self.contentView addSubview:_weiboImageView];
//    }
//    return _weiboImageView;
//}

//转发微博背景懒加载
- (ThemeImageView *)retweetedWeiboBgView{
    if (_retweetedWeiboBgView == nil) {
        
        _retweetedWeiboBgView = [[ThemeImageView alloc]initWithFrame:CGRectZero];
        [self.contentView insertSubview:_retweetedWeiboBgView atIndex:0];        
        _retweetedWeiboBgView.leftCapWidth = 27;
        _retweetedWeiboBgView.topCapHeight = 20;
        _retweetedWeiboBgView.imageName = @"timeline_rt_border_selected_9.png";
        
    }
    return _retweetedWeiboBgView;
}

//转发微博文本懒加载
- (UILabel *)retweetedWeiboLabel{
    if (_retweetedWeiboLabel == nil) {
        _retweetedWeiboLabel = [[WXLabel alloc]initWithFrame:CGRectZero];
        _retweetedWeiboLabel.numberOfLines =0;
        _retweetedWeiboLabel.wxLabelDelegate = self;
        _retweetedWeiboLabel.linespace = 5;
        _retweetedWeiboLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_retweetedWeiboLabel];
    }
    return _retweetedWeiboLabel;
}
#pragma mark -- 图片数组的懒加载
- (NSArray *)imageViewArray{
    if (_imageViewArray == nil) {
        
        NSMutableArray *mArray = [[NSMutableArray alloc]init];
        for (NSInteger i =0 ; i < 9; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self.contentView addSubview: imageView];
            [mArray addObject:imageView];
            
            //添加点击事件
            imageView.userInteractionEnabled =YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapAction:)];
            [imageView addGestureRecognizer:tap];
        }
        _imageViewArray = [mArray copy];
    }
    return _imageViewArray;
}

- (void)awakeFromNib {
    //设置图片圆角
    _userImage.layer.cornerRadius = 5;
    //设置图片边框颜色
    _userImage.layer.borderColor = [[UIColor darkGrayColor]CGColor];
    //设置图片边框粗细
    _userImage.layer.borderWidth = 0.5;
    
    _userImage.layer.masksToBounds = YES;
    
    
    //设置字体颜色，随主题改变而改变
    _userName.colorName = kHomeUserNameTextColor;
    _source.colorName = kHomeTimeLabelTextColor;
    _createTime.colorName = kHomeTimeLabelTextColor;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeNotificationName object:nil];
    
    [self themeChange];
}


- (void)setLayout:(WeiboCellLayout *)layout{
    if ( _layout != layout) {
        _layout = layout;
        
                //设置头像图片
        [_userImage sd_setImageWithURL:[NSURL URLWithString:_layout.model.user.profile_image_url] ];
        //设置用户名
        _userName.text = _layout.model.user.name;
        
        //设置来源
        
        NSMutableString *sourceString = [NSMutableString stringWithFormat:@"%@",_layout.model.source];
        NSArray *array = [sourceString componentsSeparatedByString:@">"];
        if (array.count == 3) {
            sourceString = array [1];
            array = [sourceString componentsSeparatedByString:@"<"];
            _source.text = [NSString stringWithFormat:@"来自:%@",array[0]];
        }else{
            _source.text = nil;
        }

        //设置创建时间
//        _createTime.text = _layout.model.created_at;
        
        //时间格式化符
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        //设置时间格式
        [formatter setDateFormat:@"E M d HH:mm:ss Z yyyy"];
        //设置地理位置为美国
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
        //使用格式化符来获取时间
        NSString *time =_layout.model.created_at;
        NSDate *createTime = [formatter dateFromString:time];
        //计算时间差 =  当前时间 - 创建时间
        NSInteger second = -[createTime timeIntervalSinceNow];
        //转换为其他单位
        NSInteger minute = second/60;    //分钟  <60 输出 xx分钟前
        NSInteger hour =  minute/60;     //小时  <24 输出 xx小时前
        NSInteger day = hour/24;         //天    <7  输出 xx天前
        NSInteger week = day/7;          //周    <4  输出 xx周前
        NSInteger mounth = day/30;       //月    <12 输出 xx月前
        //根据微博创建时间决定输出格式
        if (second < 60) {
            _createTime.text = @"刚刚";
        }else if (minute < 60){
            _createTime.text = [NSString stringWithFormat:@"%li分钟前",minute];
        }else if (hour < 24){
            _createTime.text = [NSString stringWithFormat:@"%li小时前",hour];
        }else if (day < 7){
            _createTime.text = [NSString stringWithFormat:@"%li天前",day];
        }else if (week < 4){
            _createTime.text = [NSString stringWithFormat:@"%li周前",week];
        }else if (mounth < 12){
            _createTime.text = [NSString stringWithFormat:@"%li月前",mounth];
        }else {
            //重新设置时间格式
            [formatter setDateFormat:@"yyyy-MM-dd"];
            //设置时区为当前时区
            [formatter setLocale:[NSLocale currentLocale]];
            //转化时间格式
            _createTime.text = [formatter stringFromDate:createTime];
        }
    }
    
    //--------------------设置微博正文内容及微博图片------------------
    self.weiboTextLabel.text = _layout.model.text;
    self.retweetedWeiboLabel.text = _layout.model.retweeted_status.text;
    
    if (_layout.model.retweeted_status.pic_urls) {
        //如果转发微博有图片
        for (NSInteger i = 0; i < 9 ; i++) {
            UIImageView *imageView = self.imageViewArray[i];
            CGRect frame = [_layout.imageViewFrameArray[i] CGRectValue];
            imageView.frame = frame;
            
            if (i < _layout.model.retweeted_status.pic_urls.count) {
                NSDictionary *dic = _layout.model.retweeted_status.pic_urls[i];
                NSString *str = dic[@"thumbnail_pic"];
                [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
            }
        }
    }else if (_layout.model.bmiddle_pic){
        //如果微博有图片
        for (NSInteger i = 0; i < 9 ; i++) {
            UIImageView *imageView = self.imageViewArray[i];
            CGRect frame = [_layout.imageViewFrameArray[i] CGRectValue];
            imageView.frame = frame;
            
            if (i < _layout.model.pic_urls.count) {
                NSDictionary *dic = _layout.model.pic_urls[i];
                NSString *str = dic[@"thumbnail_pic"];
                [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
            }
        }
    }else{
        for (UIImageView *imageView in self.imageViewArray) {
            imageView.frame = CGRectZero;
        }
    }
    
    //--------------------设置微博正文及图片的位置--------------------
    self.weiboTextLabel.frame = _layout.weiboTextLabelFrame;
    
    //转发微博背景视图
    self.retweetedWeiboBgView.frame = _layout.retweetedWeiboBgViewFrame;
    self.retweetedWeiboLabel.frame = _layout.retweetedTextFrame;
}


#pragma mark -- WXLabelDelegate
//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel;{
    NSString *str = @"(#[^#+]#)|(http(s)?://[a-zA-Z0-9._/-]+)";
    return str;
}
//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
    ThemeManage *manager = [ThemeManage shareManage];
    UIColor *color = [manager themeColorWithName:kLinkColor];
    return  color;
}
//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel{
    return [UIColor orangeColor];
}
//手指离开当前超链接文本响应的协议方法
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
    
    NSString *regex = @"http(s)?://([a-zA-Z0-9._-]+(/)?)+";
    if ([context isMatchedByRegex:regex]) {
    NSURL *url = [NSURL URLWithString:context];
    LinkWebViewController *webVC = [[LinkWebViewController alloc]initWithUrl:url];
    
    [[self navigationController] pushViewController:webVC animated:YES];
    }
}





- (void)themeChange{
    ThemeManage *manager = [ThemeManage shareManage];
     UIColor *color = [manager themeColorWithName:kThemeTextColorName];
    
    self.weiboTextLabel.textColor =color;
    self.retweetedWeiboLabel.textColor =color;
}




#pragma mark - UIView + UINavigationController
- (UINavigationController *)navigationController {
    
    //通过响应者链  来查找导航控制器
    UIResponder *next = self.nextResponder;
    
    while (next) {
        if ([next isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}


#pragma mark -- 大图浏览
- (void)imageViewTapAction:(UITapGestureRecognizer *)tap {
    //获取被点击的图片视图
    UIImageView *imageView = (UIImageView *)tap.view;
    
    NSInteger index = [_imageViewArray indexOfObject:imageView];
    
    if (index == NSNotFound) {
        return;
    }
    //显示图片浏览器
    [WXPhotoBrowser showImageInView:self.window selectImageIndex:index delegate:self];
}
//需要显示的图片的个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser{
    if (_layout.model.retweeted_status.pic_urls.count == 0) {
        return _layout.model.pic_urls.count;
    }else{
        return _layout.model.retweeted_status.pic_urls.count;
    }
}

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    //创建photo对象
    WXPhoto *photo = [[WXPhoto alloc]init];
    
    //设置原始的视图
    photo.srcImageView = _imageViewArray[index];
    
    //设置大图的url地址
    NSString *str;
    if (_layout.model.retweeted_status.pic_urls.count == 0) {
        NSDictionary *dic = _layout.model.pic_urls[index];
        str = dic[@"thumbnail_pic"];
    }else{
        NSDictionary *dic = _layout.model.retweeted_status.pic_urls[index];
        str = dic[@"thumbnail_pic"];
    }
    
    //将缩略图地址手动转化为大图地址
    str = [str stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
    photo.url = [NSURL URLWithString:str];
    return photo;
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
