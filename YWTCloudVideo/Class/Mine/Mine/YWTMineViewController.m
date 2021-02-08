//
//  YWTMineViewController.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/13.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTMineViewController.h"

#import "YWTMineModel.h"

#import "YWTAccountManagerController.h"
#import "YWTLineViewController.h"

#import "YWTUserInfoCell.h"
#define YWTUSERINFO_CELL @"YWTUserInfoCell"
#import "YWTBaseTableViewCell.h"
#define YWTBASETABLEVIEW_CELL @"YWTBaseTableViewCell"

@interface YWTMineViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic,strong) UITableView *mineTable;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation YWTMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置Navi
    [self setNavi];
   
    [self.view addSubview:self.mineTable];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestNumber];
    [self updateUserInfoData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YWTUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:YWTUSERINFO_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        YWTMineModel *model = self.dataArr[indexPath.row];
        cell.model = model;
        return cell;
    }else{
        YWTBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YWTBASETABLEVIEW_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        YWTMineModel *model = self.dataArr[indexPath.row];
        cell.model = model;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 244;
    }else{
         return 54;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 || indexPath.row == 2) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        YWTTabBarViewController *tabbar = (YWTTabBarViewController*)appDelegate.window.rootViewController;
        tabbar.selectedIndex = 1;
    }
    
    if (indexPath.row == 5) {
        YWTAccountManagerController *vc = [[YWTAccountManagerController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark ----- 更新用户信息  -----
-(void) updateUserInfoData{
    YWTMineModel *userModel = self.dataArr[0];
    userModel.photoStr = [YWTNowLoginManager shareInstance].loginModel.headImage;
    userModel.nameStr = [YWTNowLoginManager shareInstance].loginModel.userName;
    userModel.numberStr = [YWTNowLoginManager shareInstance].loginModel.organizationName;
    [self.dataArr replaceObjectAtIndex:0 withObject:userModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.mineTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark ----- 设置Navi  -----
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    self.customNavBar.title = @"我的";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@""]];
    self.customNavBar.onClickLeftButton = ^{
        
    };
}
#pragma mark ----- get  -----
-(UITableView *)mineTable{
    if (!_mineTable) {
        _mineTable = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH)];
        _mineTable.delegate = self;
        _mineTable.dataSource = self;
        _mineTable.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
        _mineTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _mineTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mineTable registerClass:[YWTUserInfoCell class] forCellReuseIdentifier:YWTUSERINFO_CELL];
        [_mineTable registerClass:[YWTBaseTableViewCell class] forCellReuseIdentifier:YWTBASETABLEVIEW_CELL];
    }
    return _mineTable;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        
        YWTMineModel *userModel = [[YWTMineModel alloc]init];
        userModel.photoStr = [YWTNowLoginManager shareInstance].loginModel.headImage;
        userModel.nameStr = [YWTNowLoginManager shareInstance].loginModel.userName;
        userModel.numberStr = [YWTNowLoginManager shareInstance].loginModel.organizationName;
        
        YWTMineModel *lineModel = [[YWTMineModel alloc]init];
        lineModel.photoStr = @"mine_admin_xl";
        lineModel.nameStr = @"我的线路";
        lineModel.numberStr = @"3";
        
        YWTMineModel *towerModel = [[YWTMineModel alloc]init];
        towerModel.photoStr = @"mine_admin_gt";
        towerModel.nameStr = @"我的杆塔";
        towerModel.numberStr = @"33";
        
        YWTMineModel *alarmModel = [[YWTMineModel alloc]init];
        alarmModel.photoStr = @"mine_admin_gj";
        alarmModel.nameStr = @"我的告警";
        alarmModel.numberStr = @"";
        
        YWTMineModel *deviceModel = [[YWTMineModel alloc]init];
        deviceModel.photoStr = @"mine_admin_dw";
        deviceModel.nameStr = @"我的装置";
        deviceModel.numberStr = @"";
        
        YWTMineModel *managerModel = [[YWTMineModel alloc]init];
        managerModel.photoStr = @"mine_admin_zh";
        managerModel.nameStr = @"账号管理";
        managerModel.numberStr = @"";
        
        [_dataArr addObject:userModel];
        [_dataArr addObject:lineModel];
        [_dataArr addObject:towerModel];
        [_dataArr addObject:alarmModel];
        [_dataArr addObject:deviceModel];
        [_dataArr addObject:managerModel];
    }
    return _dataArr;
}

#pragma mark ---- 我的信息数量 ------
-(void) requestNumber{
    NSDictionary *dict = [NSDictionary dictionary];
    [[YWTHttpManager sharedManager] getRequestUrl:HTTP_APIWECHATNUMBER_URL params:dict waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        if (error) {
            [self.view showErrorWithTitle:error];
            return ;
        }
        NSDictionary *data = showdata[@"data"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            return;
        }
        // 线路
        YWTMineModel *lineModel = self.dataArr[1];
        lineModel.numberStr = [NSString stringWithFormat:@"%@",data[@"line_number"]];
        [self.dataArr replaceObjectAtIndex:1 withObject:lineModel];
        // 杆塔
        YWTMineModel *towerModel = self.dataArr[2];
        towerModel.numberStr = [NSString stringWithFormat:@"%@",data[@"tower_number"]];
        [self.dataArr replaceObjectAtIndex:2 withObject:towerModel];
        // 告警
        YWTMineModel *alarmModel = self.dataArr[3];
        alarmModel.numberStr = [NSString stringWithFormat:@"%@",data[@"alarm_number"]];
        [self.dataArr replaceObjectAtIndex:3 withObject:alarmModel];
        
        [self.mineTable reloadData];
    }];
}


@end
