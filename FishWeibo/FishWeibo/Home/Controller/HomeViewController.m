//
//  HomeViewController.m
//  FishWeibo
//
//  Created by clip on 16/9/28.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "WeiboModel.h"
#import "YYModel.h"
#import "WeiboCell.h"
#import "WeiboCellLayout.h"
#import "WXRefresh.h"
#import <AVFoundation/AVFoundation.h>
//获取首页微博接口 statuses/home_timeline.json
#define  kGetTimeLineweiboAPI @"statuses/home_timeline.json"


typedef enum{
    WeiboLoadDefultType = 0,
    WeiboFirstLoadType  = 1,
    WeiboLoadNewType    = 2,
    weiboLoadMoreType   = 3
}weiboLoadType;
@interface HomeViewController ()<SinaWeiboRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_weiboArr;
    ThemeImageView *_weiboRefreshView;
    ThemeLabel *_refreshWeiboCountLabel;
    SystemSoundID _msgComeID;
}


@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadWeiboData];
    
    [self createTableView];
    
//     使用系统声音 来播放msgcome.wav 提示音
//     1. 获取音频文件路径
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"msgcome" withExtension:@"wav"];
//     2. 将音频文件，注册为系统声音（必须是系统支持的音频格式，长度不能超过20秒）
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &_msgComeID);
    
}

#pragma mark -- 创建表视图  -  数据源/代理方法
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-49-64) style:UITableViewStylePlain];
    
    [self.view addSubview:_tableView];
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"WeiboCell" bundle:[NSBundle mainBundle]];
    [_tableView registerNib:nib forCellReuseIdentifier:@"WeiboCell"];
    
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _weiboArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell"];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WeiboCellLayout *layout = _weiboArr[indexPath.row];
    
    cell.layout = layout;
    
    return cell;
}

//单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeiboCellLayout *layout = _weiboArr[indexPath.row];
    
    return layout.cellHeight;

}
#pragma mark -- 加载微博数据
- (void)loadWeiboData{
    
    _weiboArr = [[NSMutableArray alloc]init];
    
    //获取微博对象
    SinaWeibo *fishWeibo = KFishWeibo;
    
    //判断当前登录是否有效
    if (![fishWeibo isAuthValid]) {
        //没有登录则需先登录
        [fishWeibo logIn];
        return;
    }
    
    NSDictionary *dic = @{@"count":@"30"};
    
    //发起网络请求
    SinaWeiboRequest *request = [fishWeibo requestWithURL:kGetTimeLineweiboAPI params:[dic mutableCopy]httpMethod:@"GET" delegate:self];
    request.tag = WeiboFirstLoadType;
}

//请求最新微博数据
- (void)requestNewWeiboData{
    if (_weiboArr.count > 0) {
        SinaWeibo *fishWeibo = KFishWeibo;
        
        //获取参数数据
        WeiboCellLayout *layout = _weiboArr.firstObject;
        WeiboModel *model = layout.model;
        
        //请求网络
        NSDictionary *parmas = @{@"since_id":model.idstr};
        
         SinaWeiboRequest *request = [fishWeibo requestWithURL:kGetTimeLineweiboAPI params:[parmas mutableCopy] httpMethod:@"GET" delegate:self];
        request.tag = WeiboLoadNewType;
    }else{
        [self loadWeiboData];
    }
}

//请求更多旧微博
- (void)requestMoreWeiboData{
    if (_weiboArr.count > 0) {
        SinaWeibo *fishWeibo = KFishWeibo;
        
        WeiboCellLayout *layout = _weiboArr.lastObject;
        WeiboModel *model = layout.model;
        
        NSInteger idNum = [model.idstr integerValue];
        
        idNum--;
        
        NSDictionary *parmas = @{@"max_id":[NSString stringWithFormat:@"%li",idNum]};
        
        SinaWeiboRequest *request = [fishWeibo requestWithURL:kGetTimeLineweiboAPI params:[parmas mutableCopy] httpMethod:@"GET" delegate:self];
        request.tag = weiboLoadMoreType;
    }else{
        [self loadWeiboData];
    }
}

#pragma mark -- 接收数据
-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
//    NSLog(@"%@",result);
    
    NSArray *array = result[@"statuses"];
    
    NSMutableArray *modelArray = [[NSMutableArray alloc]init];
    for (NSDictionary *weiboDic in array) {
        //使用YYModel第三方框架
        WeiboModel *model = [WeiboModel yy_modelWithDictionary:weiboDic];
        WeiboCellLayout *layout = [[WeiboCellLayout alloc]init];
        layout.model = model;
        [modelArray addObject:layout];
    }
    
    //根据请求的tag值来判断请求的类型
    if (request.tag == WeiboFirstLoadType) {
        _weiboArr = modelArray;

    }else if (request.tag == WeiboLoadNewType){
        
        NSIndexSet *indexs = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(0, modelArray.count)];
        [_weiboArr insertObjects:modelArray atIndexes:indexs];
        
        [self refreshWeiboViewWithWeiboCount:modelArray.count];
        
    }else if (request.tag == weiboLoadMoreType){
        [_weiboArr addObjectsFromArray:modelArray];
    }else{
        
    }
    //刷新表视图
    [_tableView reloadData];
    
    
    //关闭刷新动画
    [_tableView.pullToRefreshView stopAnimating];
    [_tableView.infiniteScrollingView stopAnimating];
    
    //加载完数据设置下拉刷新
    if (request.tag == WeiboFirstLoadType) {
        
        __weak HomeViewController *weakSelf= self;
        [_tableView addPullDownRefreshBlock:^{
            [weakSelf requestNewWeiboData];
        }];
        
        [_tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf requestMoreWeiboData];
        }];
    }

}

//刷新微博提示框动画
- (void)refreshWeiboViewWithWeiboCount : (NSInteger )count {
    if (count > 0) {
        _weiboRefreshView = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, -40, KScreenWidth, 40)];
        _weiboRefreshView.imageName = @"timeline_notify@2x.png";
        
        [self.view addSubview:_weiboRefreshView];
        
        _refreshWeiboCountLabel = [[ThemeLabel alloc]initWithFrame:_weiboRefreshView.bounds];
        [_weiboRefreshView addSubview:_refreshWeiboCountLabel];
        
        _refreshWeiboCountLabel.textAlignment = NSTextAlignmentCenter;
        _refreshWeiboCountLabel.text = [NSString stringWithFormat:@"%li 条新微博",count];
    //     3. 在显示新微博时，播放提示音
    AudioServicesPlayAlertSound(_msgComeID);
        
    [UIView animateWithDuration:1
                     animations:^{
                         _weiboRefreshView.top = 0;
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
                             _weiboRefreshView.top = -40;
                         } completion:^(BOOL finished) {
                             
                         }];
                     }];
    }
}

-(void)dealloc{
    //     4. 在不需要使用时，注销提示音
    AudioServicesRemoveSystemSoundCompletion(_msgComeID);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
