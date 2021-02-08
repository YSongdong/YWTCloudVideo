//
//  YWTBaseTableViewCell.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/13.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTBaseTableViewCell.h"

@interface YWTBaseTableViewCell ()

@property (nonatomic,strong) UIImageView *leftImageV;

@property (nonatomic,strong) UILabel *moduleNameLab;

@property (nonatomic,strong) UILabel *numberLab;

@end


@implementation YWTBaseTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createBaseView];
    }
    return self;
}
-(void) createBaseView{
    self.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
    WS(weakSelf);
    self.leftImageV = [[UIImageView alloc]init];
    [self addSubview:self.leftImageV];
    self.leftImageV.image = [UIImage imageNamed:@"mine_admin_xl"];
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(15));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.height.equalTo(@28);
    }];
    
    self.moduleNameLab = [[UILabel alloc]init];
    [self addSubview:self.moduleNameLab];
    self.moduleNameLab.text = @"";
    self.moduleNameLab.textColor = [UIColor colorCommonBlackColor];
    self.moduleNameLab.font = BFont(15);
    [self.moduleNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(KSIphonScreenW(13));
        make.centerY.equalTo(weakSelf.leftImageV.mas_centerY);
    }];
            
    UIImageView *rightImageV = [[UIImageView alloc]init];
    [self addSubview:rightImageV];
    rightImageV.image = [UIImage imageNamed:@"mine_arrow"];
    rightImageV.contentMode = UIViewContentModeScaleAspectFit;
    [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(15));
        make.centerY.equalTo(weakSelf.leftImageV.mas_centerY);
        make.width.equalTo(@20);
    }];
    
    self.numberLab = [[UILabel alloc]init];
    [self addSubview:self.numberLab];
    self.numberLab.text = @"";
    self.numberLab.textColor = [UIColor colorCommonGrayBlackColor];
    self.numberLab.font = Font(14);
    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightImageV.mas_left).offset(-KSIphonScreenW(15));
        make.centerY.equalTo(weakSelf.moduleNameLab.mas_centerY);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorCommonLineColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.moduleNameLab.mas_left);
        make.right.equalTo(rightImageV.mas_right);
        make.bottom.equalTo(weakSelf);
        make.height.equalTo(@0.5);
    }];
}

-(void)setModel:(YWTMineModel *)model{
    _model = model;
    
    self.leftImageV.image = [UIImage imageNamed:model.photoStr];
    
    self.moduleNameLab.text = model.nameStr;
    
    self.numberLab.text = model.numberStr;
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
