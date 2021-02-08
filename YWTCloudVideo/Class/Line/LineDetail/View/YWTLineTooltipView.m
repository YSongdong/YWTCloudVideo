//
//  YWTLineTooltipView.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/26.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTLineTooltipView.h"

@implementation YWTLineTooltipView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createToolView];
    }
    return self;
}
-(void)createToolView{
    WS(weakSelf);
    UIView *bigBgView = [[UIView alloc]init];
    [self addSubview:bigBgView];
    bigBgView.backgroundColor = [UIColor blackColor];
    bigBgView.alpha = 0.35;
    [bigBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorCommonLineColor];
    
    UIView *titleView = [[UIView alloc]init];
    [bgView addSubview:titleView];
    titleView.backgroundColor = [UIColor colorTextWhiteColor];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bgView);
        make.height.equalTo(@(KSIphonScreenH(43)));
    }];
    
    UILabel *showTitleLab = [[UILabel alloc]init];
    [titleView addSubview:showTitleLab];
    showTitleLab.text =@"提示弹窗";
    showTitleLab.font = Font(19);
    showTitleLab.textColor = [UIColor colorCommonBlackColor];
    [showTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView.mas_centerX);
        make.centerY.equalTo(titleView.mas_centerY);
    }];
    
    UIView *contentView = [[UIView alloc]init];
    [bgView addSubview:contentView];
    contentView.backgroundColor = [UIColor colorTextWhiteColor];
    
    self.showContentLab = [[UILabel alloc]init];
    [contentView addSubview:self.showContentLab];
    self.showContentLab.text = @"发送指令给设备进行数据采集?";
    self.showContentLab.textColor = [UIColor colorCommonGrayBlackColor];
    self.showContentLab.font = Font(14);
    self.showContentLab.numberOfLines = 0;
    self.showContentLab.textAlignment = NSTextAlignmentCenter;
    [self.showContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(KSIphonScreenH(15));
        make.left.equalTo(contentView).offset(KSIphonScreenW(15));
        make.right.equalTo(contentView).offset(-KSIphonScreenW(15));
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).offset(1);
        make.left.right.equalTo(titleView);
        make.bottom.equalTo(weakSelf.showContentLab.mas_bottom).offset(KSIphonScreenH(15));
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom ];
    [bgView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorCommonGrayBlackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = Font(14);
    cancelBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).offset(1);
        make.left.equalTo(bgView);
        make.height.equalTo(@(KSIphonScreenH(45)));
    }];
    [cancelBtn addTarget:self action:@selector(selectCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom ];
    [bgView addSubview:trueBtn];
    [trueBtn setTitle:@"确定" forState:UIControlStateNormal];
    [trueBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    trueBtn.titleLabel.font = Font(14);
    trueBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelBtn.mas_right).offset(1);
        make.right.equalTo(bgView);
        make.width.height.equalTo(cancelBtn);
        make.centerY.equalTo(cancelBtn.mas_centerY);
    }];
    [trueBtn addTarget:self action:@selector(selectTrueBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_top);
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(65));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(65));
        make.bottom.equalTo(cancelBtn.mas_bottom);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    bgView.layer.cornerRadius = KSIphonScreenH(14)/2;
    bgView.layer.masksToBounds = YES;
}

-(void)selectCancelBtn:(UIButton *) sender{
    [self removeFromSuperview];
}

-(void)selectTrueBtnAction:(UIButton *) sender{
    self.selectTrueBtn();
}


@end
