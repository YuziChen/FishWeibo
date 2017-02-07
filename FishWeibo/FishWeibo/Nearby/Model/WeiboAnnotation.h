//
//  WeiboAnnotation.h
//  FishWeibo
//
//  Created by clip on 16/10/21.
//  Copyright © 2016年 clip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WeiboModel.h"

@interface WeiboAnnotation : NSObject <MKAnnotation>


@property (nonatomic,strong) WeiboModel *model;

@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
