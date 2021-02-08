//
//  YWTFilterOriented_Cell.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/22.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTFilterOrientedCell.h"

@interface YWTFilterOrientedCell ()
@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UILabel *titleLab;
@end

@implementation YWTFilterOrientedCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createOrigenCell];
    }
    return self;
}

-(void)createOrigenCell{
   self.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
    
    WS(weakSelf);
    self.bgView  = [[UIView alloc]init];
    [self addSubview:self.bgView];
    self.bgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorWithHexString:@"#f5f5f5"]];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(@24);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    self.bgView.layer.cornerRadius = 24/2;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorWithHexString:@"#f5f5f5"]].CGColor;
    
    self.titleLab = [[UILabel alloc]init];
    [self.bgView addSubview:self.titleLab];
    self.titleLab.text = @"";
    self.titleLab.textColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStylGrayeDarkColor] normalCorlor:[UIColor colorWithHexString:@"#999999"]];
    self.titleLab.font = Font(14);
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView).offset(8);
        make.right.equalTo(weakSelf.bgView).offset(-8);
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
    }];
}

-(void)setModel:(YWTDetailFitlerModel *)model{
    _model = model;
    
    self.titleLab.text = model.name;
    
    if (model.isSelect) {
        if (self.cellType == showDetailOrienCellType) {
            // 筛选
            self.bgView.backgroundColor  = [UIColor colorCommonGreenColor];
            self.titleLab.textColor = [UIColor colorTextWhiteColor];
        }else{
            // 发送指令
            if (self.indexPath.section == 0) {
               self.bgView.backgroundColor  = [UIColor colorCommonGreenColor];
               self.titleLab.textColor = [UIColor colorTextWhiteColor];
               self.bgView.layer.borderColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorWithHexString:@"#f5f5f5"]].CGColor;
            }else{
                self.bgView.layer.borderColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorCommonGreenColor]].CGColor;
                self.bgView.backgroundColor  = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorWithHexString:@"#f5f5f5"]];
                 self.titleLab.textColor = [UIColor colorCommonGreenColor];
            }
        }
    }else{
       if (self.cellType == showDetailOrienCellType) {
            // 筛选
           self.bgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStylGrayeDarkColor] normalCorlor:[UIColor colorWithHexString:@"#f5f5f5"]];
           self.bgView.layer.borderColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorWithHexString:@"#f5f5f5"]].CGColor;
           self.titleLab.textColor = [UIColor colorCommonGrayBlackColor];
       }else{
            // 发送指令
           self.bgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorWithHexString:@"#f5f5f5"]];
           self.bgView.layer.borderColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorWithHexString:@"#f5f5f5"]].CGColor;
           self.titleLab.textColor = [UIColor colorCommonGrayBlackColor];
       }
    }
}

-(void)setCellType:(showDetaOrienCellType)cellType{
    _cellType = cellType;
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}

@end
