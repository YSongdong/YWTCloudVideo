//
//  YWTBlankPageView.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/27.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTBlankPageView.h"

@implementation YWTBlankPageView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createPageView];
    }
    return self;
}
-(void) createPageView{
    self.backgroundColor = [UIColor colorCommonBgViewColor];
    
    WS(weakSelf);
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    UIImageView *bgImageV = [[UIImageView alloc]init];
    [bgView addSubview:bgImageV];
    bgImageV.image = [UIImage imageNamed:@"blankPageView"];
    [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.centerX.equalTo(bgView.mas_centerX);
        make.width.equalTo(@200);
        make.height.equalTo(@100);
    }];
    
    UILabel *blankPageLab = [[UILabel alloc]init];
    [bgView addSubview:blankPageLab];
    blankPageLab.text = @"暂无数据";
    blankPageLab.textColor = [UIColor colorCommonBlackColor];
    blankPageLab.font = Font(15);
    blankPageLab.numberOfLines = 0;
    blankPageLab.textAlignment = NSTextAlignmentCenter;
    [blankPageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImageV.mas_bottom).offset(KSIphonScreenH(10));
        make.left.right.equalTo(bgView);
    }];
   
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImageV.mas_top);
        make.bottom.equalTo(blankPageLab.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
}




@end
