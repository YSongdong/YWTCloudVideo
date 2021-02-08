//
//  YWTLineViewController.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/13.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTLineViewController.h"

#import "YWTLineDetailController.h"

#import "YWTHeaderSearchView.h"
#import "YWTLineListCell.h"
#define YWTLINELIST_CELL @"YWTLineListCell"
@interface YWTLineViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
YWTHeaderSearchViewDelegate
>
@property (nonatomic,strong)  YWTHeaderSearchView *headerSearchView;

@property (nonatomic,strong) YWTBlankPageView *blankPageView;

@property (nonatomic,strong) UITableView *lineTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;
// 搜索
@property (nonatomic,strong) NSString *queStr;

@end

@implementation YWTLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    // 设置Navi
    [self setNavi];
    //创建搜索view
    [self createSearchView];
    // tableview
    [self.view addSubview:self.lineTableView];
    if (self.listType == showTableViewListTowerType) {
        WS(weakSelf);
        [self.lineTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.headerSearchView.mas_bottom);
            make.left.bottom.right.equalTo(weakSelf.view);
        }];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestLoadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWTLineListCell *cell = [tableView dequeueReusableCellWithIdentifier:YWTLINELIST_CELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.listType == showTableViewListLineType) {
        cell.listType = showCellListLineType;
    }else{
        cell.listType = showCellListTowerType;
    }
    cell.dict = self.dataArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KSIphonScreenH(80);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listType == showTableViewListLineType) {
        NSDictionary *dict = self.dataArr[indexPath.row];
        YWTLineViewController *lineVC = [[YWTLineViewController alloc]init];
        lineVC.listType = showTableViewListTowerType;
        lineVC.hidesBottomBarWhenPushed = YES;
        lineVC.lineId = [NSString stringWithFormat:@"%@",dict[@"id"]];
        lineVC.naviTitleStr = [NSString stringWithFormat:@"%@",dict[@"line_name"]];
        [self.navigationController pushViewController:lineVC animated:YES];
    }else if (self.listType == showTableViewListTowerType){
        YWTLineDetailController *detailVC = [[YWTLineDetailController alloc]init];
        NSDictionary *dict = self.dataArr[indexPath.row];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.titleStr = [NSString stringWithFormat:@"GT%@",dict[@"tower_name"]];
        detailVC.towerId = [NSString stringWithFormat:@"%@",dict[@"tower_id"]];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark --- YWTHeaderSearchViewDelegate ---
-(void) selectSearchBtn:(NSString*)searchStr{
    self.queStr = searchStr;
    [self requestLoadData];
}
#pragma mark ----- 设置Navi  -----
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    
    if (self.listType == showTableViewListLineType) {
        self.customNavBar.title = @"线路巡检";
        [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@""]];
        self.customNavBar.onClickLeftButton = ^{
            
        };
    }else{
        self.customNavBar.title = self.naviTitleStr;
    }
    
}
#pragma mark ----- 创建搜索view  -----
-(void) createSearchView{
    self.headerSearchView =[[YWTHeaderSearchView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KSIphonScreenH(55))];
    [self.view addSubview:self.headerSearchView];
    if (self.listType == showTableViewListLineType) {
        self.headerSearchView.searchTF.placeholder = @"输入线路名称搜索";
    }else{
        self.headerSearchView.searchTF.placeholder = @"输入杆塔名称搜索";
    }
    self.headerSearchView.delegate = self;
}
#pragma mark -----get  -----
-(UITableView *)lineTableView{
    if (!_lineTableView) {
        _lineTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight+CGRectGetHeight(self.headerSearchView.frame), KScreenW, KScreenH-KSNaviTopHeight-KSTabBarHeight-CGRectGetHeight(self.headerSearchView.frame))];
        _lineTableView.backgroundColor = [UIColor colorCommonF5BgViewColor];
        _lineTableView.delegate = self;
        _lineTableView.dataSource = self;
        _lineTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _lineTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [_lineTableView registerClass:[YWTLineListCell class] forCellReuseIdentifier:YWTLINELIST_CELL];
        
        WS(weakSelf);
        [_lineTableView bindGlobalStyleForHeadRefreshHandler:^{
            [weakSelf requestLoadData];
        }];
        
        if (@available(iOS 11.0, *)) {
            _lineTableView.estimatedRowHeight = 0;
            _lineTableView.estimatedSectionFooterHeight = 0;
            _lineTableView.estimatedSectionHeaderHeight = 0 ;
            _lineTableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _lineTableView;
}
-(YWTBlankPageView *)blankPageView{
    if (!_blankPageView) {
        _blankPageView = [[YWTBlankPageView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight+CGRectGetHeight(self.headerSearchView.frame), KScreenW, KScreenH-KSNaviTopHeight-KSTabBarHeight-CGRectGetHeight(self.headerSearchView.frame))];
    }
    return _blankPageView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(void)setListType:(showTableViewListType)listType{
    _listType = listType;
}
-(void)setNaviTitleStr:(NSString *)naviTitleStr{
    _naviTitleStr = naviTitleStr;
}
-(void)setLineId:(NSString *)lineId{
    _lineId = lineId;
}
#pragma mark ---- 数据相关 -------
-(void) requestLoadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"que"] = self.queStr;
    if (self.listType == showTableViewListLineType) {
        [[YWTHttpManager sharedManager]getRequestUrl:HTTP_APIWECHATLINELIST_URL params:param waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
            [self.lineTableView.headRefreshControl endRefreshing];
            if (error) {
                [self.view showErrorWithTitle:error];
                return ;
            }
            NSArray *arr = showdata[@"data"];
            if (![arr isKindOfClass:[NSArray class]]) {
                return;
            }
            [self.dataArr removeAllObjects];
            [self.blankPageView removeFromSuperview];
            
            [self.dataArr addObjectsFromArray:arr];
            
            if (self.dataArr.count == 0) {
                [self.view addSubview:self.blankPageView];
            }
            [self.lineTableView reloadData];
        }];
    }else{
        param[@"line_id"] = self.lineId;
        [[YWTHttpManager sharedManager]postRequestUrl:HTTP_APIWECHATMYTOWERELIST_URL params:param waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
            [self.lineTableView.headRefreshControl endRefreshing];
            if (error) {
                [self.view showErrorWithTitle:error];
                return ;
            }
            NSArray *arr = showdata[@"data"];
            if (![arr isKindOfClass:[NSArray class]]) {
                return;
            }
            [self.dataArr removeAllObjects];
            [self.blankPageView removeFromSuperview];
            
            [self.dataArr addObjectsFromArray:arr];
            if (self.dataArr.count == 0) {
                [self.view addSubview:self.blankPageView];
            }
            [self.lineTableView reloadData];
        }];
    }
    
}






@end
