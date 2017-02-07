//
//  LinkWebViewController.h
//  FishWeibo
//
//  Created by clip on 16/10/17.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "BaseViewController.h"

@interface LinkWebViewController : BaseViewController

@property (nonatomic ,strong)UIWebView *webView;
@property (nonatomic,strong) NSURL *url;
-(instancetype)initWithUrl:(NSURL *)url;

@end
