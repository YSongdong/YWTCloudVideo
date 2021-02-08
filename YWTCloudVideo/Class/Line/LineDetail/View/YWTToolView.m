//
//  YWTToolView.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/25.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTToolView.h"

@implementation YWTToolView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createToolView];
    }
    return self;
}
-(void) createToolView{
    WS(weakSelf);
    UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:takePhotoBtn];
    [takePhotoBtn setImage:[UIImage imageNamed:@"line_detail_takePhoto"] forState:UIControlStateNormal];
    takePhotoBtn.tag = 200;
    [takePhotoBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [takePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:videoBtn];
    [videoBtn setImage:[UIImage imageNamed:@"line_detail_video"] forState:UIControlStateNormal];
    videoBtn.tag = 201;
    [videoBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(takePhotoBtn.mas_bottom);
        make.centerX.equalTo(takePhotoBtn.mas_centerX);
    }];
    
    UIButton *wakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:wakeBtn];
    [wakeBtn setImage:[UIImage imageNamed:@"line_detail_wake"] forState:UIControlStateNormal];
    wakeBtn.tag = 202;
    [wakeBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [wakeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(videoBtn.mas_bottom);
        make.centerX.equalTo(videoBtn.mas_centerX);
    }];
    
}

-(void)selectBtnAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(selectToolBtnActionTag:)]) {
        [self.delegate selectToolBtnActionTag:sender.tag];
    }
}



@end
