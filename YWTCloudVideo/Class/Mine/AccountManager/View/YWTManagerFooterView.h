//
//  YWTManagerFooterView.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/14.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YWTManagerFooterViewDelegate <NSObject>
// 添加账号
-(void) selectAddAccountBtn;
// 退出账号
-(void) selectOutAccountBtn;

@end

@interface YWTManagerFooterView : UIView

@property (nonatomic,weak) id <YWTManagerFooterViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
