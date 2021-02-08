//
//  YWTManagerHeaderView.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/14.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTManagerHeaderView.h"

@implementation YWTManagerHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createHeaderView];
    }
    return self;
}
-(void) createHeaderView{
    self.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
    WS(weakSelf);
    UILabel *lab = [[UILabel alloc]init];
    [self addSubview:lab];
    lab.text = @"亲，平台为了您的使用便捷，在这里可以添加多个账号，切换即可查看各单位情况:";
    lab.textColor = [UIColor colorCommonGrayBlackColor];
    lab.font = Font(12);
    lab.numberOfLines = 0;
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(30));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(15));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(15));
    }];
}



@end
