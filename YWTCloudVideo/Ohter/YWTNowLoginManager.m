//
//  YWTSelectServerManager.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/20.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTNowLoginManager.h"

@implementation YWTNowLoginManager

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static id _instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance ;
}
// 保存用户信息
+ (void) saveLoginModel:(NSDictionary*)dict{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:dict forKey:@"Login"];
    //3.强制让数据立刻保存
    [userD synchronize];
}
// 删除用户信息
+ (void) delLoginModel{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    //用户信息
    [userD removeObjectForKey:@"Login"];
    //3.强制让数据立刻保存
    [userD synchronize];
}
// 判断是否登录
+ (BOOL) judgePassLogin{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"Login"]) {
        return YES;
    }else{
        return NO;
    }
}



@end
