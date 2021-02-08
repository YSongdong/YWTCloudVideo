//
//  YWTManagerTableViewCell.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/14.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YWTAccountManagateModel.h"

@interface YWTManagerTableViewCell : UITableViewCell

@property (nonatomic,strong) YWTAccountManagateModel *model;
// 编辑模式  点击删除
@property (nonatomic,copy) void(^selectDel)(void);


@end


