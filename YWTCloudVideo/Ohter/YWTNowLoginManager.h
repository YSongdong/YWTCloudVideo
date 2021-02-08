//
//  YWTSelectServerManager.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/20.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YWTLoginModel.h"

@interface YWTNowLoginManager : NSObject

+ (instancetype)shareInstance;

// 保存用户信息
+ (void) saveLoginModel:(NSDictionary*)dict;
// 删除用户信息
+ (void) delLoginModel;
// 判断是否登录
+ (BOOL) judgePassLogin;

@property (nonatomic,strong) YWTLoginModel *loginModel;

@end


