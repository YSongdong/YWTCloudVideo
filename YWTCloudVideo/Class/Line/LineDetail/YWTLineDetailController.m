//
//  YWTLineDetailController.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/22.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTLineDetailController.h"

#import "YWTDetailHeaderView.h"
#import "YWTDetailFilterView.h"
#import "YWTLineTooltipView.h"
#import "YWTToolView.h"
#import "YWTToolViewHandler.h"
#import "YWTDetailCommandView.h"

#import "YWTMessageListCell.h"
#define YWTMESSAGELIST_CELL @"YWTMessageListCell"

@interface YWTLineDetailController ()
<
UITableViewDelegate,
UITableViewDataSource,
YWTDetailHeaderViewDelegate,
YWTDetailFilterViewDelegate,
YWTToolViewDelegate,
YWTDetailCommandViewDelegate
>

@property (nonatomic,strong)YWTDetailHeaderView *headerView;

@property (nonatomic,strong) YWTDetailFilterView *filterView;
// 提示框
@property (nonatomic,strong) YWTLineTooltipView *lineTooltipView;

@property (nonatomic,strong) YWTDetailCommandView *detailCommandView;

@property (nonatomic,strong) YWTBlankPageView *blankPageView;

@property (nonatomic,strong) UITableView *dateTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;
// 查询类型
@property (nonatomic,strong) NSString *typeStr;
// 分页
@property (nonatomic,assign) NSInteger page;
//  监拍朝向代码 ,
@property (nonatomic,strong) NSString *orientationCode;
//  设备ID
@property (nonatomic,strong) NSString *deviceId;
//  日期快速查询
@property (nonatomic,strong) NSString *day;
@end

@implementation YWTLineDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    self.page = 1;
    self.typeStr = @"picture";
    self.orientationCode = @"";
    self.deviceId = @"";
    self.day = @"";
    // 设置Navi
    [self setNavi];
    // 创建headerView
    [self createHeaderView];
    
    [self.view addSubview:self.dateTableView];
    // 创建工具view
    [self createToolView];
    //请求数据
    [self requestLoadMoniterAllData];
}
#pragma mark ----- UITableViewDataSource  -----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWTMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:YWTMESSAGELIST_CELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellType = showDetailCellListType;
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.dict = dict;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArr[indexPath.row];
    return [YWTMessageListCell getWithListCellHeight:dict andCellType:showDetailCellListType];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *datas = [NSMutableArray array];
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.typeStr isEqualToString:@"picture"]) {
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = [NSURL URLWithString:obj[@"src"]];
            data.extraData = [NSString stringWithFormat:@"%@-%@-%@",obj[@"line_name"],obj[@"tower_name"],obj[@"orientation_name"]];
            [datas addObject:data];
        }else{
            YBIBVideoData *data = [YBIBVideoData new];
            data.videoURL = [NSURL URLWithString:obj[@"src"]];
            data.extraData = [NSString stringWithFormat:@"%@-%@-%@",obj[@"line_name"],obj[@"tower_name"],obj[@"orientation_name"]];
            [datas addObject:data];
        }
    }];
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = indexPath.row;
    browser.toolViewHandlers = @[YWTToolViewHandler.new];
    [browser show];
}
#pragma mark ----- 创建headerView  -----
-(void) createHeaderView{
    self.headerView = [[YWTDetailHeaderView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KSIphonScreenH(55))];
    [self.view addSubview:self.headerView];
    self.headerView.delegate = self;
}
#pragma mark --- 按钮点击----
-(void) createBtnActionClick{
    self.detailCommandView = [[YWTDetailCommandView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSTabbarH)];
    [self.view addSubview:self.detailCommandView];
    self.detailCommandView.towerId = self.towerId;
//    self.detailCommandView.commandType = showDetailCommandVideoType;
}
#pragma mark ----- 创建搜索view  -----
-(void) createFilterView{
    self.filterView = [[YWTDetailFilterView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSTabbarH)];
    [self.view addSubview:self.filterView];
    self.filterView.towerId = self.towerId;
    self.filterView.delegate = self;
}
#pragma  mark ----YWTDetailFilterViewDelegate ----
-(void) selectFilterViewOrien:(NSString*)orien andDeviceId:(NSString*)deviceId andTime:(NSString*)time{
    [self.filterView removeFromSuperview];
    self.orientationCode = orien;
    self.deviceId = deviceId;
    self.day = time;
    self.page = 1;
    [self requestLoadMoniterAllData];
}
#pragma mark ----- YWTDetailHeaderViewDelegate  -----
// 选择图片或者视频  1 图片 2 视频
-(void)selectPhotoOrVideoBtnActionTag:(NSInteger)tag{
    self.typeStr = tag == 1 ? @"picture" : @"realtime";
    self.page = 1;
    [self requestLoadMoniterAllData];
}
// 筛选
-(void)selectSiftBtnAction{
    [self createFilterView];
}
#pragma mark ----- 创建工具view  -----
-(void) createToolView{
    WS(weakSelf);
    YWTToolView *toolView = [[YWTToolView alloc]init];
    [self.view addSubview:toolView];
    toolView.delegate = self;
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(KSIphonScreenH(150)));
        make.width.equalTo(@50);
        make.right.equalTo(weakSelf.view.mas_right).offset(-KSIphonScreenW(20));
        make.centerY.equalTo(weakSelf.view.mas_centerY).offset(KSIphonScreenH(10));
    }];
}
#pragma mark ---- YWTToolViewDelegate ----
-(void) selectToolBtnActionTag:(NSInteger)btnTag{
    self.detailCommandView = [[YWTDetailCommandView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSTabbarH)];
    self.detailCommandView.towerId = self.towerId;
    self.detailCommandView.delegate = self;
    switch (btnTag - 200) {
        case 0:
        {  // 拍照
            self.detailCommandView.commandType = showDetailCommandPhotoType;
            break;
        }
        case 1:
        { // 录像
            self.detailCommandView.commandType = showDetailCommandVideoType;
            break;
        }
        case 2:
        { // 唤醒
             self.detailCommandView.commandType = showDetailCommandWakeType;
            break;
        }
        default:
            break;
    }
    [self.view addSubview:self.detailCommandView];
    /*
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.lineTooltipView];
    BOOL isWake = btnTag == 202 ? "YES":"NO";
    if (isWake) {
        self.lineTooltipView.showContentLab.text = @"发送指令唤醒设备?";
    }
    WS(weakSelf);
    NSMutableDictionary *param  = [NSMutableDictionary dictionary];
    param[@"device_id"] = self.deviceId;
    param[@"orientation_code"] = self.orientationCode;
    param[@"tower_id"] = self.towerId;
    self.lineTooltipView.selectTrueBtn = ^{
        switch (btnTag - 200) {
            case 0:
            {  // 拍照
                param[@"type"] = @"picture";
                break;
            }
            case 1:
            { // 录像
                param[@"type"] = @"realtime";
                break;
            }
            case 2:
            { // 唤醒
                param[@"type"] = @"wake";
                break;
            }
            default:
                break;
        }
        // 移除提示框
        [weakSelf.lineTooltipView removeFromSuperview];
        [weakSelf requestLoadMonitorSendDict:param.copy];
    };
     */
}
#pragma mark --- YWTDetailCommandViewDelegate ------
// 选中的设备 通道数组 预置位数组
-(void) selectDevice:(YWTDetailFitlerModel*)deciceModel channels:(NSArray*)channels presets:(NSArray*)prsets commandType:(showDetailCommandType)commandType{
    // 移除弹框
    [self.detailCommandView removeFromSuperview];
    
    NSString *typeStr = @"";
    if (commandType == showDetailCommandPhotoType) {
        typeStr = @"picture";
    }else if (commandType == showDetailCommandVideoType){
        typeStr = @"realtime";
    }else{
        typeStr = @"wake";
    }
    NSMutableDictionary *param  = [NSMutableDictionary dictionary];
    param[@"device_id"] = deciceModel.deviceId;
    param[@"type"] = typeStr;
    param[@"tower_id"] = self.towerId;
    
    NSMutableString *mutabletitleStr =[NSMutableString string];
    // 通道
    NSMutableArray *channelArr = [NSMutableArray array];
    for (int i=0; i<channels.count; i++) {
        YWTDetailFitlerModel *model = channels[i];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"channel_cms_code"] = model.code;
        dict[@"preset_list"] =  @[];
        [channelArr addObject:dict];
        [mutabletitleStr appendString:[NSString stringWithFormat:@"【%@】",model.name]];
    }

    // 预置位
    for (int i=0; i<prsets.count; i++) {
        NSDictionary *presetDict = prsets[i];
        if ([[presetDict allKeys] containsObject:@"channel_cms_code"]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"channel_cms_code"] = presetDict[@"channel_cms_code"];
            NSArray *listArr = presetDict[@"preset_list"];
            NSMutableArray *mutableArr = [NSMutableArray array];
            for (int i=0; i<listArr.count; i++) {
                YWTDetailFitlerModel *model = listArr[i];
                [mutableArr addObject:model.value];
                [mutabletitleStr appendString:[NSString stringWithFormat:@"【%@】",model.name]];
            }
            dict[@"preset_list"]= mutableArr;
            [channelArr addObject:dict];
        }
    }
    param[@"channel"] =channelArr;
    
    // 提示框
    NSString *typeMarkStr = @"";
    NSString *showStr = @"";
    if (commandType == showDetailCommandPhotoType) {
        typeMarkStr = @"【图片】";
       showStr = [NSString stringWithFormat:@"此操作将发送指令给%@采集%@是否继续?",mutabletitleStr,typeMarkStr];
    }else if (commandType == showDetailCommandVideoType){
        typeMarkStr = @"【视频】";
        showStr = [NSString stringWithFormat:@"此操作将发送指令给%@采集%@是否继续?",mutabletitleStr,typeMarkStr];
    }else{
        [mutabletitleStr appendString:deciceModel.name];
        typeMarkStr = @"【唤醒】";
        showStr = [NSString stringWithFormat:@"此操作将发送指令给%@设备%@是否继续?",mutabletitleStr,typeMarkStr];
    }
   [[UIApplication sharedApplication].keyWindow addSubview:self.lineTooltipView];
   self.lineTooltipView.showContentLab.attributedText = [YWTTools getAttrbuteTotalStr:showStr andAlterTextArr:@[typeMarkStr,mutabletitleStr] andTextColor:[UIColor colorCommonGreenColor] andTextFont:Font(14)];
    WS(weakSelf);
    self.lineTooltipView.selectTrueBtn = ^{
        // 移除弹框
//        [weakSelf.lineTooltipView removeFromSuperview];
        [weakSelf requestLoadMonitorSendDict:param];
    };
}
#pragma mark ----- 设置Navi  -----
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    self.customNavBar.title = self.titleStr;
}
#pragma mark ----- get  -----
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
}
-(void)setTowerId:(NSString *)towerId{
    _towerId =towerId;
}
-(UITableView *)dateTableView{
    if (!_dateTableView) {
        _dateTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight+CGRectGetHeight(self.headerView.frame), KScreenW, KScreenH-KSNaviTopHeight-CGRectGetHeight(self.headerView.frame)-KSTabbarH)];
        _dateTableView.backgroundColor = [UIColor colorCommonBgViewColor];
        _dateTableView.delegate = self;
        _dateTableView.dataSource = self;
        _dateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dateTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [_dateTableView registerClass:[YWTMessageListCell class] forCellReuseIdentifier:YWTMESSAGELIST_CELL];
        WS(weakSelf);
        [_dateTableView bindGlobalStyleForHeadRefreshHandler:^{
            weakSelf.page = 1;
            [weakSelf requestLoadMoniterAllData];
        }];
        [_dateTableView bindGlobalStyleForFootRefreshHandler:^{
            weakSelf.page ++;
            [weakSelf requestLoadMoniterAllData];
        }];
        
        if (@available(iOS 11.0, *)) {
            _dateTableView.estimatedRowHeight = 0;
            _dateTableView.estimatedSectionFooterHeight = 0;
            _dateTableView.estimatedSectionHeaderHeight = 0 ;
            _dateTableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _dateTableView;
}
-(YWTBlankPageView *)blankPageView{
    if (!_blankPageView) {
        _blankPageView = [[YWTBlankPageView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight+CGRectGetHeight(self.headerView.frame), KScreenW, KScreenH-KSNaviTopHeight-KSTabBarHeight-CGRectGetHeight(self.headerView.frame))];
    }
    return _blankPageView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(YWTLineTooltipView *)lineTooltipView{
    if (!_lineTooltipView) {
        _lineTooltipView = [[YWTLineTooltipView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSTabbarH)];
    }
    return _lineTooltipView;
}

#pragma mark --- 数据相关 ----
-(void) requestLoadMoniterAllData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.typeStr;
    param[@"tower_id"] = self.towerId;
    param[@"page"] = [NSNumber numberWithInteger:self.page];
    param[@"day"] = self.day;
    param[@"device_id"] = self.deviceId;
    param[@"orientation_code"] = self.orientationCode;
    param[@"size"] = @"20";
    param[@"end_time"] = @"";
    param[@"start_time"] = @"";
    param[@"alarm_status"] = @"";
    param[@"resource"] = @"1";
    [[YWTHttpManager sharedManager]postRequestUrl:HTTP_APIWECHATMONITORALL_URL params:param waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        [self.dateTableView.headRefreshControl endRefreshing];
        [self.dateTableView.footRefreshControl endRefreshing];
        if (error) {
            [self.view showErrorWithTitle:error];
            return ;
        }
        id  data = showdata[@"data"];
        if (![data isKindOfClass:[NSArray class]]) {
            return;
        }
        if (self.page == 1) {
            [self.dataArr removeAllObjects];
        }
        NSArray *listArr = (NSArray*)data;
        [self.dataArr addObjectsFromArray:listArr];
        if (self.dataArr.count == 0) {
            [self.view addSubview:self.blankPageView];
        }else{
            [self.blankPageView removeFromSuperview];
        }
        [self.dateTableView reloadData];
      }];
}
// 发送指令
-(void) requestLoadMonitorSendDict:(NSDictionary*)dict{
    [[YWTHttpManager sharedManager]postRequestUrl:HTTP_APIWECHATMOITORSEND_URL params:dict waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        
        if (error) {
            [self.view showErrorWithTitle:error];
            return ;
        }
        [self.view showSuccessWithTitle:@"发送成功"];
    }];
}


@end
