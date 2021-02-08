//
//  YWTCloudVideo_API.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/13.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#ifndef YWTCloudVideo_API_h
#define YWTCloudVideo_API_h

#define FT_INLINE static inline
FT_INLINE  NSString  *getRequestPath(NSString *act) ;

//#ifdef DEBUG
//#define PUBLISH_DIMAIN_URL @"http://192.168.3.189:9003/"
//#else
#define PUBLISH_DIMAIN_URL @"http://49.4.30.17:9003/"
//#endif

/* ----------------- 登录 ----------------*/
//登录
#define HTTP_APIAPPLOGIN_URL  getRequestPath(@"api/app/login")
// 我的信息数量
#define HTTP_APIWECHATNUMBER_URL  getRequestPath(@"api/wechat/number")
// 查询我的线路信息
#define HTTP_APIWECHATLINELIST_URL  getRequestPath(@"api/wechat/line/list")
// 杆塔信息
#define HTTP_APIWECHATMYTOWERELIST_URL  getRequestPath(@"api/wechat/tower/list")
// 查询杆塔图片综合信息
#define HTTP_APIWECHATMONITORALL_URL  getRequestPath(@"api/wechat/monitor/all")
// 杆塔下对应监拍朝向
#define HTTP_APIWECHATORIENLIST_URL  getRequestPath(@"api/wechat/orien/list")
// 查询朝向下设备list
#define HTTP_APIWECHATDEVICELIST_URL  getRequestPath(@"api/wechat/device/list")
// 发送指令
#define HTTP_APIWECHATMOITORSEND_URL  getRequestPath(@"api/wechat/monitor/send")
/* ----------------- 消息 ----------------*/
// 查询推送消息列表
#define HTTP_APIWECHATMOITORMESSAGE_URL  getRequestPath(@"api/wechat/monitor/message")
// 查询设备通道预置位
#define HTTP_APIWECHATMOITORDEVICECHANNELPRESET_URL  getRequestPath(@"api/wechat/monitor/device/channel/preset")
// 查询杆塔下安装的设备
#define HTTP_APIWECHATMOITORTOWERDEVICE_URL  getRequestPath(@"api/wechat/monitor/tower/device")
FT_INLINE  NSString  * getRequestPath(NSString *op) {
    //修改请求地址
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSString *urlStr ;
    if ([userD objectForKey:@"IP"]) {
        NSMutableDictionary *param = [userD objectForKey:@"IP"];
        NSString *ipUserStr =param[@"IP"];
        NSString *portUserStr = param[@"port"];
        NSMutableString *ipStr = [NSMutableString string];
        if ([ipUserStr isEqualToString:@""]) {
            [ipStr appendString:PUBLISH_DIMAIN_URL];
        }else{
            [ipStr appendString:@"http://"];
            [ipStr appendString:ipUserStr];
        }
        if ([portUserStr isEqualToString:@""]) {
            if (![ipUserStr isEqualToString:@""]) {
                [ipStr appendString:@"/"];
            }
        }else{
            if (![ipUserStr isEqualToString:@""]) {
                [ipStr appendString:@":"];
                [ipStr appendString:portUserStr];
                [ipStr appendString:@"/"];
            }
        }
        urlStr = ipStr.copy;
    }else{
        urlStr = PUBLISH_DIMAIN_URL;
    }
    return [urlStr stringByAppendingFormat:@"%@",op];
}
#endif /* YWTCloudVideo_API_h */
