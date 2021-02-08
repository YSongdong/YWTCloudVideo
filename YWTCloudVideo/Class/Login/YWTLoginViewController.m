//
//  YWTLoginViewController.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/12.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTLoginViewController.h"

#import "YWTLoginSettingController.h"

#import "YWTLoginBaseStyleCell.h"
#import "YWTLoginTypeCell.h"
#import "YWTLoginSubmitCell.h"
#import "YWTLoginHeaderView.h"

#import "YWTLoginModel.h"

@interface YWTLoginViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
YWTLoginTypeCellDelegate,
YWTLoginBaseStyleCellDelegate,
YWTLoginSubmitCellDelegate
>
// 公司代码
@property (nonatomic,strong)YWTLoginBaseStyleCell *comparyLoginCell;
// 账号
@property (nonatomic,strong) YWTLoginBaseStyleCell *accountLoginCell;
// 密码
@property (nonatomic,strong) YWTLoginBaseStyleCell *pwdLoginCell;
// 手机
@property (nonatomic,strong) YWTLoginBaseStyleCell *iphoneLoginCell;
// 验证码
@property (nonatomic,strong) YWTLoginBaseStyleCell *vCodeCell;
// 登录type
@property (nonatomic,strong) YWTLoginTypeCell *typeCell;
// 登录cell
@property (nonatomic,strong) YWTLoginSubmitCell *submitCell;

@property (nonatomic,strong) YWTLoginHeaderView *headerView;

@property (nonatomic,strong) UITableView *loginTable;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation YWTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置Navi
    [self setNavi];
    // 设置背景ImageV
    UIImageView *bgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSTabbarH)];
    bgImageV.image = [UIImage imageNamed:@"login_bg"];
    [self.view insertSubview:bgImageV atIndex:0];
    // 添加数据源
    [self.dataArr addObject:self.typeCell];
    [self.dataArr addObject:self.comparyLoginCell];
    [self.dataArr addObject:self.accountLoginCell];
    [self.dataArr addObject:self.pwdLoginCell];
    [self.dataArr addObject:self.submitCell];
    // 创建TableView
    [self.view insertSubview:self.loginTable atIndex:1];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.dataArr[indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }else if (indexPath.row == 4){
        return 90;
    }else{
       return 54;
    }
}

#pragma mark ---- YWTLoginSubmitCellDelegate ------
// 点击登录
-(void) selectLoginBtnAction{
    [self.view endEditing:YES];
    
    [self requestLogin];
}
#pragma mark ----- 设置Navi  -----
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:0];
    
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    // 是不是添加add账号  YES 是 NO 不是 （默认为NO）
    if (self.isAddAccount) {
        WS(weakSelf);
        [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"navi_back"]];
        self.customNavBar.onClickLeftButton = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }else{
       [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@""]];
        self.customNavBar.onClickLeftButton = ^{
            
        };
    }
    
    //设置
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"login_ico_sz"]];
    WS(weakSelf);
    self.customNavBar.onClickRightButton = ^{
        YWTLoginSettingController *loginSettingVC = [[YWTLoginSettingController alloc]init];
        [weakSelf.navigationController pushViewController:loginSettingVC animated:YES];
    };
}
#pragma mark ------ YWTLoginTypeCellDelegate ------
// 选择登录类型
-(void) selectLoginTypeIndex:(NSInteger)index{
     if (index == 0) {
         // 贴换数据源
         [self.dataArr replaceObjectAtIndex:2 withObject:self.accountLoginCell];
         [self.dataArr replaceObjectAtIndex:3 withObject:self.pwdLoginCell];
         // 刷新UI
         NSIndexPath *accountIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
         NSIndexPath *pwdIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
         [self.loginTable reloadRowsAtIndexPaths:@[accountIndexPath,pwdIndexPath] withRowAnimation:UITableViewRowAnimationNone];
         self.typeCell.isAccountLogin = YES;
     }else {
         // 贴换数据源
         [self.dataArr replaceObjectAtIndex:2 withObject:self.iphoneLoginCell];
         [self.dataArr replaceObjectAtIndex:3 withObject:self.vCodeCell];
         // 刷新UI
         NSIndexPath *accountIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
         NSIndexPath *pwdIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
         [self.loginTable reloadRowsAtIndexPaths:@[accountIndexPath,pwdIndexPath] withRowAnimation:UITableViewRowAnimationNone];
         self.typeCell.isAccountLogin = NO;
     }
}
#pragma mark ------ YWTLoginBaseStyleCellDelegate ------
// 点击获取验证码
-(void) selectObtainVCodeBtn{
    if (self.iphoneLoginCell.loginTextField.text.length == 0) {
        [self.view showErrorWithTitle:@"请输入手机号码"];
    }
}
-(void)closeKeyBoard{
    [self.view endEditing:YES];
}
#pragma mark -----  get   -----
-(UITableView *)loginTable{
    if (!_loginTable) {
        _loginTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSTabbarH)];
        _loginTable.delegate = self;
        _loginTable.dataSource = self;
        _loginTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _loginTable.tableHeaderView = self.headerView;
        _loginTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _loginTable.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
        [_loginTable addGestureRecognizer:tap];
        if (@available(iOS 11.0, *)) {
            _loginTable.estimatedRowHeight = 0;
            _loginTable.estimatedSectionFooterHeight = 0;
            _loginTable.estimatedSectionHeaderHeight = 0 ;
            _loginTable.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _loginTable;
}
-(YWTLoginBaseStyleCell *)accountLoginCell{
    if (!_accountLoginCell) {
        _accountLoginCell = [[YWTLoginBaseStyleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ACCOOUNTLOGIN_NCELL"];
        _accountLoginCell.leftNormalImageStr = @"login_account";
        _accountLoginCell.placeholderStr = @"账号";
        _accountLoginCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _accountLoginCell;
}
-(YWTLoginBaseStyleCell *)comparyLoginCell{
    if (!_comparyLoginCell) {
        _comparyLoginCell = [[YWTLoginBaseStyleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"COMPARYLOGIN_NCELL"];
        _comparyLoginCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _comparyLoginCell;
}
-(YWTLoginBaseStyleCell *)pwdLoginCell{
    if (!_pwdLoginCell) {
        _pwdLoginCell = [[YWTLoginBaseStyleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PWDLOGIN_NCELL"];
        _pwdLoginCell.stypeCell = showBaseStylePwdCell;
        _pwdLoginCell.leftNormalImageStr = @"login_mm";
        _pwdLoginCell.placeholderStr = @"密码";
        _pwdLoginCell.selectionStyle = UITableViewCellSelectionStyleNone;
       }
    return _pwdLoginCell;
}
-(YWTLoginBaseStyleCell *)iphoneLoginCell{
    if (!_iphoneLoginCell) {
        _iphoneLoginCell = [[YWTLoginBaseStyleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IPHONELOGIN_NCELL"];
        _iphoneLoginCell.stypeCell = showBaseStyleIphoeCell;
        _iphoneLoginCell.leftNormalImageStr = @"login_phone";
        _iphoneLoginCell.placeholderStr = @"手机号";
        _iphoneLoginCell.selectionStyle = UITableViewCellSelectionStyleNone;
       }
    return _iphoneLoginCell;
}
-(YWTLoginBaseStyleCell *)vCodeCell{
    if (!_vCodeCell) {
        _vCodeCell = [[YWTLoginBaseStyleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IPHONELOGIN_NCELL"];
        _vCodeCell.stypeCell = showBaseStyleCodeCell;
        _vCodeCell.placeholderStr = @"验证码";
        _vCodeCell.leftNormalImageStr = @"login_yzm";
        _vCodeCell.delegate = self;
        _vCodeCell.selectionStyle = UITableViewCellSelectionStyleNone;
       }
    return _vCodeCell;
}
-(YWTLoginTypeCell *)typeCell{
    if (!_typeCell) {
        _typeCell = [[YWTLoginTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LOGINTYPE_NCELL"];
        _typeCell.isAccountLogin = YES;
        _typeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _typeCell.delegate = self;
    }
    return _typeCell;
}
-(YWTLoginSubmitCell *)submitCell{
    if (!_submitCell) {
        _submitCell = [[YWTLoginSubmitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LOGINSUBMIT_NCELL"];
        _submitCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _submitCell.delegate = self;
        if (self.isAddAccount) {
           [_submitCell.loginBtn setTitle:@"添加账号" forState:UIControlStateNormal];
        }
        
    }
    return _submitCell;
}
-(YWTLoginHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YWTLoginHeaderView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KSIphonScreenH(280))];
    }
    return _headerView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(void)setIsAddAccount:(BOOL)isAddAccount{
    _isAddAccount = isAddAccount;
}

#pragma mark --- 登录 ------
-(void) requestLogin{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"username"] = self.accountLoginCell.loginTextField.text;
    NSString *pwd =self.pwdLoginCell.loginTextField.text;
    // Base64加解密
    NSData *encodeData = [pwd dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
    param[@"password"] = base64String;
    param[@"code"] = self.comparyLoginCell.loginTextField.text;
    param[@"type"] = @"IOS";
    param[@"model"] = [YWTTools getCurrentDeviceModel];
    [[YWTHttpManager sharedManager]postRequestUrl:HTTP_APIAPPLOGIN_URL params:param waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        if (error) {
            [self.view showErrorWithTitle:error];
            return ;
        }
        NSDictionary *data = showdata[@"data"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            return;
        }
        YWTLoginModel *model = [YWTLoginModel yy_modelWithDictionary:data];

        
        // 添加用户信息到本地数据库中
        [[YWTDataBaseManager sharedManager]saveServer:model];
        // 注册别名
        [JPUSHService setAlias:model.userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            if (iResCode == 0) {
                NSLog(@"------1111-----");
            }
        } seq:1];
        
        // 是不是添加add账号  YES 是 NO 不是 （默认为NO）
        if (self.isAddAccount) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
           // 删除用户信息
           [YWTNowLoginManager delLoginModel];
           // 保存到数据
            NSDictionary *dict = model.mj_keyValues;
           [YWTNowLoginManager saveLoginModel:dict];
           [YWTNowLoginManager shareInstance].loginModel = model;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [GlobalAppDelegate checkLogin];
            });
        }
    }];
}




@end
