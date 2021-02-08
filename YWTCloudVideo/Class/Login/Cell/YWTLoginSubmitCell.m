//
//  YWTLoginSubmitCell.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/13.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTLoginSubmitCell.h"

@implementation YWTLoginSubmitCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubmitView];
    }
    return self;
}
-(void) createSubmitView{
    self.backgroundColor = [UIColor clearColor];
    WS(weakSelf);
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.loginBtn];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = BFont(18);
    [self.loginBtn setBackgroundImage:[YWTTools imageWithColor:[UIColor colorTextWhiteColor]] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[YWTTools imageWithColor:[[UIColor colorTextWhiteColor]colorWithAlphaComponent:0.9]] forState:UIControlStateHighlighted];
    [self.loginBtn addTarget:self action:@selector(selectLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(weakSelf).offset(KSIphonScreenH(30));
       make.left.equalTo(weakSelf).offset(KSIphonScreenW(34));
       make.right.equalTo(weakSelf).offset(-KSIphonScreenW(34));
       make.height.equalTo(@44);
    }];
    self.loginBtn.layer.cornerRadius = 44/2;
    self.loginBtn.layer.masksToBounds = YES;
}

-(void) selectLoginAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(selectLoginBtnAction)]) {
        [self.delegate selectLoginBtnAction];
    }
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
