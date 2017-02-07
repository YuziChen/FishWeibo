//
//  LocationViewController.m
//  FishWeibo
//
//  Created by clip on 16/10/19.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SinaWeibo.h"
#import "AppDelegate.h"
#import "LocationCell.h"
#import "UIImageView+WebCache.h"
@interface LocationViewController ()<CLLocationManagerDelegate,SinaWeiboRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CLLocationManager *_locationManager;
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    BOOL _isLocation;
}


@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isLocation = NO;
    [self starLocation];
    [self createTableView];
}


- (void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    [self.view addSubview:_tableView];
    
    _tableView.delegate=self;
    _tableView.dataSource = self;
    
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"LocationCell" bundle:[NSBundle mainBundle]];
    [_tableView registerNib:nib forCellReuseIdentifier:@"locationCell"];
}


- (void)starLocation{
    
    _locationManager = [[CLLocationManager alloc]init];
    
    if (KsystemVersion >= 8.0) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    _locationManager.delegate =self;
    
    //开启定位
    [_locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //获取位置信息
    CLLocation *location = locations.firstObject;
    
    
    if (_isLocation == YES) {
        return;
    }
    
    _isLocation = YES;
    //关闭定位
    [manager stopUpdatingLocation];
    
    
    
    CGFloat latitude = location.coordinate.latitude;
    CGFloat longitude = location.coordinate.longitude;
    
    NSDictionary *dic = @{
                          @"lat":[NSString stringWithFormat:@"%lf",latitude],
                          @"long":[NSString stringWithFormat:@"%lf",longitude]
                          };
    
    SinaWeibo *weibo = KFishWeibo;
    
    [weibo requestWithURL:@"place/nearby/pois.json" params:[dic mutableCopy] httpMethod:@"GET" delegate:self];
    
}


- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    
    NSDictionary *dic = result;
    _dataArr = dic[@"pois"];
//    NSLog(@"%@",dic);
    [_tableView reloadData];
    
}

#pragma mark -- 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
//    }
    LocationCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"locationCell"];
    cell.titleLabel.text = _dataArr[indexPath.row][@"title"];
    NSLog(@"%@",_dataArr[indexPath.row][@"title"]);
    cell.addressLabel.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row][@"address"]];
    [cell.image sd_setImageWithURL:_dataArr[indexPath.row][@"icon"]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArr[indexPath.row];
    
    if (_delegate ) {
        [_delegate locationViewControllerReciveLocation:dic];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
