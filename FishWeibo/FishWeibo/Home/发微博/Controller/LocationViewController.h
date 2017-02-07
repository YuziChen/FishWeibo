//
//  LocationViewController.h
//  FishWeibo
//
//  Created by clip on 16/10/19.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "BaseViewController.h"

@protocol LocationViewControllerDelegate <NSObject>

- (void) locationViewControllerReciveLocation:(NSDictionary *)dic;

@end


@interface LocationViewController : BaseViewController


@property (nonatomic,weak)id<LocationViewControllerDelegate> delegate;
@end
