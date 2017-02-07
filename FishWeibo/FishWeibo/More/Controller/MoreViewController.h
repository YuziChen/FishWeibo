//
//  MoreViewController.h
//  FishWeibo
//
//  Created by clip on 16/9/28.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *cacheSize;

@property (weak, nonatomic) IBOutlet ThemeImageView *image01;

@property (weak, nonatomic) IBOutlet ThemeImageView *image02;
@property (weak, nonatomic) IBOutlet ThemeImageView *image03;

@property (weak, nonatomic) IBOutlet ThemeImageView *image04;
@property (weak, nonatomic) IBOutlet UILabel *currentThemeName;

@property (weak, nonatomic) IBOutlet ThemeLabel *label01;
@property (weak, nonatomic) IBOutlet ThemeLabel *label02;
@property (weak, nonatomic) IBOutlet ThemeLabel *label03;
@property (weak, nonatomic) IBOutlet ThemeLabel *label04;
@property (weak, nonatomic) IBOutlet ThemeLabel *currentThemeNameLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *cacheLabel;


@end
