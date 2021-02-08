//
//  YWTMessageHeaderView.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/18.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTMessageHeaderView.h"

@interface  YWTMessageHeaderView ()

@property (nonatomic,strong) UILabel *timeLab;

@end


@implementation YWTMessageHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createHeaderView];
    }
    return self;
}
-(void) createHeaderView{
    self.backgroundColor = [UIColor colorCommonBgViewColor];
    
    WS(weakSelf);
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorCommonLineColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(15));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(15));
        make.height.equalTo(@0.5);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    self.timeLab = [[UILabel alloc]init];
    [self addSubview:self.timeLab];
    self.timeLab.text = @"2019-04-29";
    self.timeLab.textColor = [UIColor colorTextWhiteColor];
    self.timeLab.font = Font(13);
    self.timeLab.textAlignment = NSTextAlignmentCenter;
    self.timeLab.backgroundColor = [UIColor  colorCommonLineColor];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@110);
        make.height.equalTo(@26);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(lineView.mas_centerY);
    }];
    self.timeLab.layer.cornerRadius = 26/2;
    self.timeLab.layer.masksToBounds = YES;

}



@end
