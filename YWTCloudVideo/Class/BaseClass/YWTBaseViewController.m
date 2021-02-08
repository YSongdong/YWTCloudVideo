//
//  YWTBaseViewController.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/11.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTBaseViewController.h"

@interface YWTBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation YWTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //
    [self setupNavBar];
}

- (void)setupNavBar{
    [self.view addSubview:self.customNavBar];

    // 设置自定义导航栏背景图片
    self.customNavBar.barBackgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
   
    // 设置自定义导航栏标题颜色
    self.customNavBar.titleLabelColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorTextWhiteColor] normalCorlor:[UIColor colorConstantStyleDarkColor]];
//    //隐藏导航栏线条
//    [self.customNavBar  wr_setBottomLineHidden:YES];
    
    WS(weakSelf);
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"navi_back"]];
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
- (WRCustomNavigationBar *)customNavBar{
    if (_customNavBar == nil) {
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
    }
    return _customNavBar;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.childViewControllers.count == 1) {
        return NO;
    }else{
        return YES;
    }
}
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}


@end
