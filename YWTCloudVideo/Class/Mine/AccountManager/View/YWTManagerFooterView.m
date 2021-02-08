//
//  YWTManagerFooterView.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/14.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTManagerFooterView.h"

@implementation YWTManagerFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createFooterView];
    }
    return self;
}
-(void) createFooterView{
    self.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
    WS(weakSelf);
    UIButton *addAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:addAccountBtn];
    [addAccountBtn setTitle:@"添加账号" forState:UIControlStateNormal];
    [addAccountBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    addAccountBtn.titleLabel.font = Font(15);
    [addAccountBtn setBackgroundImage:[YWTTools imageWithColor:[UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStylGrayeDarkColor] normalCorlor:[UIColor colorTextWhiteColor]]] forState:UIControlStateNormal];
    [addAccountBtn setBackgroundImage:[YWTTools imageWithColor:[[UIColor colorTextWhiteColor]colorWithAlphaComponent:0.9]] forState:UIControlStateHighlighted];
    [addAccountBtn addTarget:self action:@selector(selectAddAccountAction:) forControlEvents:UIControlEventTouchUpInside];
    [addAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(42));
        make.height.equalTo(@40);
        make.bottom.equalTo(weakSelf);
    }];
    addAccountBtn.layer.cornerRadius = 40/2;
    addAccountBtn.layer.masksToBounds = YES;
    addAccountBtn.layer.borderWidth = 0.5;
    addAccountBtn.layer.borderColor =  [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStylGrayeDarkColor] normalCorlor:[UIColor colorWithHexString:@"#cccccc"]].CGColor;
    
    UIButton *outAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:outAccountBtn];
    [outAccountBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [outAccountBtn setTitleColor:[UIColor colorWithHexString:@"#ff2b39"] forState:UIControlStateNormal];
    outAccountBtn.titleLabel.font = Font(15);
    [outAccountBtn setBackgroundImage:[YWTTools imageWithColor:[UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStylGrayeDarkColor] normalCorlor:[UIColor colorTextWhiteColor]]] forState:UIControlStateNormal];
    [outAccountBtn setBackgroundImage:[YWTTools imageWithColor:[[UIColor colorTextWhiteColor]colorWithAlphaComponent:0.9]] forState:UIControlStateHighlighted];
    [outAccountBtn addTarget:self action:@selector(selectOutAccountAction:) forControlEvents:UIControlEventTouchUpInside];
    [outAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(42));
        make.left.equalTo(addAccountBtn.mas_right).offset(KSIphonScreenW(18));
        make.width.height.equalTo(addAccountBtn);
        make.centerY.equalTo(addAccountBtn.mas_centerY);
    }];
    outAccountBtn.layer.cornerRadius = 40/2;
    outAccountBtn.layer.masksToBounds = YES;
    outAccountBtn.layer.borderWidth = 0.5;
    outAccountBtn.layer.borderColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStylGrayeDarkColor] normalCorlor:[UIColor colorWithHexString:@"#cccccc"]].CGColor;
    
}

-(void) selectAddAccountAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(selectAddAccountBtn)]) {
        [self.delegate selectAddAccountBtn];
    }
}
-(void) selectOutAccountAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(selectOutAccountBtn)]) {
           [self.delegate selectOutAccountBtn];
       }
}



@end
