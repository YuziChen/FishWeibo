//
//  SendWeiboViewController.m
//  FishWeibo
//
//  Created by clip on 16/10/19.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "SendWeiboViewController.h"
#import "BaseNavigationController.h"
#import "LocationViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "EmoticonInputView.h"

#define kToolViewHeight 40
#define kLocationViewHeight 30
#define kSendWeiboTextApi @"statuses/update.json"
@interface SendWeiboViewController ()<LocationViewControllerDelegate,SinaWeiboRequestDelegate>
{
    UITextView *_weiboTextView;
    UIView *_toolView;
    
    NSDictionary *_locationDic;
    
    //定位信息视图
    UIView *_locationView;
    UIImageView *_locationIcon;
    ThemeLabel *_lcoationLabel;
    ThemeButton *_locationBtn;
    
    //表情视图
    EmoticonInputView *_emotionView;
}

@end

@implementation SendWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBtn];
    [self createTextViewAndToolView];
    [self creatlocationView];
    
    //监听表情输入的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resiveEmoticonNotification:) name:kEmoticonViewTouchEmoticonNotificationName object:nil];
}


- (void)createBtn{
    //发送按钮
    ThemeButton *sendBtn = [[ThemeButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    sendBtn.bgimgName = @"titlebar_button_9.png";
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = sendItem;
    [sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //取消按钮
    ThemeButton *backBtn = [[ThemeButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    backBtn.bgimgName = @"titlebar_button_9.png";
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=backItem;

}

- (void)createTextViewAndToolView{
    _weiboTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight -kToolViewHeight-64)];
    _weiboTextView.textColor = [[ThemeManage shareManage]themeColorWithName:kHomeWeiboTextColor];
    _weiboTextView.backgroundColor = [UIColor orangeColor];
    _weiboTextView.font = [UIFont systemFontOfSize:20];
    _weiboTextView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_weiboTextView];
    
    _toolView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
                                                        KScreenWidth, kToolViewHeight)];
    _toolView.backgroundColor = [UIColor clearColor];
    _toolView.top = _weiboTextView.bottom;
    [self.view addSubview:_toolView];
    
    ThemeImageView *toolBg = [[ThemeImageView alloc]initWithFrame:CGRectMake(0,0,
                                                                        KScreenWidth, kToolViewHeight)];
    toolBg.imageName = @"mask_navbar.png";
    [_toolView addSubview:toolBg];
    
    //监听键盘的相关通知，在键盘显示或收回时改变视图的位置大小
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    NSArray *imageNameArr = @[@"compose_toolbar_1.png",@"compose_toolbar_3.png",@"compose_toolbar_4.png",@"compose_toolbar_5.png",@"compose_toolbar_6.png"];
    
    CGFloat btnWidth = KScreenWidth/imageNameArr.count;
    
    for (NSInteger i = 0; i < imageNameArr.count;  i++) {
        ThemeButton *btn = [ThemeButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*btnWidth, 0, btnWidth, kToolViewHeight);
        btn.imageName = imageNameArr[i];
        [_toolView addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(toolViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//
- (void)keyboardWillChangeFrame:(NSNotification *)noti{
    
    //获取键盘的参数
    NSValue *frameValue = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [frameValue CGRectValue];
    
    _toolView.bottom = rect.origin.y-64;
    
    _weiboTextView.height = _toolView.top;
    
    _locationView.bottom = _toolView.top;
    
}

- (void)backBtnAction:(ThemeButton *)btn{
    
    [_weiboTextView resignFirstResponder];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)sendBtnAction:(ThemeButton *)btn{
    
    //字符串点筛选，除去多余的空格，换行符
    NSString *text = [_weiboTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"文本不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (_locationDic != nil) {
        [dic setObject:_locationDic[@"lat"] forKey:@"lat"];
        [dic setObject:_locationDic[@"lon"] forKey:@"long"];
    }
    
    //设置微博正文
    [dic setObject:text forKey:@"status"];
    
    SinaWeibo *weibo = KFishWeibo;
    
    [weibo requestWithURL:kSendWeiboTextApi params:dic httpMethod:@"POST" delegate:self];
    
    
}


- (void)toolViewBtnAction:(ThemeButton *)btn{
    
    if (btn.tag == 3) {
        LocationViewController *location = [[LocationViewController alloc]init];
        location.delegate = self;//设置代理
        [self.navigationController pushViewController:location animated:YES];
    }else if (btn.tag == 4){
        //懒加载表情视图
        if (_emotionView == nil) {
            _emotionView = [[EmoticonInputView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 250)];
            _emotionView.backgroundColor = [UIColor grayColor];
        }
        
        _weiboTextView.inputView = _emotionView.inputView ? nil:_emotionView;
        //重新加载键盘视图，原本显示的是系统自带键盘，重新加载后显示表情视图
        [_weiboTextView reloadInputViews];
        //强制弹出键盘
        [_weiboTextView becomeFirstResponder];
    }
    
}

-(void)locationViewControllerReciveLocation:(NSDictionary *)dic{
    _locationDic = dic;
    [self showLocationMessage:dic];
}

#define mark -- 定位信息视图
- (void)creatlocationView{
    
    _locationView = [[UIView alloc]initWithFrame:CGRectMake(0, _toolView.frame.origin.y-kLocationViewHeight,KScreenWidth, kLocationViewHeight)];
    [self.view addSubview:_locationView];
    _locationView.hidden = YES;//默认隐藏视图
    
    _locationIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, kLocationViewHeight, kLocationViewHeight)];
    [_locationView addSubview:_locationIcon];
    
    _lcoationLabel = [[ThemeLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_locationIcon.frame), 0, 200, kLocationViewHeight)];
    [_locationView addSubview:_lcoationLabel];
    
    _locationBtn = [ThemeButton buttonWithType:UIButtonTypeCustom];
    _locationBtn.frame = CGRectMake(CGRectGetMaxX(_lcoationLabel.frame), 0, kLocationViewHeight, kLocationViewHeight);
    [_locationBtn addTarget:self action:@selector(locationBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _locationBtn.imageName = @"compose_toolbar_clear.png";
    [_locationView addSubview:_locationBtn];
}

- (void)showLocationMessage:(NSDictionary *)dic{
    
    if (dic == nil) {
        _locationView.hidden = YES;
    }else if(dic){
        
        _locationView.hidden = NO;
        
        _lcoationLabel.text = dic[@"title"];
        _lcoationLabel.textColor = [[ThemeManage shareManage]themeColorWithName:kThemeTextColorName];
        
        
        [_locationIcon sd_setImageWithURL:dic[@"icon"]];
        
        CGSize maxSize = CGSizeMake(KScreenWidth-80, kLocationViewHeight);
        
        CGRect frame = [_lcoationLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        
        _lcoationLabel.frame = CGRectMake(15+kLocationViewHeight, 0, frame.size.width+5, kLocationViewHeight);
        _locationBtn.left = _lcoationLabel.right;
        
    }
    
}

- (void)locationBtnAction{
    [self showLocationMessage:nil];
}

- (void)resiveEmoticonNotification:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;
    NSString *chs = dic[@"chs"];
    _weiboTextView.text = [_weiboTextView.text stringByAppendingString:chs];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
