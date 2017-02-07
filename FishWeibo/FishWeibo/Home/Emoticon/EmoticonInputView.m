//
//  EmoticonInputView.m
//  FishWeibo
//
//  Created by clip on 16/10/22.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "EmoticonInputView.h"
#import "Emoticons.h"
#import "YYModel.h"
#import "EmoticonView.h"


@interface EmoticonInputView ()<UIScrollViewDelegate>

@end

@implementation EmoticonInputView
{
    NSArray *_emoticonArray;
    UIScrollView *scrollView;
    UIPageControl *page;
}

- (instancetype)initWithFrame:(CGRect)frame{
    frame.size.height = kScrollViewHeight+kPageViewHeight;
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadData];
        [self createSubView];
    }
    return self;
}


- (void)loadData{
    //读取文件
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:filePath];
    
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in array) {
        Emoticons *emoticon = [Emoticons yy_modelWithDictionary:dic];
        [mArray addObject:emoticon];
    }
    _emoticonArray = [mArray copy];
    
}

- (void)createSubView{
    //创建滑动视图
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kScrollViewHeight)];
    [self addSubview:scrollView];
    scrollView.delegate = self;
    //开启分页效果
    scrollView.pagingEnabled = YES;
    //隐藏水平竖直滑动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    //计算总页数
    NSInteger pageNum = (_emoticonArray.count-1)/32+1;
    for ( NSInteger i = 0; i < pageNum; i++) {
        
        CGRect frame = CGRectMake(KScreenWidth * i, 0, KScreenWidth, kScrollViewHeight);
        //创建视图
        EmoticonView *view = [[EmoticonView alloc]initWithFrame:frame];
        [scrollView addSubview:view];
        //设置需要显示的内容
        NSRange range = NSMakeRange(i*32, 32);
        if (i == pageNum-1) {
            range.length = _emoticonArray.count - 32*i;
        }
        NSArray *array = [_emoticonArray subarrayWithRange:range];
        view.emoticonArray = array;
    }
    
    //设置活动范围
    scrollView.contentSize = CGSizeMake(pageNum*KScreenWidth, 0);
    
    //创建页码控制器
    page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kScrollViewHeight, KScreenWidth, kPageViewHeight)];
    page.numberOfPages = pageNum;
    page.currentPage = 0;
    [self addSubview:page];
}

#pragma mark -- 计算滑动停止时的页码
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    //获取视图滑动偏移量
    CGFloat offSetX = targetContentOffset->x;
    
    NSInteger pageNum = offSetX/KScreenWidth;
    
    page.currentPage = pageNum;
    
}

@end
