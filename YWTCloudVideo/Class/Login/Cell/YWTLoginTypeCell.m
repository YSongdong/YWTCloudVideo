//
//  YWTLoginTypeCell.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/13.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTLoginTypeCell.h"

@interface YWTLoginTypeCell ()
// 账号登录
@property (nonatomic,strong) UIButton *accountLoginBtn;
// 手机登录
@property (nonatomic,strong) UIButton *iphoneLoginBtn;
// 线条
@property (nonatomic,strong) UIView *lineView;
@end


@implementation YWTLoginTypeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTypeView];
    }
    return self;
}
-(void) createTypeView{
    self.backgroundColor = [UIColor clearColor];
   
    self.accountLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.accountLoginBtn];
    [self.accountLoginBtn setTitle:@"账号登录" forState:UIControlStateNormal];
    [self.accountLoginBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.accountLoginBtn.titleLabel.font = BFont(16);
    [self.accountLoginBtn addTarget:self action:@selector(selectLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    self.accountLoginBtn.tag = 100;
    self.accountLoginBtn.frame = CGRectMake(KSIphonScreenW(85), 15, (KScreenW-KSIphonScreenW(170))/2, 40);

    self.iphoneLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.iphoneLoginBtn];
    [self.iphoneLoginBtn setTitle:@"手机号登录" forState:UIControlStateNormal];
    [self.iphoneLoginBtn setTitleColor:[[UIColor colorTextWhiteColor]colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    self.iphoneLoginBtn.titleLabel.font = BFont(15);
    [self.iphoneLoginBtn addTarget:self action:@selector(selectLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    self.iphoneLoginBtn.tag = 101;
    self.iphoneLoginBtn.frame = CGRectMake(KSIphonScreenW(85)+(KScreenW-KSIphonScreenW(170))/2, 15, (KScreenW-KSIphonScreenW(170))/2, 40);

    UIView *bgLineView = [[UIView alloc]initWithFrame:CGRectMake(KSIphonScreenW(85), CGRectGetMaxY(self.accountLoginBtn.frame)+5, KScreenW-KSIphonScreenW(170), 3)];
    [self addSubview:bgLineView];
    bgLineView.backgroundColor = [[UIColor colorTextWhiteColor]colorWithAlphaComponent:0.15];

    bgLineView.layer.cornerRadius = 3/2;
    bgLineView.layer.masksToBounds = YES;
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(bgLineView.frame), CGRectGetMaxY(self.accountLoginBtn.frame)+5, CGRectGetWidth(self.accountLoginBtn.frame), 3)];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorTextWhiteColor];
    self.lineView.layer.cornerRadius = 3/2;
    self.lineView.layer.masksToBounds = YES;
    
}
// 按钮点击事件
-(void)selectLoginAction:(UIButton*)sender{

    switch (sender.tag-100) {
        case 0:
        {  // 账号登录
            [sender setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
            sender.titleLabel.font =  BFont(16);

            [self.iphoneLoginBtn setTitleColor:[[UIColor colorTextWhiteColor]colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
            self.iphoneLoginBtn.titleLabel.font = BFont(15);
            
            // 回调
            if ([self.delegate respondsToSelector:@selector(selectLoginTypeIndex:)]) {
                [self.delegate selectLoginTypeIndex:0];
            }
            break;
        }
        case 1:
        { // 手机登录
            [sender setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
            sender.titleLabel.font =  BFont(16);

            [self.accountLoginBtn setTitleColor:[[UIColor colorTextWhiteColor]colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
            self.accountLoginBtn.titleLabel.font = BFont(15);
           
            // 回调
            if ([self.delegate respondsToSelector:@selector(selectLoginTypeIndex:)]) {
                [self.delegate selectLoginTypeIndex:1];
            }
            break;
        }
        default:
            break;
    }
}
-(void)setIsAccountLogin:(BOOL)isAccountLogin{
    _isAccountLogin = isAccountLogin;
    if (isAccountLogin) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect viewFrame = self.lineView.frame;
            viewFrame.origin.x = self.accountLoginBtn.frame.origin.x;
            self.lineView.frame = viewFrame;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
               CGRect viewFrame = self.lineView.frame;
               viewFrame.origin.x = self.iphoneLoginBtn.frame.origin.x;;
               self.lineView.frame = viewFrame;
        }];
    }
}

-(void) updateLoginType:(NSString*)type{
    if ([type isEqualToString:@"0"]) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect viewFrame = self.lineView.frame;
            viewFrame.origin.x = self.accountLoginBtn.frame.origin.x;
            self.lineView.frame = viewFrame;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
               CGRect viewFrame = self.lineView.frame;
               viewFrame.origin.x = self.iphoneLoginBtn.frame.origin.x;;
               self.lineView.frame = viewFrame;
        }];
    }
}

-(void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
