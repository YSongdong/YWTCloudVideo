//
//  YWTMessageViewController.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/13.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTMessageViewController.h"

#import "YBPopupMenu.h"
#import "YWTMessageHeaderView.h"
#import "YWTToolViewHandler.h"
#import "YWTMessageListCell.h"
#define YWTMESSAGELIST_CELL @"YWTMessageListCell"

@interface YWTMessageViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
YBPopupMenuDelegate
>
// 菜单view
@property (nonatomic,strong) YBPopupMenu *popupMuenView;
@property (nonatomic,strong) YWTBlankPageView *blankPageView;
@property (nonatomic,strong) UITableView *msgTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSString *queryDtoStr;
@end

@implementation YWTMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    self.page = 1;
    self.queryDtoStr = @"";
    //  设置Navi
    [self setNavi];
    
    [self.view addSubview:self.msgTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏导航栏线条
    [self.customNavBar  wr_setBottomLineHidden:YES];
    // 请求数据
    [self requestLoadMessagetList];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //显示导航栏线条
    [self.customNavBar  wr_setBottomLineHidden:NO];
}

#pragma mark ----- UITableViewDataSource -----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWTMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:YWTMESSAGELIST_CELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.cellType =  showMessagelCellListType;
    cell.dict =  dict;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dict = self.dataArr[indexPath.row];
     return [YWTMessageListCell getWithListCellHeight:dict andCellType:showMessagelCellListType];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *datas = [NSMutableArray array];
   [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           YBIBImageData *data = [YBIBImageData new];
           data.imageURL = [NSURL URLWithString:obj[@"src"]];
           data.extraData = [NSString stringWithFormat:@"%@-%@-%@",obj[@"line_name"],obj[@"tower_name"],obj[@"orientation_name"]];
           [datas addObject:data];
   }];
   YBImageBrowser *browser = [YBImageBrowser new];
   browser.dataSourceArray = datas;
   browser.currentPage = indexPath.row;
   browser.toolViewHandlers = @[YWTToolViewHandler.new];
   [browser show];
}

#pragma mark ----- 设置Navi  -----
-(void) setNavi{

    [self.customNavBar wr_setBackgroundAlpha:1];
    self.customNavBar.title = @"消息";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@""]];
    self.customNavBar.onClickLeftButton = ^{
        
    };
    WS(weakSelf);
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@""]];
    [self.customNavBar.rightButton setTitle:@" 全部" forState:UIControlStateNormal];
    [self.customNavBar.rightButton setTitleColor:[UIColor colorStyleLeDarkWithConstantColor:[[UIColor colorTextWhiteColor]colorWithAlphaComponent:0.7] normalCorlor:[UIColor colorConstantStylGrayeDarkColor]] forState:UIControlStateNormal];
    self.customNavBar.rightButton.titleLabel.font = Font(16);
    [self.customNavBar.rightButton setImage:[UIImage imageNamed:@"mine_xx_xl"] forState:UIControlStateNormal];
    [self.customNavBar.rightButton LZSetbuttonType:LZCategoryTypeLeft];
    self.customNavBar.rightButton.frame = CGRectMake(KScreenW - 80, KSStatusHeight, 70 , 44);
    self.customNavBar.onClickRightButton = ^{
        weakSelf.popupMuenView  = [YBPopupMenu showAtPoint:CGPointMake(KScreenW-35, KSNaviTopHeight) titles:@[@"全部",@"实时",@"告警"] icons:@[] menuWidth:70 otherSettings:^(YBPopupMenu *popupMenu) {
            popupMenu.delegate = weakSelf;
            popupMenu.arrowPosition = KScreenW-100;
        }];
    };
}
#pragma mark ----- YBPopupMenuDelegate  -----
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            self.queryDtoStr = @"";
            break;
        }
        case 1:
        {
            self.queryDtoStr = @"-1";
            break;
        }
        case 2:
        {
            self.queryDtoStr = @"-2";
            break;
        }
        default:
            break;
    }
    self.page = 1;
    [self requestLoadMessagetList];
}
#pragma mark ----- get  -----
-(UITableView *)msgTableView{
    if (!_msgTableView) {
        _msgTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabBarHeight)];
        _msgTableView.backgroundColor = [UIColor colorCommonBgViewColor];
        _msgTableView.delegate = self;
        _msgTableView.dataSource = self;
        _msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_msgTableView registerClass:[YWTMessageListCell class] forCellReuseIdentifier:YWTMESSAGELIST_CELL];
        WS(weakSelf);
        [_msgTableView bindGlobalStyleForHeadRefreshHandler:^{
            weakSelf.page = 1;
            [weakSelf requestLoadMessagetList];
        }];
        [_msgTableView bindGlobalStyleForFootRefreshHandler:^{
            weakSelf.page ++ ;
            [weakSelf requestLoadMessagetList];
        }];
        
    }
    return _msgTableView;
}
-(YWTBlankPageView *)blankPageView{
    if (!_blankPageView) {
        _blankPageView = [[YWTBlankPageView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabBarHeight)];
    }
    return _blankPageView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return  _dataArr;
}
#pragma mark --- 数据相关 ----
-(void) requestLoadMessagetList{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"queryDto"] = self.queryDtoStr;
    param[@"page"] = [NSNumber numberWithInteger:self.page];
    [[YWTHttpManager sharedManager] postRequestUrl:HTTP_APIWECHATMOITORMESSAGE_URL params:param waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        [self.msgTableView.headRefreshControl endRefreshing];
        [self.msgTableView.footRefreshControl endRefreshing];
        if (error) {
            [self.view showErrorWithTitle:error];
            return ;
        }
        id data = showdata[@"data"];
        if (![data isKindOfClass:[NSArray class]]) {
            return;
        }
        if (self.page == 1) {
            [self.dataArr removeAllObjects];
        }
        NSArray *listArr =(NSArray*) data;
        [self.dataArr addObjectsFromArray:listArr];
        if (self.dataArr.count == 0) {
            [self.view addSubview:self.blankPageView];
        }else{
            [self.blankPageView removeFromSuperview];
        }
        [self.msgTableView reloadData];
    }];
}



@end
