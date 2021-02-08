//
//  YWTDataBaseManager.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/20.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWTLoginModel.h"

@interface YWTDataBaseManager : NSObject
// 单例方法
+ (instancetype)sharedManager;
// 保存用户信息
- (BOOL)saveServer:(YWTLoginModel *)model;
// 更新用户信息
- (BOOL)updateLogin:(YWTLoginModel *)model;
// 删除
- (BOOL) delLogin:(YWTLoginModel *)model;
// 通过userId 查询
- (YWTLoginModel*) fetchLoginLoadDataUserId:(NSString*)userId;
// 获取所有数据
-(NSArray*) fetchLoginList;


@end


