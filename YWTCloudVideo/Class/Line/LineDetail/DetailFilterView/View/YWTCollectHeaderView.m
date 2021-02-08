//
//  YWTCollectHeaderView.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/26.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTCollectHeaderView.h"

@implementation YWTCollectHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createHeaderView];
    }
    return self;
}

-(void) createHeaderView{
    
    WS(weakSelf);
    self.titleLab = [[UILabel alloc]init];
    [self addSubview:self.titleLab];
    self.titleLab.textColor = [UIColor colorCommonBlackColor];
    self.titleLab.font = BFont(16);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(15));
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(2));
    }];
}



@end
