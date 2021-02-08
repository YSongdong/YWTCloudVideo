//
//  YWTLoginModel.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/20.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTLoginModel : NSObject <YYModel>
// 头像
@property (nonatomic,copy)NSString *headImage;
// 公司
@property (nonatomic,copy)NSString *organizationName;
// 电话
@property (nonatomic,copy)NSString *phone;
// 姓名
@property (nonatomic,copy)NSString *realName;
// token
@property (nonatomic,copy)NSString *token;
// 用户ID
@property (nonatomic,copy)NSString *userId;
// 用户姓名
@property (nonatomic,copy)NSString *userName;
//
@property (nonatomic,copy)NSString *weixin;

@end

NS_ASSUME_NONNULL_END
