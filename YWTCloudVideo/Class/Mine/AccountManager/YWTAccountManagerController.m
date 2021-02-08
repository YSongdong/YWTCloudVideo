//
//  YWTAccountManagerController.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/14.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTAccountManagerController.h"

#import "YWTLoginViewController.h"

#import "YWTManagerHeaderView.h"
#import "YWTManagerFooterView.h"
#import "YWTManagerTableViewCell.h"
#define YWTMANAGERTABLEVIEW_CELL @"YWTManagerTableViewCell"


@interface YWTAccountManagerController ()
<
UITableViewDelegate,
UITableViewDataSource,
YWTManagerFooterViewDelegate
>
@property (nonatomic,strong) UITableView *managateTable;

@property (nonatomic,strong) NSMutableArray *dataArr;

// 是不是编辑模式  YES 是 NO 不是  （默认 NO）
@property (nonatomic,assign) BOOL isEditMode;
// 选中
@property (nonatomic,strong) NSIndexPath *selectIndexPath;

@end

@implementation YWTAccountManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    self.isEditMode = NO;
    // 设置导航栏
    [self setNavi];
    
    // 创建tableView
    [self.view addSubview:self.managateTable];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 加载所有账号
    [self loadData];
}
#pragma mark --- YWTManagerFooterViewDelegate --------
// 添加账号
-(void) selectAddAccountBtn{
    YWTLoginViewController *loginVC = [[YWTLoginViewController alloc]init];
    loginVC.isAddAccount = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}
// 退出账号
-(void) selectOutAccountBtn{
    // 删除用户信息
    [YWTNowLoginManager delLoginModel];
    [YWTNowLoginManager shareInstance].loginModel = nil;
    [GlobalAppDelegate checkLogin];
}
#pragma mark --- UITableViewDataSource --------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArr[section];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWTManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YWTMANAGERTABLEVIEW_CELL forIndexPath:indexPath];
    NSArray *arr = self.dataArr[indexPath.section];
    YWTAccountManagateModel *model = arr[indexPath.row];
    // 编辑模式  点击删除
    cell.model = model;
    WS(weakSelf);
    cell.selectDel = ^{
        [weakSelf delAccountPromptView:indexPath];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KSIphonScreenH(65);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YWTManagerHeaderView *headerView = [[YWTManagerHeaderView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 0)];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return KSIphonScreenH(78);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.isEditMode) {
        return nil;
    }else{
        YWTManagerFooterView *footerView = [[YWTManagerFooterView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 0)];
           footerView.delegate = self;
           return footerView;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.isEditMode) {
        return 0.01;
    }else{
         return KSIphonScreenH(84);
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isEditMode) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    // 取消之前选中
    NSMutableArray *oldSelectArr = [NSMutableArray arrayWithArray:self.dataArr[self.selectIndexPath.section]];
    YWTAccountManagateModel *oldModel = oldSelectArr[self.selectIndexPath.row];
    oldModel.cellStyleModel = @"0";
    // 贴换数据源
    [oldSelectArr replaceObjectAtIndex:self.selectIndexPath.row withObject:oldModel];
    [self.dataArr replaceObjectAtIndex:0 withObject:oldSelectArr];
    
    // 设置选中
    NSMutableArray *selectArr = [NSMutableArray arrayWithArray:self.dataArr[indexPath.section]];
    YWTAccountManagateModel *selectModel = selectArr[indexPath.row];
    selectModel.cellStyleModel = @"1";
    // 贴换数据源
    [selectArr replaceObjectAtIndex:indexPath.row withObject:selectModel];
    [self.dataArr replaceObjectAtIndex:0 withObject:selectArr];
    
    // 删除之前用户信息
    YWTLoginModel *loginModel = [[YWTDataBaseManager sharedManager]fetchLoginLoadDataUserId:selectModel.userId];
    NSDictionary *dict = loginModel.mj_keyValues;
    [YWTNowLoginManager delLoginModel];
    [YWTNowLoginManager saveLoginModel:dict];
    [YWTNowLoginManager shareInstance].loginModel = loginModel;
    
    // 刷新UI
    [self.managateTable reloadRowsAtIndexPaths:@[indexPath,self.selectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    // 记录选中位置
    self.selectIndexPath =  indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark --- 加载所有账号--------
-(void) loadData{
    [self.dataArr removeAllObjects];
    
    NSMutableArray *listArr = [NSMutableArray array];
    NSArray *list = [[YWTDataBaseManager sharedManager] fetchLoginList];
    NSString *nowUserId = [YWTNowLoginManager shareInstance].loginModel.userId;
    for (int i=0; i<list.count; i++) {
        YWTLoginModel *loginModel = list[i];
        YWTAccountManagateModel *model = [[YWTAccountManagateModel alloc]init];
        model.photoUrl = loginModel.headImage;
        model.compary = loginModel.organizationName;
        model.name = loginModel.userName;
        model.userId = loginModel.userId;
        if ([nowUserId isEqualToString:model.userId]) {
            model.cellStyleModel = @"1";
            // 设置选中
            self.selectIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        }else{
            model.cellStyleModel = @"0";
        }
        [listArr addObject:model];
    }
    [self.dataArr addObject:listArr];
    [self.managateTable reloadData];
}
#pragma mark --- 删除账号提示框--------
-(void) delAccountPromptView:(NSIndexPath *)indexPath{
    UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请问你确定要删除此账号吗？" preferredStyle:UIAlertControllerStyleAlert];
    alterVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [alterVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alterVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray *arr = self.dataArr[indexPath.section];
        YWTAccountManagateModel *model =arr[indexPath.row];
        // 先删除数据库中的数据源
        YWTLoginModel *loginModel = [[YWTDataBaseManager sharedManager]fetchLoginLoadDataUserId:model.userId];
        [[YWTDataBaseManager sharedManager]delLogin:loginModel];
        
        // 删除数组源
        [arr removeObjectAtIndex:indexPath.row];
        // 刷新UI
        [self.managateTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }]];
    [self presentViewController:alterVC animated:YES completion:nil];
    
}
#pragma mark --- 设置导航栏 --------
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    
    self.customNavBar.title = @"账号管理";
    WS(weakSelf);
    //编辑
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@""]];
    [self.customNavBar.rightButton  setTitle:@"编辑" forState:UIControlStateNormal];
    [self.customNavBar.rightButton setTitleColor:[UIColor colorCommonBlackColor] forState:UIControlStateNormal];
    self.customNavBar.rightButton.titleLabel.font = Font(16);
    self.customNavBar.rightButton.frame = CGRectMake(KScreenW - 50, KSStatusHeight, 40 , 44);
    [self.customNavBar setOnClickRightButton:^{
        weakSelf.isEditMode = !weakSelf.isEditMode;
        if (weakSelf.isEditMode) {
            [weakSelf.customNavBar.rightButton  setTitle:@"完成" forState:UIControlStateNormal];
            [weakSelf alterLoadDataIsEdit:YES];
        }else{
            [weakSelf.customNavBar.rightButton  setTitle:@"编辑" forState:UIControlStateNormal];
            [weakSelf alterLoadDataIsEdit:NO];
        }
        [weakSelf.managateTable reloadData];
    }];
}
-(void) alterLoadDataIsEdit:(BOOL)isEdit{
    NSArray *arr = [NSArray arrayWithArray:self.dataArr[0]];
    NSMutableArray *mutableArr = [NSMutableArray array];
    // 当前账号
    NSString *nowUserId = [YWTNowLoginManager shareInstance].loginModel.userId;
    for (YWTAccountManagateModel *model in arr) {
        if (isEdit) {
            if ([model.userId isEqualToString:nowUserId]) {
                // 当编辑时 ，当前登录账号不可删除
                model.cellStyleModel = @"1";
            }else{
                model.cellStyleModel = @"2";
            }
        }else{
           if ([model.userId isEqualToString:nowUserId]) {
                // 当编辑时 ，当前登录账号不可删除
                model.cellStyleModel = @"1";
            }else{
                model.cellStyleModel = @"0";
            }
        }
        [mutableArr addObject:model];
    }
    [self.dataArr replaceObjectAtIndex:0 withObject:mutableArr];
}
#pragma mark --- get --------
-(UITableView *)managateTable{
    if (!_managateTable) {
        _managateTable = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH) style:UITableViewStyleGrouped];
        _managateTable.delegate = self;
        _managateTable.dataSource = self;
        _managateTable.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
        _managateTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_managateTable registerClass:[YWTManagerTableViewCell class] forCellReuseIdentifier:YWTMANAGERTABLEVIEW_CELL];
        if (@available(iOS 11.0, *)) {
            _managateTable.estimatedRowHeight = 0;
            _managateTable.estimatedSectionFooterHeight = 0;
            _managateTable.estimatedSectionHeaderHeight = 0 ;
            _managateTable.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _managateTable;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}



@end
