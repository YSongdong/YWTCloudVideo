//
//  AppDelegate.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/7.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GlobalAppDelegate (AppDelegate *)[UIApplication sharedApplication].delegate

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)checkLogin;

@end

