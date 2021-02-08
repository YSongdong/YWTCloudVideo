//
//  YWTLineTooltipView.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/26.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTLineTooltipView : UIView

@property (nonatomic,strong)  UILabel *showContentLab;

// 点击确定
@property (nonatomic,copy) void(^selectTrueBtn)(void);

@end

NS_ASSUME_NONNULL_END
