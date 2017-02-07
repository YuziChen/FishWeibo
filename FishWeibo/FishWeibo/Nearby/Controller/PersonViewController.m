//
//  PersonViewController.m
//  FishWeibo
//
//  Created by clip on 16/10/21.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "PersonViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WeiboModel.h"
#import "YYModel.h"
#import "WeiboAnnotation.h"
#import "AppDelegate.h"
#import "WeiboAnnotationView.h"
//https://api.weibo.com/2/place/nearby_timeline.json
#define kNearbyWeiboAPI @"place/nearby_timeline.json"

@interface PersonViewController()<MKMapViewDelegate,SinaWeiboRequestDelegate>


@end

@implementation PersonViewController
{
    MKMapView *_mapView;
    NSMutableArray *_weiboArray;
}



- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"附近的人";
    [self createMap];
}


- (void)createMap{
    _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_mapView];
    
    if (KsystemVersion > 8.0) {
        
        CLLocationManager *manager = [[CLLocationManager alloc]init];
        
        [manager requestWhenInUseAuthorization];
    }
    
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    CLLocation *location = userLocation.location;
    
    
    //设置地图显示的范围
    MKCoordinateSpan span = MKCoordinateSpanMake(0.04, 0.04);
    //显示的区域（位置，范围）
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    //设定显示范围
    [_mapView setRegion:region animated:YES];
    
    
    //请求当前位置附近的微博信息
    SinaWeibo *weibo = KFishWeibo;
    
    NSDictionary *dic = @{
                          @"lat":[NSString stringWithFormat:@"%f",location.coordinate.latitude],
                          @"long":[NSString stringWithFormat:@"%f",location.coordinate.longitude]
                          };
    [weibo requestWithURL:kNearbyWeiboAPI params:[dic mutableCopy] httpMethod:@"POST" delegate:self];
}




- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    
    NSArray *array = result[@"statuses"];
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    _weiboArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in array) {
        
        WeiboModel *model = [WeiboModel yy_modelWithDictionary:dic];
        
        //向地图中  添加标注点
        //MKAnnotation 标注位置类，里面保存点的位置，以及需要显示的具体内容（title）
        //创建标注点对象
        WeiboAnnotation *annotation = [[WeiboAnnotation alloc]init];
        
        [mArray addObject:model];
        
        annotation.model = model;
        //通过传入到Annotation中的微博数据，来设置经纬度坐标位置
        [_mapView addAnnotation:annotation];
    }
    _weiboArray = [mArray copy];
    
}

#pragma mark -- 自定义标注图标

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    WeiboAnnotationView *annotationView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
    
    if (annotationView == nil) {
        annotationView = [[WeiboAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    }else{
        annotationView.annotation = annotation;
    }
    return annotationView;
}







@end
