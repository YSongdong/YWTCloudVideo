//
//  YWTHttpManager.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/7.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTHttpManager.h"

static AFHTTPSessionManager *afnManager = nil;

@implementation YWTHttpManager
// 单例
+(YWTHttpManager*)sharedManager{
    static YWTHttpManager *httpManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpManager = [[super allocWithZone:nil]init];
    });
    return httpManager;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [YWTHttpManager sharedManager];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        afnManager = [AFHTTPSessionManager manager];
        afnManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        //无条件的信任服务器上的证书
        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc]init];
        // 客户端是否信任非法证书
        securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        securityPolicy.validatesDomainName = NO;
        afnManager.securityPolicy = securityPolicy;
        //返回结果支持的类型
        NSArray *contentTypeArr = @[@"application/json",@"text/json",@"text/plain",@"text/html",@"text/xml"];
        afnManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:contentTypeArr];
        // 3.设置超时时间为20s
        afnManager.requestSerializer.timeoutInterval = 20;
    }
    return self;
}

// post 请求数据
-(void)postRequestUrl:(NSString*)url params:(NSDictionary*)param waitView:(UIView *)waitView complateHandle:(void(^)(id showdata,NSString*error))complet{
    // 转换编码
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    //定义需要加载动画的HUD
    __block MBProgressHUD *HUD;
    if (waitView != nil ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            HUD = [MBProgressHUD showHUDAddedTo:waitView animated:YES];
            HUD.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
            HUD.contentColor = [UIColor colorWithWhite:1 alpha:1];
        });
    }
    
    // 将token封装入请求头
    NSString *token = [YWTNowLoginManager judgePassLogin] ? [YWTNowLoginManager shareInstance].loginModel.token : @"";
    NSString *Authorization = [NSString stringWithFormat:@"Bearer %@",token];
    [afnManager.requestSerializer setValue:Authorization forHTTPHeaderField:@"Authorization"];
    // 设备型号
    [afnManager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"Type"];
    // 设备型号
    [afnManager.requestSerializer setValue:[YWTTools getCurrentDeviceModel] forHTTPHeaderField:@"Model"];
    
    [afnManager POST:encodeUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，隐藏HUD并销毁
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        //判断返回的状态，2000即为服务器查询成功，1服务器查询失败
        NSNumber  *code = responseObject[@"code"];
        if ([code integerValue] == 2000) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"data"]= responseObject[@"data"];
            param[@"count"] = responseObject[@"count"];
            param[@"page"] = responseObject[@"page"];
            complet(param,nil);
        }else{
            complet(nil,responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       //网络请求失败，隐藏HUD，服务器响应失败。网络问题 或者服务器崩溃
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        complet(nil,@"网络错误");
    }];
}

-(void)getRequestUrl:(NSString*)url params:(NSDictionary*)param waitView:(UIView *)waitView complateHandle:(void(^)(id showdata,NSString*error))complet{
    // 转换编码
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    //定义需要加载动画的HUD
    __block MBProgressHUD *HUD;
    if (waitView != nil ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            HUD = [MBProgressHUD showHUDAddedTo:waitView animated:YES];
            HUD.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
            HUD.contentColor = [UIColor colorWithWhite:1 alpha:1];
        });
    }
    // 将token封装入请求头
    NSString *token = [YWTNowLoginManager judgePassLogin] ? [YWTNowLoginManager shareInstance].loginModel.token : @"";
    NSString *Authorization = [NSString stringWithFormat:@"Bearer %@",token];
    [afnManager.requestSerializer setValue:Authorization forHTTPHeaderField:@"Authorization"];
    // 设备型号
    [afnManager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"Type"];
    // 设备型号
    [afnManager.requestSerializer setValue:[YWTTools getCurrentDeviceModel] forHTTPHeaderField:@"Model"];
    
    [afnManager GET:encodeUrl parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，隐藏HUD并销毁
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        //判断返回的状态，200即为服务器查询成功，1服务器查询失败
        NSNumber  *code = responseObject[@"code"];
        if ([code integerValue] == 2000) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"data"]= responseObject[@"data"];
            param[@"count"] = responseObject[@"count"];
            param[@"page"] = responseObject[@"page"];
            complet(param,nil);
        }else{
            complet(nil,responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络请求失败，隐藏HUD，服务器响应失败。网络问题 或者服务器崩溃
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        complet(nil,@"网络错误");
    }];
}

// 取消当前请求
- (void)cancelRequest{
    if ([afnManager.tasks count] > 0) {
        [afnManager.tasks makeObjectsPerformSelector:@selector(cancel)];
    }
}

@end
