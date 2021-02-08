//
//  YWTLineListCell.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/21.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    showCellListLineType = 0,   // 线路
    showCellListTowerType       // 杆塔
}showCellListType;

@interface YWTLineListCell : UITableViewCell
// 类型
@property (nonatomic,assign) showCellListType listType;

@property (nonatomic,strong) NSDictionary *dict;

@end

