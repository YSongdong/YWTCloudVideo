//
//  YWTLoginBaseStyleCell.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/12.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTLoginBaseStyleCell.h"

@interface YWTLoginBaseStyleCell () <UITextFieldDelegate>
// 背景view
@property (nonatomic,strong) UIView *yBgView;
// 左边UIimageV
@property (nonatomic,strong) UIImageView *leftImageV;
// 清楚按钮
@property (nonatomic,strong) UIButton *clearBtn;
// 查看密码按钮
@property (nonatomic,strong) UIButton *lookBtn;

@end

@implementation YWTLoginBaseStyleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createStyleView];
    }
    return self;
}
-(void) createStyleView{
    self.backgroundColor = [UIColor clearColor];
    
    self.yBgView = [[UIView alloc]init];
    [self addSubview:self.yBgView];
    self.yBgView.backgroundColor = [[UIColor colorTextWhiteColor]colorWithAlphaComponent:0.15];
    WS(weakSelf);
    [self.yBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(10);
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(34));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(34));
        make.height.equalTo(@44);
    }];
    self.yBgView.layer.cornerRadius = 44/2;
    self.yBgView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap)];
    [self.yBgView addGestureRecognizer:tap];
    
    // 左边图片
    self.leftImageV = [[UIImageView alloc]init];
    [self.yBgView addSubview:self.leftImageV];
    self.leftImageV.image = [UIImage imageNamed:@"login_companyCode"];
    self.leftImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.yBgView).offset(KSIphonScreenW(15));
        make.centerY.equalTo(weakSelf.yBgView.mas_centerY);
        make.width.equalTo(@30);
    }];
    
    // 清楚按钮
    self.clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.yBgView addSubview:self.clearBtn];
    [self.clearBtn setImage:[UIImage imageNamed:@"login_del"] forState:UIControlStateNormal];
    [self.clearBtn addTarget:self action:@selector(selectClearBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.yBgView.mas_right).offset(-KSIphonScreenW(21));
        make.centerY.equalTo(weakSelf.yBgView.mas_centerY);
        make.height.equalTo(weakSelf);
        make.width.equalTo(@30);
    }];
    self.clearBtn.hidden = YES;
    
    // 查看按钮
    self.lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.yBgView addSubview:self.lookBtn];
    [self.lookBtn setImage:[UIImage imageNamed:@"login_mmbkj"] forState:UIControlStateNormal];
    [self.lookBtn setImage:[UIImage imageNamed:@"login_mmkj"] forState:UIControlStateSelected];
    [self.lookBtn addTarget:self action:@selector(selectLookBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.clearBtn.mas_left);
        make.centerY.equalTo(weakSelf.clearBtn.mas_centerY);
        make.width.equalTo(@30);
    }];
    self.lookBtn.hidden = YES;
    
    // 发送验证码
    self.sendCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.yBgView addSubview:self.sendCodeBtn];
    [self.sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.sendCodeBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.sendCodeBtn.titleLabel.font = Font(15);
    [self.sendCodeBtn addTarget:self action:@selector(selectSendCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.yBgView.mas_right).offset(-KSIphonScreenW(21));
        make.centerY.equalTo(weakSelf.yBgView.mas_centerY);
        make.height.equalTo(weakSelf.yBgView);
        make.width.equalTo(@80);
    }];
    self.sendCodeBtn.hidden = YES;
    
    self.loginTextField = [[UITextField alloc]init];
    [self.yBgView addSubview:self.loginTextField];
    self.loginTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"公司代码" attributes:@{NSForegroundColorAttributeName:[UIColor colorTextWhiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.loginTextField.textColor = [UIColor colorTextWhiteColor];
    self.loginTextField.font = Font(15);
    self.loginTextField.delegate = self;
    [self.loginTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(KSIphonScreenW(5));
        make.right.equalTo(weakSelf.clearBtn.mas_left);
        make.height.equalTo(weakSelf.yBgView);
        make.centerY.equalTo(weakSelf.leftImageV.mas_centerY);
    }];
}

#pragma mark --- 按钮点击事件 ------
-(void)selectTap{
    [self.loginTextField becomeFirstResponder];
}
// 清除按钮
-(void)selectClearBtnAction:(UIButton*)sender{
    self.loginTextField.text = @"";
}
// 查看
-(void)selectLookBtnAction:(UIButton*)sender{
    sender.selected =! sender.selected;
    
    self.loginTextField.secureTextEntry = sender.selected ? NO : YES;
}
-(void) selectSendCodeAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(selectObtainVCodeBtn)]) {
        [self.delegate selectObtainVCodeBtn];
    }
}
#pragma mark ----- UITextFieldDelegate -----
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    // 显示
    self.clearBtn.hidden = self.stypeCell == showBaseStyleCodeCell ? YES : NO ;
    // 背景y色
    self.yBgView.backgroundColor = [[UIColor colorWithHexString:@"000000"]colorWithAlphaComponent:0.15];
    
    if (self.stypeCell == showBaseStylePwdCell) {
        // 显示密码
        self.lookBtn.hidden = NO;
    }
}
// 结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //隐藏
    self.clearBtn.hidden =YES;
    
    self.lookBtn.hidden = YES;
    
    // 背景y色
    self.yBgView.backgroundColor = [[UIColor colorTextWhiteColor]colorWithAlphaComponent:0.15];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if (self.stypeCell == showBaseStyleIphoeCell) {
        return textField.text.length < 11;
    }
    return YES;
}

#pragma mark   ----- get -----
-(void)setStypeCell:(showBaseStyleCell)stypeCell{
    _stypeCell = stypeCell;
    WS(weakSelf);
    if (stypeCell == showBaseStyleIphoeCell) {
        /* -- 电话  - */
        self.loginTextField.keyboardType = UIKeyboardTypePhonePad;
    }else if (stypeCell == showBaseStylePwdCell){
        /* -- 密码  - */
       self.loginTextField.secureTextEntry = YES;
       
       [self.loginTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(weakSelf.leftImageV.mas_right).offset(KSIphonScreenW(5));
           make.right.equalTo(weakSelf.lookBtn.mas_left);
           make.height.equalTo(weakSelf.yBgView);
           make.centerY.equalTo(weakSelf.yBgView.mas_centerY);
       }];
    }else if (stypeCell == showBaseStyleCodeCell){
       /* -- 验证码  - */
        // 显示获取验证码按钮
        self.sendCodeBtn.hidden = NO;
        
        [self.loginTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.leftImageV.mas_right).offset(KSIphonScreenW(5));
            make.right.equalTo(weakSelf.sendCodeBtn.mas_left);
            make.height.equalTo(weakSelf.yBgView);
            make.centerY.equalTo(weakSelf.yBgView.mas_centerY);
        }];
    }
}
-(void)setLeftNormalImageStr:(NSString *)leftNormalImageStr{
    _leftNormalImageStr = leftNormalImageStr;
    if (leftNormalImageStr != nil || ![leftNormalImageStr isEqualToString:@""]) {
        self.leftImageV.image = [UIImage imageNamed:leftNormalImageStr];
    }
}
-(void)setPlaceholderStr:(NSString *)placeholderStr{
    _placeholderStr = placeholderStr;
    self.loginTextField.placeholder = placeholderStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
