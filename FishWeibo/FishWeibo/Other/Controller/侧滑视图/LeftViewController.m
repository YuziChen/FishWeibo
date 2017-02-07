//
//  LeftViewController.m
//  FishWeibo
//
//  Created by clip on 16/10/10.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "LeftViewController.h"
#import "MMDrawerController.h"
@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    NSInteger selectIndex;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建背景图片视图
    ThemeImageView *bgImageView = [[ThemeImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.imageName=@"mask_bg.jpg";
    [self.view insertSubview:bgImageView atIndex:0];
    
    //初始化数据
    _dataArray = @[@"无",@"滑动",@"滑动&缩放",@"3D旋转",@"视差滑动"];
    selectIndex = 0;
    
    [self createTableView];
}


//创建表视图
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 180, self.view.bounds.size.height)];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    //设置代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark -- 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        //取消选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.text=_dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row == selectIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectIndex = indexPath.row;
    
    [tableView reloadData];
    
    MMExampleDrawerVisualStateManager *manager = [MMExampleDrawerVisualStateManager sharedManager];
    //改变滑动样式
    manager.leftDrawerAnimationType = indexPath.row;
    manager.rightDrawerAnimationType = indexPath.row;
    
}














- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
