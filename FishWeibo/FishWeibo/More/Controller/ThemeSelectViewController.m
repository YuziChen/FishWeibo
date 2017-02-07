//
//  ThemeSelectViewController.m
//  FishWeibo
//
//  Created by clip on 16/10/9.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "ThemeSelectViewController.h"

@interface ThemeSelectViewController ()
{
    UITableView *_tableView;
    UIColor *textColor;
}

@end

@implementation ThemeSelectViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-49-64) style:UITableViewStylePlain];
    
    [self.view addSubview:_tableView];
    
    _tableView.backgroundColor=[UIColor clearColor];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    textColor = [[ThemeManage shareManage]themeColorWithName:kThemeTextColorName];
    if (textColor==nil) {
        textColor=[UIColor blackColor];
    }
    
    //监听主题的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeNotificationName object:nil];
}

- (void)themeChange{
    UIColor *color = [[ThemeManage shareManage]themeColorWithName:kThemeTextColorName];
    textColor = color;
    
    _tableView.separatorColor=[[ThemeManage shareManage]themeColorWithName:kThemeLineColorName];
    
    
    
    //刷新单元格
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -- 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [ThemeManage shareManage].allThemeName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor=[UIColor clearColor];
    }
    
    //获取主题管理对象
    ThemeManage *manage = [ThemeManage shareManage];
    NSDictionary *themeName = manage.allThemeName;
    NSArray *themaKeys = themeName.allKeys;
    NSString *key = themaKeys[indexPath.row];
    
    cell.textLabel.text=key;
    //设置单元格字体颜色
    cell.textLabel.textColor=textColor;
    
    NSString *imageName= [NSString stringWithFormat:@"%@/%@", themeName[key],@"more_icon_theme.png"];
    cell.imageView.image=[UIImage imageNamed:imageName];
    
    //如果当前的单元格是被选中的主题，打钩
    if ([key isEqualToString:manage.currenName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ThemeManage *manager=[ThemeManage shareManage];
    
    NSDictionary *themeDic=manager.allThemeName;
    NSArray *keys=themeDic.allKeys;
    
    NSString *name=keys[indexPath.row];
    
    manager.currenName=name;
    
    [_tableView reloadData];
}

@end
