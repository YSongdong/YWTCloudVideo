//
//  YWTUserInfoCell.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/13.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTUserInfoCell.h"

@interface YWTUserInfoCell ()

@property (nonatomic,strong) UIImageView *headerImageV;

@property (nonatomic,strong) UILabel *nameLab;

@property (nonatomic,strong) UILabel *comparyLab;

@end

@implementation YWTUserInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createInfoView];
    }
    return self;
}
-(void) createInfoView{
    self.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
    WS(weakSelf);
    
    UIImageView *bgImageV = [[UIImageView alloc]init];
    [self addSubview:bgImageV];
    bgImageV.image = [UIImage imageNamed:@"mine_userBg"];
    [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(22));
    }];
    
    self.headerImageV = [[UIImageView alloc]init];
    [self addSubview:self.headerImageV];
    self.headerImageV.image = [UIImage imageNamed:@"mine_noralHeader"];
    [self.headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@90);
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(35));
        make.centerX.equalTo(bgImageV.mas_centerX);
    }];
    self.headerImageV.layer.cornerRadius = 90/2;
    self.headerImageV.layer.masksToBounds = YES;
    
    self.nameLab = [[UILabel alloc]init];
    [self addSubview:self.nameLab];
    self.nameLab.text = @"";
    self.nameLab.textColor = [UIColor colorCommonBlackColor];
    self.nameLab.font = Font(17);
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerImageV.mas_bottom).offset(KSIphonScreenH(10));
        make.centerX.equalTo(weakSelf.headerImageV.mas_centerX);
    }];
    
    self.comparyLab = [[UILabel alloc]init];
    [self addSubview:self.comparyLab];
    self.comparyLab.text = @"";
    self.comparyLab.textColor = [UIColor colorCommonGrayBlackColor];
    self.comparyLab.font = Font(12);
    self.comparyLab.textAlignment = NSTextAlignmentCenter;
    [self.comparyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLab.mas_bottom).offset(KSIphonScreenH(10));
        make.centerX.equalTo(weakSelf.nameLab.mas_centerX);
    }];

}

-(void)setModel:(YWTMineModel *)model{
    _model = model;
    
    self.nameLab.text = model.nameStr;
    
    self.comparyLab.text = model.numberStr;
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
