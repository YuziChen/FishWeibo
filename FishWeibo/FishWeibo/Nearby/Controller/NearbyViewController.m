//
//  NearbyViewController.m
//  FishWeibo
//
//  Created by clip on 16/9/28.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "NearbyViewController.h"
#import "PersonViewController.h"
@interface NearbyViewController ()

@end

@implementation NearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (IBAction)nearbyPerson:(UIButton *)sender {
    
    PersonViewController *person = [[PersonViewController alloc]init];
    self.navigationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:person animated:YES];
    
}


- (IBAction)nearbyWeibo:(UIButton *)sender {
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
