//
//  YWTMessageListCell.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/18.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTMessageListCell.h"

@interface YWTMessageListCell ()
// 背景view
@property (nonatomic,strong) UIView *bgView;

// 告警图
@property (nonatomic,strong) UIImageView *alarmImageV;
// 标题
@property (nonatomic,strong) UILabel *titleLab;
// 时间
@property (nonatomic,strong) UILabel *timeLab;
// 副标题
@property (nonatomic,strong) UILabel *subtitleLab;

@end


@implementation YWTMessageListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createMsgListView];
    }
    return self;
}
-(void) createMsgListView{
    self.backgroundColor = [UIColor colorCommonBgViewColor];
    
    WS(weakSelf);
    self.bgView = [[UIView alloc]init];
    [self addSubview:self.bgView];
    self.bgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#333333"] normalCorlor:[UIColor colorTextWhiteColor]];
    
    self.coverImageV = [[UIImageView alloc]init];
    [self.bgView addSubview:self.coverImageV];
    self.coverImageV.image = [UIImage imageNamed:@"base_detail_nomal"];
    [self.coverImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgView);
        make.left.right.equalTo(weakSelf.bgView);
        make.height.equalTo(@(KSIphonScreenH(170)));
    }];
    
    self.alarmImageV = [[UIImageView alloc]init];
    [self.bgView addSubview:self.alarmImageV];
    self.alarmImageV.image = [UIImage imageNamed:@"msg_xx_gj"];
    self.alarmImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.alarmImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(weakSelf.bgView);
    }];
  
     self.timeLab = [[UILabel alloc]init];
     [self.bgView addSubview:self.timeLab];
     self.timeLab.text = @"";
     self.timeLab.textColor = [UIColor colorCommonGrayBlackColor];
     self.timeLab.font = Font(15);
     [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(weakSelf.coverImageV.mas_bottom).offset(KSIphonScreenH(5));
         make.right.equalTo(weakSelf.bgView).offset(-KSIphonScreenW(10));
         make.width.equalTo(@150);
     }];
    
    
    self.titleLab = [[UILabel alloc]init];
    [self.bgView addSubview:self.titleLab];
    self.titleLab.text = @"";
    self.titleLab.textColor = [UIColor colorCommonBlackColor];
    self.titleLab.font = Font(16);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView).offset(KSIphonScreenW(10));
        make.right.equalTo(weakSelf.timeLab.mas_left).offset(-KSIphonScreenW(5));
        make.centerY.equalTo(weakSelf.timeLab.mas_centerY);
    }];
    
    self.subtitleLab = [[UILabel alloc]init];
    [self.bgView addSubview:self.subtitleLab];
    self.subtitleLab.text = @"";
    self.subtitleLab.textColor = [UIColor colorCommonGrayBlackColor];
    self.subtitleLab.font = Font(13);
    self.subtitleLab.numberOfLines = 0;
    [self.subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(KSIphonScreenH(5));
        make.left.equalTo(weakSelf.titleLab.mas_left);
        make.right.equalTo(weakSelf.bgView).offset(-KSIphonScreenW(10));
    }];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(10));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(15));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(15));
        make.bottom.equalTo(weakSelf.subtitleLab.mas_bottom).offset(KSIphonScreenH(10));
    }];
    self.bgView.layer.cornerRadius = 8;
    self.bgView.layer.masksToBounds = YES;
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    WS(weakSelf);
    // 时间
//    NSString *timeStr = [NSString stringWithFormat:@"%@",dict[@"begin_time"]];
//    NSArray *timeArr = [timeStr componentsSeparatedByString:@" "];
    self.timeLab.text = [NSString stringWithFormat:@"%@",dict[@"begin_time"]];
    // 标题
    self.titleLab.text = [NSString stringWithFormat:@"%@-%@-%@",dict[@"line_name"],dict[@"tower_name"],dict[@"orientation_name"]];
    // 图片地址
    NSString *urlStr = [NSString stringWithFormat:@"%@",dict[@"msrc"]];
    [YWTTools sd_setImageView:self.coverImageV WithURL:urlStr andPlaceholder:@"base_detail_nomal"];
    
    NSString *resourceStr = [NSString stringWithFormat:@"%@",dict[@"resource"]];
    if ([resourceStr isEqualToString:@"1"]) {
        self.alarmImageV.hidden = YES;
        
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(KSIphonScreenH(15));
            make.left.equalTo(weakSelf).offset(KSIphonScreenW(15));
            make.right.equalTo(weakSelf).offset(-KSIphonScreenW(15));
            make.bottom.equalTo(weakSelf.titleLab.mas_bottom).offset(KSIphonScreenH(10));
        }];
        self.subtitleLab.hidden = YES;
    }else{
        self.alarmImageV.hidden = NO;
        self.subtitleLab.hidden = NO;
        NSString *causeNamesStr = [NSString stringWithFormat:@"%@",dict[@"cause_names"]];
        self.subtitleLab.attributedText  = [self getTitleQuestAttributStr:causeNamesStr];
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(KSIphonScreenH(15));
            make.left.equalTo(weakSelf).offset(KSIphonScreenW(15));
            make.right.equalTo(weakSelf).offset(-KSIphonScreenW(15));
            make.bottom.equalTo(weakSelf.subtitleLab.mas_bottom).offset(KSIphonScreenH(10));
        }];
    }
}

/**
   题目  图文混排
 @param questStr 传入的文字
 @return  NSMutableAttributedString 类型
 */
-(NSMutableAttributedString *)getTitleQuestAttributStr:(NSString*)questStr {
    NSString *textStr =[NSString stringWithFormat:@"  %@",questStr];
    // 字体
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSInteger fontSize = [userD objectForKey:@"Font"] ? [[userD objectForKey:@"Font"][@"TitleQuestFont"]integerValue] : 17 ;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textStr];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, textStr.length)];
    //设置图片源
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"line_xx_jb"];
    textAttachment.bounds = CGRectMake(0, -4, 20, 18);
    
    //NSTextAttachment占用一个字符长度，插入后原字符串长度增加1
    NSAttributedString *attrString = [NSAttributedString attributedStringWithAttachment: textAttachment];
    [attrStr insertAttributedString: attrString atIndex: 0];
    
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];

    return  attrStr;
}
// 计算高度
+(CGFloat) getWithListCellHeight:(NSDictionary*)dict andCellType:(showListCellType)cellType{
    CGFloat height =KSIphonScreenH(20);

    // 图片高度
    height += KSIphonScreenH(170);
    
    // 标题
    NSString *titleStr = [NSString stringWithFormat:@"%@-%@-%@",dict[@"line_name"],dict[@"tower_name"],dict[@"orientation_name"]];
    CGFloat titleHieght =  [YWTTools getLabelHeightWithText:titleStr width:KScreenW-70-KSIphonScreenW(30) font:16];
    height += titleHieght;
    
    height += KSIphonScreenH(10);
    
    NSString *resourceStr = [NSString stringWithFormat:@"%@",dict[@"resource"]];
    if ([resourceStr isEqualToString:@"1"]) {
        return height;
    }else{
        NSString *causeNamesStr = [NSString stringWithFormat:@"%@",dict[@"cause_names"]];
        UILabel *lab = [[UILabel alloc]init];
        lab.attributedText = [YWTMessageListCell getTitleQuestAttributStr:causeNamesStr];
        CGFloat causeHight = [YWTMessageListCell boundsWithFontSize:13 text:lab.text needWidth:KScreenW-KSIphonScreenH(50) lineSpacing:2].height;
        height += causeHight;
        
        height += KSIphonScreenH(10);
    }
    return height;
}
// 类方法
+(NSMutableAttributedString *)getTitleQuestAttributStr:(NSString*)questStr {
    NSString *textStr =[NSString stringWithFormat:@"  %@",questStr];
    // 字体
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSInteger fontSize = [userD objectForKey:@"Font"] ? [[userD objectForKey:@"Font"][@"TitleQuestFont"]integerValue] : 17 ;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textStr];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, textStr.length)];
    //设置图片源
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"line_xx_jb"];
    textAttachment.bounds = CGRectMake(0, -4, 20, 18);
    
    //NSTextAttachment占用一个字符长度，插入后原字符串长度增加1
    NSAttributedString *attrString = [NSAttributedString attributedStringWithAttachment: textAttachment];
    [attrStr insertAttributedString: attrString atIndex: 0];
    
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];

    return  attrStr;
}
// 计算高度
+(CGSize)boundsWithFontSize:(CGFloat)fontSize text:(NSString *)text needWidth:(CGFloat)needWidth lineSpacing:(CGFloat )lineSpacing{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    style.lineSpacing = lineSpacing;
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(needWidth, CGFLOAT_MAX) options:options context:nil];
    
    return rect.size;
}



-(void)setCellType:(showListCellType)cellType{
    _cellType = cellType;
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
