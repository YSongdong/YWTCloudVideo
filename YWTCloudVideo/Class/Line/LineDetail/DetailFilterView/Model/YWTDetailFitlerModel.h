//
//  YWTDetailFitlerModel.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/25.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTDetailFitlerModel : NSObject
// 名称
@property (nonatomic,copy) NSString *name;
//
@property (nonatomic,copy) NSString *value;

@property (nonatomic,copy) NSString *Id;

@property (nonatomic,copy) NSString *code;
// 设备id
@property (nonatomic,copy) NSString *deviceId;
// 是否选中
@property (nonatomic,assign) BOOL  isSelect;

@end

NS_ASSUME_NONNULL_END
