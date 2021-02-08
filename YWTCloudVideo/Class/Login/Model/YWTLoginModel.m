//
//  YWTLoginModel.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/20.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTLoginModel.h"

@implementation YWTLoginModel

+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"headImage":@"head_image",
        @"realName":@"real_name",
        @"userName":@"username",
        @"userId":@"user_id",
        @"organizationName":@"organization_name"
    };
}




@end
