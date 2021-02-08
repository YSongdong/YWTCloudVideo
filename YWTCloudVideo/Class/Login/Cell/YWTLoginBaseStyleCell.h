//
//  YWTLoginBaseStyleCell.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/12.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    showBaseStyleCompanyCell = 0, // 公司代码
    showBaseStylePwdCell,         // 密码
    showBaseStyleIphoeCell,        // 电话
    showBaseStyleCodeCell          // 验证码
}showBaseStyleCell;

@protocol YWTLoginBaseStyleCellDelegate <NSObject>
// 点击获取验证码
-(void) selectObtainVCodeBtn;

@end

@interface YWTLoginBaseStyleCell : UITableViewCell

@property (nonatomic,weak) id <YWTLoginBaseStyleCellDelegate>delegate;
// 类型
@property (nonatomic,assign)showBaseStyleCell stypeCell;
// 发送验证码
@property (nonatomic,strong) UIButton *sendCodeBtn;
// 背景色
@property (nonatomic,strong) UIColor *cellBackgrondColor;
//textfield
@property (nonatomic,strong) UITextField *loginTextField;
// 左边默认 image
@property (nonatomic,strong) NSString *leftNormalImageStr;
// textField 提示str
@property (nonatomic,strong) NSString *placeholderStr;

@end


