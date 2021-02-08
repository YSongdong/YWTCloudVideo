//
//  YWTAccountManagateModel.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/14.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTAccountManagateModel : NSObject

@property (nonatomic,copy) NSString *photoUrl;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *compary;

@property (nonatomic,copy) NSString *userId;

// 样式   0 正常  1 选中 2 编辑样式
@property (nonatomic,strong) NSString  *cellStyleModel;

@end

NS_ASSUME_NONNULL_END
