//
//  YWTVideoListViewController.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/13.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTVideoListViewController.h"

@interface YWTVideoListViewController ()

@end

@implementation YWTVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    // 设置Navi
    [self setNavi];
}
#pragma mark ----- 设置Navi  -----
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    self.customNavBar.title = @"视频";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@""]];
    self.customNavBar.onClickLeftButton = ^{
        
    };
}

@end
