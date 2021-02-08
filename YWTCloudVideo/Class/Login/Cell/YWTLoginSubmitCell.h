//
//  YWTLoginSubmitCell.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/13.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YWTLoginSubmitCellDelegate <NSObject>

// 点击登录
-(void) selectLoginBtnAction;

@end

@interface YWTLoginSubmitCell : UITableViewCell
@property (nonatomic,weak) id <YWTLoginSubmitCellDelegate>delegate;
// 背景view
@property (nonatomic,strong) UIButton *loginBtn;

@end

NS_ASSUME_NONNULL_END
