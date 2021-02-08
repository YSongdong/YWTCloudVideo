//
//  YWTBaseListViewController.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/11.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTBaseListViewController.h"

@interface YWTBaseListViewController ()

@end

@implementation YWTBaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[YWTHttpManager sharedManager]cancelRequest];
}





@end
