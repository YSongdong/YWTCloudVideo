//
//  YWTLineViewController.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/13.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    showTableViewListLineType = 0,   // 线路
    showTableViewListTowerType       // 杆塔
}showTableViewListType;

@interface YWTLineViewController : YWTBaseViewController

@property (nonatomic,strong) NSString *naviTitleStr;
// 线路的杆塔id
@property (nonatomic,strong) NSString *lineId;
// 类型
@property (nonatomic,assign) showTableViewListType listType;
 
@end


