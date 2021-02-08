//
//  YWTMessageListCell.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/18.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    showMessagelCellListType = 0,   // 消息
    showDetailCellListType          // 线路
}showListCellType;

@interface YWTMessageListCell : UITableViewCell
// 类型
@property (nonatomic,assign) showListCellType cellType;
// 封面图
@property (nonatomic,strong) UIImageView *coverImageV;

@property (nonatomic,strong) NSDictionary *dict;

// 计算高度
+(CGFloat) getWithListCellHeight:(NSDictionary*)dict andCellType:(showListCellType)cellType;

@end


