//
//  AppDelegate.m
//  FishWeibo
//
//  Created by clip on 16/9/28.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "BaseNavigationController.h"
#import "MMDrawerController.h"

#define kWeiboAuthDataKey @"kWeiboAuthDataKey"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window= [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.window makeKeyAndVisible];
    
    MainTabBarController *main=[[MainTabBarController alloc]init];
    
    
    
    //创建左右侧滑视图
    LeftViewController *leftVC = [[LeftViewController alloc]init];
    RightViewController *rightVC = [[RightViewController alloc]init];
    
    //创建左右侧滑导航控制器
    BaseNavigationController *leftNaviC = [[BaseNavigationController alloc]initWithRootViewController:leftVC];
    BaseNavigationController *rightNaviC = [[BaseNavigationController alloc]initWithRootViewController:rightVC];
    
    //创建MMDraw
    MMDrawerController *mmd = [[MMDrawerController alloc]initWithCenterViewController:main leftDrawerViewController:leftNaviC rightDrawerViewController:rightNaviC];
    
    //设置左右侧滑视图宽度
    mmd.maximumLeftDrawerWidth = 180;
    mmd.maximumRightDrawerWidth = 80;
    
    //设置左右侧滑视图打开/关闭方式
    [mmd setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmd setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    //将mmd设为Window的根视图 
    self.window.rootViewController=mmd;
    
    
    [mmd setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
       
        //每次执行需要执行滑动动画时，到manager中获取相应的block
        MMExampleDrawerVisualStateManager *manager = [MMExampleDrawerVisualStateManager sharedManager];
        
        //获取block
        MMDrawerControllerDrawerVisualStateBlock block = [manager drawerVisualStateBlockForDrawerSide:drawerSide];
        
        //执行block
        if (block) {
            block(drawerController,drawerSide,percentVisible);
        }
        
    }];
    
    //初始化微博SDK
    _fishWeibo = [[SinaWeibo alloc]initWithAppKey:@"1113766727"
                                       appSecret:@"a61d0b9c49595270ca1025602f39e12e"
                                  appRedirectURI:@"http://www.baidu.com"
                                      andDelegate:self];
    
    BOOL isAuth = [self readAuthData];
    if (isAuth == NO) {
        [self.fishWeibo logIn];
        NSLog(@"没有登录过，或保存有误，请重新登录");
    }else {
        NSLog(@"已经登陆过，无需再登录");
        NSLog(@"%@",_fishWeibo.accessToken);
    }
    
    return YES;
}


#pragma  mark -- 登录、登出
//登录成功
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    [self saveAvthData];
    NSLog(@"登录成功%@",NSHomeDirectory());
}

//登录失败
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error{
    NSLog(@"登录失败");
}

//退出登录
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo{
    //删除保存的数据
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef removeObjectForKey:kWeiboAuthDataKey];
    NSLog(@"退出成功");
}

#pragma mark -- 保持登录状态
//将登陆后的数据，保存到本地磁盘
//保存认证信息
- (void)saveAvthData{
    //用户令牌  token
    NSString *token = _fishWeibo.accessToken;
    //用户id uid
    NSString *uid = _fishWeibo.userID;
    //认证有效期限
    NSDate *date = _fishWeibo.expirationDate;
    
    NSDictionary *dic = @{@"accessToken":token,
                        @"userID":uid,
                        @"expirationDate":date
                          };
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    //将认证数据保存到属性列表中
    [userDef setObject:dic forKey:kWeiboAuthDataKey];
    
    NSLog(@"%@",dic);
    
    //数据同步，和plist文件同步
    [userDef synchronize];
}

//读取本地登录信息
- (BOOL)readAuthData {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userDef objectForKey:kWeiboAuthDataKey];
    //判断是否有保存的登录信息
    if (dic == nil) {
        return NO;
    }
    
    NSString *token = dic[@"accessToken"];
    NSString *uid = dic[@"userID"];
    NSDate *date = dic[@"expirationDate"];
    
    //判断保存的登录信息是否缺失
    if (token == nil || uid == nil || date == nil ) {
        return NO;
    }
    
    //读取成功使用保存的数据
    _fishWeibo.accessToken=token;
    _fishWeibo.userID=uid;
    _fishWeibo.expirationDate=date;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "yuziChen.FishWeibo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FishWeibo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FishWeibo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
