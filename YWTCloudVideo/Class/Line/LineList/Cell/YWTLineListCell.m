//
//  YWTLineListCell.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/21.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTLineListCell.h"

@interface YWTLineListCell ()

@property (nonatomic,strong) UIView *bgView;
// 标题图片
@property (nonatomic,strong) UIImageView *titleImageV;
// 标题
@property (nonatomic,strong) UILabel *titleLab;
// 显示说明等级
@property (nonatomic,strong) UILabel *showMarkGradeLab;
// 说明等级
@property (nonatomic,strong) UILabel *markGradeLab;
// 显示说明GT
@property (nonatomic,strong) UILabel *showMarkGTLab;
// 说明GT
@property (nonatomic,strong) UILabel *markGTLab;

@end


@implementation YWTLineListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createLineView];
    }
    return self;
}
-(void) createLineView{
    self.backgroundColor = [UIColor colorCommonF5BgViewColor];
    
    WS(weakSelf);
    self.bgView  = [[UIView alloc]init];
    [self addSubview:self.bgView];
    self.bgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStylGrayeDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(15));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(15));
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(10));
    }];
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
   

    self.titleImageV = [[UIImageView alloc]init];
    [self.bgView addSubview:self.titleImageV];
    self.titleImageV.image  =[UIImage imageNamed:@"line_xl_xl"];
    self.titleImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.titleImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgView).offset(KSIphonScreenH(15));
        make.left.equalTo(weakSelf.bgView).offset(KSIphonScreenW(15));
        make.width.equalTo(@30);
    }];
    
    self.titleLab = [[UILabel alloc]init];
    [self.bgView addSubview:self.titleLab];
    self.titleLab.textColor = [UIColor colorCommonBlackColor];
    self.titleLab.font = BFont(16);
    self.titleLab.text = @"";
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleImageV.mas_top);
        make.left.equalTo(weakSelf.titleImageV.mas_right).offset(KSIphonScreenW(5));
        make.right.equalTo(weakSelf.bgView).offset(-KSIphonScreenW(15));
    }];
    
    
    self.showMarkGradeLab = [[UILabel alloc]init];
    [self.bgView addSubview:self.showMarkGradeLab];
    self.showMarkGradeLab.textColor = [UIColor colorCommonGrayBlackColor];
    self.showMarkGradeLab.font = Font(12);
    self.showMarkGradeLab.text = @"DY等级:";
    [self.showMarkGradeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(KSIphonScreenH(5));
        make.left.equalTo(weakSelf.titleLab.mas_left);
    }];
    
    self.markGradeLab = [[UILabel alloc]init];
    [self.bgView addSubview:self.markGradeLab];
    self.markGradeLab.textColor = [UIColor colorCommonBlackColor];
    self.markGradeLab.font = Font(12);
    self.markGradeLab.text = @"";
    [self.markGradeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.showMarkGradeLab.mas_right).offset(KSIphonScreenW(5));
        make.centerY.equalTo(weakSelf.showMarkGradeLab.mas_centerY);
    }];
    
    
    UIView *lineView = [[UIView alloc]init];
    [self.bgView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorCommonBlackColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.showMarkGradeLab.mas_centerY);
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
        make.width.equalTo(@0.5);
        make.height.equalTo(@10);
    }];
    
    
    self.showMarkGTLab = [[UILabel alloc]init];
    [self.bgView addSubview:self.showMarkGTLab];
    self.showMarkGTLab.textColor = [UIColor colorCommonGrayBlackColor];
    self.showMarkGTLab.font = Font(12);
    self.showMarkGTLab.text = @"起止GT:";
    [self.showMarkGTLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(KSIphonScreenW(15));
        make.centerY.equalTo(weakSelf.showMarkGradeLab.mas_centerY);
    }];
    
    self.markGTLab = [[UILabel alloc]init];
    [self.bgView addSubview:self.markGTLab];
    self.markGTLab.textColor = [UIColor colorCommonBlackColor];
    self.markGTLab.font = Font(12);
    self.markGTLab.text = @"";
    [self.markGTLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.showMarkGTLab.mas_right).offset(KSIphonScreenW(5));
        make.centerY.equalTo(weakSelf.showMarkGTLab.mas_centerY);
    }];
    
    
    UIImageView *rightImageV = [[UIImageView alloc]init];
    [self.bgView addSubview:rightImageV];
    rightImageV.image = [UIImage imageNamed:@"mine_arrow"];
    rightImageV.contentMode = UIViewContentModeScaleAspectFit;
    [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView).offset(-KSIphonScreenW(15));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
    }];

}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    if (self.listType == showCellListLineType ) {
        self.titleLab.text = [NSString stringWithFormat:@"%@",dict[@"line_name"]];
        self.markGradeLab.text =  [NSString stringWithFormat:@"%@",dict[@"voltage_name"]];
        self.titleImageV.image  =[UIImage imageNamed:@"line_xl_xl"];
        self.showMarkGradeLab.text = @"DY等级:";
        self.showMarkGTLab.text = @"起止GT:";
        self.markGTLab.text =[NSString stringWithFormat:@"%@ - %@",dict[@"start_tower_name"],dict[@"end_tower_name"]];
    }else{
        self.titleLab.text = [NSString stringWithFormat:@"GT%@",dict[@"tower_name"]];
        self.markGradeLab.text =  [NSString stringWithFormat:@"%@",dict[@"texture_name"]];
        self.titleImageV.image  =[UIImage imageNamed:@"line_xl_gt"];
        self.showMarkGradeLab.text = @"GT性质:";
        self.showMarkGTLab.text = @"GT材质:";
        self.markGTLab.text =[NSString stringWithFormat:@"%@",dict[@"nature_name"]];
    }
}

-(void)setListType:(showCellListType)listType{
    _listType = listType;
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
