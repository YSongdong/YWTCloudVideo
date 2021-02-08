//
//  YWTLoginHeaderView.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/12.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTLoginHeaderView.h"

@interface YWTLoginHeaderView ()

@end


@implementation YWTLoginHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createHeaderView];
    }
    return self;
}
-(void) createHeaderView{
    WS(weakSelf);
    
    UIImageView *logoImagV = [[UIImageView alloc]init];
    [self addSubview:logoImagV];
    logoImagV.image = [UIImage imageNamed:@"login_header_logo"];
    [logoImagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSNaviTopHeight+KSIphonScreenH(30));
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    UIImageView *textImageV = [[UIImageView alloc]init];
    [self addSubview:textImageV];
    textImageV.image = [UIImage imageNamed:@"login_header_text"];
    [textImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImagV.mas_bottom).offset(KSIphonScreenH(23));
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
}


@end
