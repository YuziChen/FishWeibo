//
//  LinkWebViewController.m
//  FishWeibo
//
//  Created by clip on 16/10/17.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "LinkWebViewController.h"

@interface LinkWebViewController ()

@end

@implementation LinkWebViewController

-(instancetype)initWithUrl:(NSURL *)url{
    self = [super init];
    if (self) {
        
        _url = url;
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}
//懒加载
-(UIWebView *)webView{
    if (_webView == nil) {
        
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
    }
    return _webView;
}

-(void)setUrl:(NSURL *)url{
    _url = url;
    [self.webView  loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ( self.url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        
        [self.webView loadRequest:request];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
