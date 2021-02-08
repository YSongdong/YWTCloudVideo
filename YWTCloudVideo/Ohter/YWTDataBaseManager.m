//
//  YWTDataBaseManager.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/20.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTDataBaseManager.h"

#import <FMDB.h>


@implementation YWTDataBaseManager{
    // 数据库管理对象
    FMDatabase * _fmdb;
}

// 单例方法
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static YWTDataBaseManager * dbManager = nil;
    dispatch_once(&onceToken, ^{
        if (!dbManager) {
            dbManager = [[YWTDataBaseManager alloc] initPrivate];
        }
    });
    return dbManager;
}

// 重写初始化方法
- (instancetype)init{
    // 1. 抛出异常方式
    @throw [NSException exceptionWithName:@"DataBaseManager init" reason:@"不能调用init方法" userInfo:nil];
    // 2. 断言，判定言论，程序崩溃
//    NSAssert(NO, @"DataBaseManager无法调用该方法");
    return self;
}

// 重新实现初始化方法
- (instancetype)initPrivate{
    if (self = [super init]) {
        [self createDataBase];
    }
    return self;
}
// 初始化数据库
- (void)createDataBase{
    // 获取沙盒路径下的documents路径
    NSArray * documentsPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * dbPath = [[documentsPath firstObject] stringByAppendingPathComponent:@"y_user.sqlite"];
    NSLog(@"DBPath = %@", dbPath);
    if (!_fmdb) {
        // 创建数据库管理对象
        _fmdb = [[FMDatabase alloc] initWithPath:dbPath];
    }
    // 打开数据库
    if ([_fmdb open]) {
        // 创建数据库表
        [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS y_user (userId text PRIMARY KEY , headImage,organizationName,phone,realName,token,userName,weixin);"];
    }
}

// 保存用户信息
- (BOOL)saveServer:(YWTLoginModel *)model{
    NSMutableString *muStr = [[NSMutableString alloc] init];
    [muStr appendString:@"insert into"];
    [muStr appendFormat:@" %@",@"y_user"];
    [muStr appendString:@"(headImage,organizationName,phone,realName,token,userId,userName,weixin)"];
    [muStr appendString:@" values("];
    [muStr appendFormat:@"'%@',",model.headImage];
    [muStr appendFormat:@"'%@',",model.organizationName];
    [muStr appendFormat:@"'%@',",model.phone];
    [muStr appendFormat:@"'%@',",model.realName];
    [muStr appendFormat:@"'%@',",model.token];
    [muStr appendFormat:@"'%@',",model.userId];
    [muStr appendFormat:@"'%@',",model.userName];
    [muStr appendFormat:@"'%@'",model.weixin];
    [muStr appendString:@")"];
    [_fmdb open];
    BOOL success = [_fmdb executeUpdate:muStr];
    [_fmdb close];
    return success;
}

// 更新用户信息
- (BOOL)updateLogin:(YWTLoginModel *)model {
    [_fmdb open];
    NSMutableString *muSql = [[NSMutableString alloc] init];
    [muSql appendFormat:@"update %@ set ",@"y_user"];
    [muSql appendFormat:@"headImage='%@',",model.headImage];
    [muSql appendFormat:@"organizationName='%@',",model.organizationName];
    [muSql appendFormat:@"phone='%@',",model.phone];
    [muSql appendFormat:@"realName='%@',",model.realName];
    [muSql appendFormat:@"token='%@',",model.token];
    [muSql appendFormat:@"userId='%@',",model.userId];
    [muSql appendFormat:@"userName='%@',",model.userName];
    [muSql appendFormat:@"weixin='%@',",model.weixin];
    [muSql appendFormat:@" where userId=%@",model.userId];
    BOOL success = [_fmdb executeUpdate:muSql];
    [_fmdb close];
    return success;
}
// 删除
- (BOOL) delLogin:(YWTLoginModel *)model{
    [_fmdb open];
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"DELETE FROM %@ WHERE userId=%@",@"y_user",model.userId];
    BOOL success = [_fmdb executeUpdate:sql];
    [_fmdb close];
    return success;
}

// 获取所有数据
-(NSArray*) fetchLoginList{
    [_fmdb open];
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"select * from %@",@"y_user"];
    FMResultSet *rs = [_fmdb executeQuery:sql];
    NSMutableArray *list = [[NSMutableArray alloc] init];
    while ([rs next]) {
        NSDictionary *dict = rs.resultDictionary;
        YWTLoginModel *model = [[YWTLoginModel alloc]init];
        model.headImage = dict[@"headImage"];
        model.organizationName = dict[@"organizationName"];
        model.phone = dict[@"phone"];
        model.realName = dict[@"realName"];
        model.token = dict[@"token"];
        model.userId = dict[@"userId"];
        model.userName = dict[@"userName"];
        model.weixin = dict[@"weixin"];
        [list addObject:model];
    }
    [_fmdb close];
    return list;
}
// 通过userId 查询
- (YWTLoginModel*) fetchLoginLoadDataUserId:(NSString*)userId{
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"select * FROM %@ WHERE userId=%@",@"y_user",userId];
    [_fmdb open];
    FMResultSet *groupRs = [_fmdb executeQuery:sql];
    YWTLoginModel *model = [[YWTLoginModel alloc]init];
    while ([groupRs next]) {
        NSDictionary *dict = groupRs.resultDictionary;
        model.headImage = dict[@"headImage"];
        model.organizationName = dict[@"organizationName"];
        model.phone = dict[@"phone"];
        model.realName = dict[@"realName"];
        model.token = dict[@"token"];
        model.userId = dict[@"userId"];
        model.userName = dict[@"userName"];
        model.weixin = dict[@"weixin"];
    }
    return model;
}



@end
