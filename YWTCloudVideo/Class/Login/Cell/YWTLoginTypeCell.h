//
//  YWTLoginTypeCell.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/13.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YWTLoginTypeCellDelegate <NSObject>

// 选择登录类型
-(void) selectLoginTypeIndex:(NSInteger)index;

@end


@interface YWTLoginTypeCell : UITableViewCell

@property (nonatomic,weak) id <YWTLoginTypeCellDelegate>delegate;

// 更新登录选择  YES 账号登录 NO 手机号登录  
@property (nonatomic,assign) BOOL isAccountLogin;


@end

NS_ASSUME_NONNULL_END
