//
//  YWTManagerTableViewCell.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/14.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTManagerTableViewCell.h"

@interface YWTManagerTableViewCell ()

@property (nonatomic,strong) UIImageView *headerImageV;

@property (nonatomic,strong) UILabel *nameLab;

@property (nonatomic,strong) UILabel *comparyLab;

@property (nonatomic,strong) UIButton *selectBtn;

@end


@implementation YWTManagerTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCellView];
    }
    return self;
}
-(void) createCellView{
    self.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
    
    WS(weakSelf);
    self.headerImageV = [[UIImageView alloc] init];
    [self addSubview:self.headerImageV];
    self.headerImageV.image = [UIImage imageNamed:@"mine_noralHeader"];
    [self.headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(15));
        make.width.height.equalTo(@40);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    self.headerImageV.layer.cornerRadius = 40/2;
    self.headerImageV.layer.masksToBounds = YES;
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.selectBtn];
    [self.selectBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.selectBtn addTarget:self action:@selector(selectDelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(10));
        make.width.height.equalTo(@30);
        make.centerY.equalTo(weakSelf.headerImageV.mas_centerY);
    }];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    
    
    self.nameLab = [[UILabel alloc]init];
    [bgView addSubview:self.nameLab];
    self.nameLab.text = @"";
    self.nameLab.textColor = [UIColor colorCommonBlackColor];
    self.nameLab.font = Font(17);
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(bgView);
        make.right.equalTo(bgView);
    }];
    
    self.comparyLab = [[UILabel alloc]init];
    [bgView addSubview:self.comparyLab];
    self.comparyLab.text = @"";
    self.comparyLab.textColor = [UIColor colorCommonGrayBlackColor];
    self.comparyLab.font = Font(12);
    [self.comparyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLab.mas_bottom);
        make.left.equalTo(weakSelf.nameLab.mas_left);
        make.right.equalTo(weakSelf.nameLab.mas_right);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLab.mas_top);
        make.bottom.equalTo(weakSelf.comparyLab.mas_bottom);
        make.left.equalTo(weakSelf.headerImageV.mas_right).offset(13);
        make.right.equalTo(weakSelf.selectBtn.mas_left).offset(-KSIphonScreenW(5));
        make.centerY.equalTo(weakSelf.headerImageV.mas_centerY);
    }];
  
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorCommonLineColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView);
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(15));
        make.bottom.equalTo(weakSelf);
        make.height.equalTo(@0.5);
    }];
}

-(void)setModel:(YWTAccountManagateModel *)model{
    _model = model;
    
    // 头像
    [YWTTools sd_setImageView:self.headerImageV WithURL:model.photoUrl andPlaceholder:@"mine_noralHeader"];
    
    self.nameLab.text = model.name;
    
    self.comparyLab.text = model.compary;
    
    if ([model.cellStyleModel isEqualToString:@"0"]) {
        [self.selectBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else if ([model.cellStyleModel isEqualToString:@"1"]){
        [self.selectBtn setImage:[UIImage imageNamed:@"mine_manage_ok"] forState:UIControlStateNormal];
    }else if ([model.cellStyleModel isEqualToString:@"2"]){
        [self.selectBtn setImage:[UIImage imageNamed:@"mine_manager_del"] forState:UIControlStateNormal];
    }
}

-(void) selectDelAction:(UIButton *)sender{
    // 编辑
    if ([self.model.cellStyleModel isEqualToString:@"2"]) {
        self.selectDel();
    }
   
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
