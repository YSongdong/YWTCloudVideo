//
//  AppDelegate.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/7.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "AppDelegate.h"
#import "YWTLoginViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "YWTMineViewController.h"
#import "YWTLineViewController.h"
#import "YWTMessageViewController.h"
#import "YWTMapViewController.h"
#import "YWTTabBarViewController.h"
#import "YWTNaviViewController.h"
#import "YWTVideoListViewController.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //默认刷新样式
    [[KafkaRefreshDefaults standardRefreshDefaults] setHeadDefaultStyle:KafkaRefreshStyleReplicatorDot];
    [[KafkaRefreshDefaults standardRefreshDefaults] setFootDefaultStyle:KafkaRefreshStyleReplicatorDot];
    [[KafkaRefreshDefaults standardRefreshDefaults] setThemeColor:[UIColor colorCommonGreenColor]];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self setupViewController];
    [self.window makeKeyAndVisible];
    // 键盘自动上
    [IQKeyboardManager sharedManager].enable = YES;
    //极光推送
    [self registerJPUHSerVice:launchOptions];
    
    return YES;
}

- (void)checkLogin {
    self.window.rootViewController = [self setupViewController];
}

- (UIViewController *)setupViewController {
    if (![YWTNowLoginManager judgePassLogin]) {
        YWTLoginViewController *vc = [[YWTLoginViewController alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
        return navi;
    }
    
    // 获取数据
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    YWTLoginModel *model = [YWTLoginModel mj_objectWithKeyValues:dict];
    [YWTNowLoginManager shareInstance].loginModel = model;
    
    NSMutableArray *tabbars = [NSMutableArray array];
    
    YWTMessageViewController *messageVC = [[YWTMessageViewController alloc]init];
    YWTNaviViewController *msgNavi = [[YWTNaviViewController alloc]initWithRootViewController:messageVC];
    [YWTTools controller:messageVC Title:@"消息" tabBarItemImage:@"tabbar_noramlMsg" tabBarItemSelectedImage:@"tabbar_selectMsg"];
    [tabbars addObject:msgNavi];
    
    YWTLineViewController *lineVC = [[YWTLineViewController alloc]init];
    YWTNaviViewController *lineNavi = [[YWTNaviViewController alloc]initWithRootViewController:lineVC];
    [YWTTools controller:lineVC Title:@"线路" tabBarItemImage:@"tabbar_noramlLine" tabBarItemSelectedImage:@"tabbar_selectLine"];
    [tabbars addObject:lineNavi];
    
    YWTMapViewController *mapVC = [[YWTMapViewController alloc]init];
    YWTNaviViewController *mapNavi = [[YWTNaviViewController alloc]initWithRootViewController:mapVC];
    [YWTTools controller:mapVC Title:@"地图" tabBarItemImage:@"tabbar_noramlMap" tabBarItemSelectedImage:@"tabbar_selectMap"];
    [tabbars addObject:mapNavi];
    
    YWTVideoListViewController *videoListVC = [[YWTVideoListViewController alloc]init];
    YWTNaviViewController *videoListNavi = [[YWTNaviViewController alloc]initWithRootViewController:videoListVC];
    [YWTTools controller:videoListVC Title:@"视频" tabBarItemImage:@"tabbar_noramlVideo" tabBarItemSelectedImage:@"tabbar_selectVideo"];
    [tabbars addObject:videoListNavi];
    
    YWTMineViewController *mineVC = [[YWTMineViewController alloc]init];
    YWTNaviViewController *mineNavi = [[YWTNaviViewController alloc]initWithRootViewController:mineVC];
    [YWTTools controller:mineVC Title:@"我的" tabBarItemImage:@"tabbar_noramlMine" tabBarItemSelectedImage:@"tabbar_selectMine"];
    [tabbars addObject:mineNavi];
    
    YWTTabBarViewController *tabbar = [[YWTTabBarViewController alloc]init];
    tabbar.viewControllers = tabbars;
    tabbar.tabBar.tintColor = [UIColor colorCommonGreenColor];
    return tabbar;
}

#pragma mark------ 远程通知 ------
//注册极光推送通知
-(void)registerJPUHSerVice:(NSDictionary *)launchOptions {
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert)  categories:nil];
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //注册  0e900577d450f5b96603be7d   7c73b76abb1ef04b7d11942a
    [JPUSHService setupWithOption:launchOptions appKey:@"05c98ff9010d1ae1c8386db3"
                          channel:@"Publish channel"
                 apsForProduction:1
            advertisingIdentifier:nil];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
#pragma mark- JPUSHRegisterDelegate---
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}
// iOS 10 Support  // 自定义消息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    //清除角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    //清除角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
//  iOS 10之前前台没有通知栏
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    
    //  iOS 10之前前台没有通知栏
    if ([UIDevice currentDevice].systemVersion.floatValue < 10.0 && [UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
    }
    [JPUSHService handleRemoteNotification:userInfo];
}

#pragma mark - UISceneSession lifecycle

//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//   
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//  
//}


//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
