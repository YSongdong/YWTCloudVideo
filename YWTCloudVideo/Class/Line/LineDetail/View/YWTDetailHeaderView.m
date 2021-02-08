//
//  YWTDetailHeaderView.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/22.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTDetailHeaderView.h"

@interface YWTDetailHeaderView ()

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIButton *photoBtn;

@property (nonatomic,strong) UIButton *videoBtn;

@end



@implementation YWTDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createHeaderView];
    }
    return self;
}
-(void) createHeaderView{
    self.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorCommonF5BgViewColor]];
    WS(weakSekf);
    
    self.bgView = [[UIView alloc]init];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSekf).offset(KSIphonScreenW(80));
        make.right.equalTo(weakSekf).offset(-KSIphonScreenW(80));
        make.height.equalTo(@35);
        make.centerX.equalTo(weakSekf.mas_centerX);
        make.centerY.equalTo(weakSekf.mas_centerY);
    }];
    self.bgView.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.shadowOpacity = 0.1;
    self.bgView.layer.cornerRadius = 35/2;
    
    UIView *samilBgView = [[UIView alloc]init];
    [self.bgView addSubview:samilBgView];
    [samilBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSekf.bgView);
    }];
    samilBgView.layer.cornerRadius = 35/2;
    samilBgView.layer.masksToBounds = YES;

    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:selectBtn];
    [selectBtn setImage:[UIImage imageNamed:@"line_xl_tj"] forState:UIControlStateNormal];
    selectBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSekf).offset(-KSIphonScreenW(15));
        make.height.width.equalTo(@35);
        make.centerY.equalTo(weakSekf.bgView.mas_centerY);
    }];
    selectBtn.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
    selectBtn.layer.shadowOffset = CGSizeMake(0, 0);
    selectBtn.layer.shadowOpacity = 0.1;
    selectBtn.layer.cornerRadius = 35/2;
    [selectBtn addTarget:self action:@selector(selectSiftAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [samilBgView addSubview:self.photoBtn];
    [self.photoBtn setTitle:@" 实习图片" forState:UIControlStateNormal];
    self.photoBtn.titleLabel.font = Font(13);
    [self.photoBtn setTitleColor:[UIColor colorStyleLeDarkWithConstantColor:[[UIColor colorWithHexString:@"#999999"]colorWithAlphaComponent:0.8] normalCorlor:[UIColor colorWithHexString:@"#999999"]] forState:UIControlStateNormal];
    [self.photoBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateSelected];
    [self.photoBtn setImage:[UIImage imageNamed:@"line_xl_sp"] forState:UIControlStateNormal];
    [self.photoBtn setImage:[UIImage imageNamed:@"line_xl_spo"] forState:UIControlStateSelected];
    [self.photoBtn setBackgroundImage:[YWTTools imageWithColor:[UIColor colorCommonGreenColor]] forState:UIControlStateSelected];
    [self.photoBtn setBackgroundImage:[YWTTools imageWithColor:[UIColor colorTextWhiteColor]] forState:UIControlStateNormal];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(samilBgView);
    }];
    [self.photoBtn addTarget:self action:@selector(selectPhotoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.photoBtn.selected = YES;

    self.videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [samilBgView addSubview:self.videoBtn];
    [self.videoBtn setTitle:@" 录像视频" forState:UIControlStateNormal];
    self.videoBtn.titleLabel.font = Font(13);
    [self.videoBtn setTitleColor:[UIColor colorStyleLeDarkWithConstantColor:[[UIColor colorWithHexString:@"#999999"]colorWithAlphaComponent:0.8] normalCorlor:[UIColor colorWithHexString:@"#999999"]] forState:UIControlStateNormal];
    [self.videoBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateSelected];
    [self.videoBtn setImage:[UIImage imageNamed:@"line_xl_tp"] forState:UIControlStateNormal];
    [self.videoBtn setImage:[UIImage imageNamed:@"line_xl_tpo"] forState:UIControlStateSelected];
    [self.videoBtn setBackgroundImage:[YWTTools imageWithColor:[UIColor colorCommonGreenColor]] forState:UIControlStateSelected];
    [self.videoBtn setBackgroundImage:[YWTTools imageWithColor:[UIColor colorTextWhiteColor]] forState:UIControlStateNormal];
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSekf.photoBtn.mas_right);
        make.right.equalTo(samilBgView);
        make.width.height.equalTo(weakSekf.photoBtn);
        make.centerY.equalTo(weakSekf.photoBtn.mas_centerY);
    }];
    [self.videoBtn addTarget:self action:@selector(selectVideoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.videoBtn.selected = NO;
}
-(void)selectPhotoBtnAction:(UIButton*)sender{
    sender.selected = YES;
    self.videoBtn.selected = NO;
    if ([self.delegate respondsToSelector:@selector(selectPhotoOrVideoBtnActionTag:)]) {
        [self.delegate selectPhotoOrVideoBtnActionTag:1];
    }
}
-(void)selectVideoBtnAction:(UIButton*)sender{
    sender.selected = YES;
    self.photoBtn.selected = NO;
    if ([self.delegate respondsToSelector:@selector(selectPhotoOrVideoBtnActionTag:)]) {
        [self.delegate selectPhotoOrVideoBtnActionTag:2];
    }
}
-(void) selectSiftAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(selectSiftBtnAction)]) {
        [self.delegate selectSiftBtnAction];
    }
}



@end
