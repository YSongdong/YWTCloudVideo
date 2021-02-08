//
//  LoginSettingController.m
//  PartyBuildingStar
//
//  Created by tiao on 2019/1/9.
//  Copyright © 2019年 wutiao. All rights reserved.
//

#import "YWTLoginSettingController.h"

@interface YWTLoginSettingController ()

@property (nonatomic,strong) UITextField *serveTextField;

@property (nonatomic,strong) UITextField *portTextField;

@end

@implementation YWTLoginSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏
    [self setNavi];
    // 创建 view
    [self createView];
}
-(void) createView{
    __weak typeof(self) weakSelf = self;
    self.view.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
    
    UIView *serveAddressView= [[UIView alloc]init];
    [self.view addSubview:serveAddressView];
    serveAddressView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
    [serveAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(KSNaviTopHeight+KSIphonScreenH(10));
        make.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@(KSIphonScreenH(60)));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UILabel *showServeLab = [[UILabel alloc]init];
    [serveAddressView addSubview:showServeLab];
    showServeLab.text = @"服务器地址";
    showServeLab.textColor = [UIColor colorCommonBlackColor];
    showServeLab.font = Font(16);
    [showServeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(serveAddressView).offset(KSIphonScreenW(12));
        make.centerY.equalTo(serveAddressView.mas_centerY);
    }];
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    
    self.serveTextField = [[UITextField alloc]init];
    [serveAddressView addSubview:self.serveTextField];
    self.serveTextField.placeholder = [NSString stringWithFormat:@"例如: agk.cqlanhui.com"];
    if ([userD objectForKey:@"IP"]) {
        NSDictionary *param = [userD objectForKey:@"IP"];
        if ([param[@"IP"] isEqualToString:@""]) {
            NSString *urlStr = PUBLISH_DIMAIN_URL;
            NSArray *urlArr = [urlStr componentsSeparatedByString:@"//"];
            NSString *websiteStr = urlArr[1];
            NSArray *websiteArr = [websiteStr componentsSeparatedByString:@":"];
            NSString *str = websiteArr[0];
            NSString *ipStr = [str substringToIndex:str.length-1];
            self.serveTextField.placeholder = [NSString stringWithFormat:@"例如: %@",ipStr];
        }else{
            self.serveTextField.text = [NSString stringWithFormat:@"%@",param[@"IP"]];
        }
    }else{
        NSString *urlStr = PUBLISH_DIMAIN_URL;
        NSArray *urlArr = [urlStr componentsSeparatedByString:@"//"];
        NSString *websiteStr = urlArr[1];
        NSArray *websiteArr = [websiteStr componentsSeparatedByString:@":"];
        NSString *str = websiteArr[0];
        NSString *ipStr = [str substringToIndex:str.length-1];
        self.serveTextField.placeholder = [NSString stringWithFormat:@"例如: %@",ipStr];
    }
    self.serveTextField.textColor = [UIColor colorCommonBlackColor];
    self.serveTextField.font = Font(16);
    self.serveTextField.textAlignment = NSTextAlignmentRight;
    [self.serveTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(serveAddressView).offset(-KSIphonScreenW(12));
        make.top.height.equalTo(serveAddressView);
        make.left.equalTo(serveAddressView).offset(KSIphonScreenW(140));
        // make.left.equalTo(showServeLab.mas_right).offset(KSIphonScreenW(60));
        make.centerY.equalTo(serveAddressView.mas_centerY);
    }];
    
    UIView *serveLineView  = [[UIView alloc]init];
    [serveAddressView addSubview:serveLineView];
    serveLineView.backgroundColor  = [UIColor colorWithHexString:@"#e0e0e0"];
    [serveLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(serveAddressView);
        make.height.equalTo(@(KSIphonScreenH(1)));
    }];
    
    UIView *portView = [[UIView alloc]init];
    [self.view addSubview:portView];
    portView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
    [portView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(serveAddressView.mas_bottom);
        make.left.with.height.equalTo(serveAddressView);
        make.centerX.equalTo(serveAddressView.mas_centerX);
    }];
    
    UILabel *showProtLab = [[UILabel alloc]init];
    [portView addSubview:showProtLab];
    showProtLab.text = @"端口";
    showProtLab.textColor = [UIColor colorCommonBlackColor];
    showProtLab.font = Font(16);
    [showProtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showServeLab.mas_left);
        make.centerY.equalTo(portView.mas_centerY);
    }];
    
    self.portTextField = [[UITextField alloc]init];
    [portView addSubview:self.portTextField];
    self.portTextField.placeholder = [NSString stringWithFormat:@"例如: 80"];
    if ([userD objectForKey:@"IP"]) {
        NSDictionary *param = [userD objectForKey:@"IP"];
        self.portTextField.text = [NSString stringWithFormat:@"%@",param[@"port"]];
    }else{

    }
    self.portTextField.textColor = [UIColor colorCommonBlackColor];
    self.portTextField.font = Font(16);
    self.portTextField.textAlignment =  NSTextAlignmentRight;
    [self.portTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(portView).offset(-KSIphonScreenW(12));
        make.top.height.equalTo(portView);
        make.width.equalTo(weakSelf.serveTextField.mas_width);
        // make.left.equalTo(showProtLab.mas_right).offset(KSIphonScreenW(60));
        make.centerY.equalTo(portView.mas_centerY);
    }];
    
    UIView *portLineView  = [[UIView alloc]init];
    [portView addSubview:portLineView];
    portLineView.backgroundColor  = [UIColor colorWithHexString:@"#e0e0e0"];
    [portLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(portView);
        make.height.equalTo(@(KSIphonScreenH(1)));
    }];
}
//保存设置
-(void)selectSaveSetting{

    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *urlUTF8Str = [self.serveTextField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    param[@"IP"] = urlUTF8Str;
    NSString *protUTF8Str = [self.portTextField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    param[@"port"] =protUTF8Str;
    [userD setObject:param forKey:@"IP"];
    //3.强制让数据立刻保存
    [userD synchronize];
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.serveTextField resignFirstResponder];
    [self.portTextField resignFirstResponder];
    [self.view endEditing:YES];
}
#pragma mark --- 设置导航栏 --------
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    
    self.customNavBar.title = @"登录参数";
    
    __weak typeof(self) weakSelf = self;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"navi_back"]];
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    //保存设置
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@""]];
    [self.customNavBar.rightButton  setTitle:@"保存设置" forState:UIControlStateNormal];
    [self.customNavBar.rightButton setTitleColor:[UIColor colorCommonBlackColor] forState:UIControlStateNormal];
    self.customNavBar.rightButton.titleLabel.font = Font(16);
    self.customNavBar.rightButton.frame = CGRectMake(KScreenW - 80, KSStatusHeight, 70 , 44);
    [self.customNavBar setOnClickRightButton:^{
        [weakSelf selectSaveSetting];
    }];
}

@end
