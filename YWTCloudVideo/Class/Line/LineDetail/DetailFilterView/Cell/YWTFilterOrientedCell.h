//
//  YWTFilterOriented_Cell.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/22.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YWTDetailFitlerModel.h"


typedef enum {
    showDetailOrienCellType =0, // 筛选
    showDetailCommandCellType,   // 命令
} showDetaOrienCellType;


@interface YWTFilterOrientedCell : UICollectionViewCell
// 类型
@property (nonatomic,assign) showDetaOrienCellType cellType;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,strong) YWTDetailFitlerModel *model;

@end

