//
//  YWTDetailCommandView.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/29.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YWTDetailFitlerModel.h"
typedef enum {
    showDetailCommandPhotoType = 0, //拍照
    showDetailCommandVideoType,  //视频
    showDetailCommandWakeType    // 唤醒
}showDetailCommandType;

@protocol YWTDetailCommandViewDelegate <NSObject>
// 选中的设备 通道数组 预置位数组
-(void) selectDevice:(YWTDetailFitlerModel*)deciceModel channels:(NSArray*)channels presets:(NSArray*)prsets commandType:(showDetailCommandType)commandType;

@end

@interface YWTDetailCommandView : UIView

@property (nonatomic,weak) id <YWTDetailCommandViewDelegate>delegate;
@property (nonatomic,strong) NSString *towerId;
@property (nonatomic,assign) showDetailCommandType commandType;

@end


