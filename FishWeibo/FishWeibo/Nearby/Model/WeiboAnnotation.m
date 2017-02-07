//
//  WeiboAnnotation.m
//  FishWeibo
//
//  Created by clip on 16/10/21.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "WeiboAnnotation.h"
#import "WeiboModel.h"
#import "UserModel.h"

@implementation WeiboAnnotation


- (void)setModel:(WeiboModel *)model{
    if ( _model !=model) {
        _model = model;
    }
    NSDictionary *dic = model.geo;
    
    NSArray *coordinates = dic[@"coordinates"];
    
    if (coordinates.count == 2) {
        CGFloat lat = [[coordinates firstObject] floatValue];
        CGFloat lon = [[coordinates lastObject] floatValue];
        
        //设定当前点坐标位置
        _coordinate = CLLocationCoordinate2DMake(lat, lon);
        
    }
    
    _title = _model.user.name;
    _subtitle = _model.text;
}





@end
