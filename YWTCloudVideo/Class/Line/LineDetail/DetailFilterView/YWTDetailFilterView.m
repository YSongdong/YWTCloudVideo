//
//  YWTDetailFilterView.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/22.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTDetailFilterView.h"

#import "YWTCollectHeaderView.h"

#import "YWTDetailFitlerModel.h"
#import "YWTFilterOrientedCell.h"
#define YWTFILTERORIENTED_CELL @"YWTFilterOrientedCell"

@interface YWTDetailFilterView ()
<
 UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic,strong) UICollectionView *filterCollection;

@property (nonatomic,strong) NSMutableArray *dataArr;
// 选中数组
@property (nonatomic,strong) NSMutableArray *selectArr;

@end

@implementation YWTDetailFilterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createFilterView];
    }
    return self;
}
#pragma mark ---- UICollectionViewDataSource ---
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArr.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arr = self.dataArr[section];
    return arr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YWTFilterOrientedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YWTFILTERORIENTED_CELL forIndexPath:indexPath];
    cell.cellType = showDetailOrienCellType;
    cell.indexPath = indexPath;
    NSArray *arr = self.dataArr[indexPath.section];
    YWTDetailFitlerModel *model  = arr[indexPath.row];
    cell.model = model;
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.dataArr[indexPath.section];
    YWTDetailFitlerModel *model  = arr[indexPath.row];
    CGFloat with = [self calculateRowWidth:model.name];
    return CGSizeMake(with, 45);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YWTCollectHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HEADER" forIndexPath:indexPath];
        NSString *text = nil;
        if (indexPath.section == 0) {
            text = @"朝向";
        }else if (indexPath.section == 1){
            text = @"设备";
        }else if (indexPath.section == 2){
            text = @"时间";
        }
        headerView.titleLab.text = text;
        return headerView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FOOTER" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorTextWhiteColor] normalCorlor:[UIColor colorCommonF5BgViewColor]];
        return footerView;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(KScreenW, KSIphonScreenH(35));
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(KScreenW,1);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row != 0) {
            NSArray *arr = self.dataArr[indexPath.section];
            YWTDetailFitlerModel *model  = arr[indexPath.row];
            [self requestLoadDeviceListCode:model.code];
        }
    }else if (indexPath.section == 2){
        if (self.selectArr.count == 2) {
            [self.selectArr addObject:indexPath];
            // 当前
            NSMutableArray *nowOrienArr = self.dataArr[indexPath.section];
            YWTDetailFitlerModel *nowModel = nowOrienArr[indexPath.row];
            nowModel.isSelect = YES;
            //贴换数据源
            [nowOrienArr replaceObjectAtIndex:indexPath.row withObject:nowModel];
            [self.dataArr replaceObjectAtIndex:indexPath.section withObject:nowOrienArr];
            
            // 刷新数据源
            [self.filterCollection reloadItemsAtIndexPaths:@[indexPath]];
            return;
        }else{
            NSIndexPath *oldIndexPath = self.selectArr[indexPath.section];
            if (oldIndexPath.row == indexPath.row) {
                // 当前
                NSMutableArray *nowOrienArr = self.dataArr[indexPath.section];
                YWTDetailFitlerModel *nowModel = nowOrienArr[indexPath.row];
                nowModel.isSelect = NO;
                //贴换数据源
                [nowOrienArr replaceObjectAtIndex:indexPath.row withObject:nowModel];
                [self.dataArr replaceObjectAtIndex:indexPath.section withObject:nowOrienArr];
                // 贴换选中的数据源
                [self.selectArr replaceObjectAtIndex:indexPath.section withObject:indexPath];
                // 刷新数据源
                [self.filterCollection reloadItemsAtIndexPaths:@[indexPath]];
                return;
            }
        }
    }
    NSIndexPath *oldIndexPath = self.selectArr[indexPath.section];
    NSMutableArray *oldOrienArr =self.dataArr[oldIndexPath.section];
    YWTDetailFitlerModel *oritentModel = oldOrienArr[oldIndexPath.row];
    oritentModel.isSelect = NO;
    
    //贴换数据源
    [oldOrienArr replaceObjectAtIndex:oldIndexPath.row withObject:oritentModel];
    [self.dataArr replaceObjectAtIndex:indexPath.section withObject:oldOrienArr];
    
    // 当前
    NSMutableArray *nowOrienArr = self.dataArr[indexPath.section];
    YWTDetailFitlerModel *nowModel = nowOrienArr[indexPath.row];
    nowModel.isSelect = YES;
    //贴换数据源
    [nowOrienArr replaceObjectAtIndex:indexPath.row withObject:nowModel];
    [self.dataArr replaceObjectAtIndex:indexPath.section withObject:nowOrienArr];
    
    // 贴换选中的数据源
    [self.selectArr replaceObjectAtIndex:indexPath.section withObject:indexPath];
    
    // 刷新数据源
    [self.filterCollection reloadItemsAtIndexPaths:@[oldIndexPath,indexPath]];
}
#pragma mark ---- 计算宽度 ----
-(CGFloat) calculateRowWidth:(NSString*)string {
    NSDictionary *dict = @{NSFontAttributeName :Font(14)};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 45) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil];
    return rect.size.width+20;
}
#pragma mark ---- 创建----
-(void) createFilterView{
    UIView *bigBgView = [[UIView alloc]initWithFrame:self.frame];
    [self addSubview:bigBgView];
    bigBgView.backgroundColor = [UIColor blackColor];
    bigBgView.alpha = 0.35;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap)];
    [bigBgView addGestureRecognizer:tap];
    
    WS(weakSelf);
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-KSTabbarH);
        make.height.equalTo(@(KSIphonScreenH(300)));
    }];
    
    UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:trueBtn];
    [trueBtn setTitle:@"确定" forState:UIControlStateNormal];
    [trueBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    trueBtn.titleLabel.font = Font(16);
    [trueBtn setBackgroundImage:[YWTTools imageWithColor:[UIColor colorCommonGreenColor]] forState:UIControlStateNormal];
    [trueBtn setBackgroundImage:[YWTTools imageWithColor:[[UIColor colorCommonGreenColor]colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
    [trueBtn addTarget:self action:@selector(selectTrueBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView).offset(-KSIphonScreenH(10));
        make.left.equalTo(bgView).offset(KSIphonScreenW(15));
        make.right.equalTo(bgView).offset(-KSIphonScreenW(15));
        make.height.equalTo(@40);
        make.centerX.equalTo(bgView.mas_centerX);
    }];
    trueBtn.layer.cornerRadius = 40/2;
    trueBtn.layer.masksToBounds = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, KSIphonScreenW(15), 0, KSIphonScreenW(15));
    
    self.filterCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [bgView addSubview:self.filterCollection];
    self.filterCollection.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
    self.filterCollection.delegate = self;
    self.filterCollection.dataSource = self;
    [self.filterCollection registerClass:[YWTFilterOrientedCell class] forCellWithReuseIdentifier:YWTFILTERORIENTED_CELL];
    [self.filterCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FOOTER"];
    [self.filterCollection registerClass:[YWTCollectHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HEADER"];
    [self.filterCollection mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(trueBtn.mas_top);
        make.top.left.right.equalTo(bgView);
    }];
}
-(void) selectTap{
    [self removeFromSuperview];
}
// 确定
-(void) selectTrueBtnAction:(UIButton*)sender{
    NSString *orientationCode = @"";
    NSString *deviceId = @"";
    NSString *day = @"";
    for (int i=0; i<self.selectArr.count; i++) {
        NSIndexPath * orienIndexPath = self.selectArr[i];
        NSArray *arr = self.dataArr[orienIndexPath.section];
        YWTDetailFitlerModel *model = arr[orienIndexPath.row];
        if (i == 0) {
            orientationCode = model.value;
        }else if(i== 1){
            deviceId = model.value;
        }else{
            day = model.value;
        }
    }
    if ([self.delegate respondsToSelector:@selector(selectFilterViewOrien:andDeviceId:andTime:)]) {
        [self.delegate selectFilterViewOrien:orientationCode andDeviceId:deviceId andTime:day];
    }
}
#pragma mark ---- get ---
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        
        NSMutableArray *orientedArr = [NSMutableArray array];
        YWTDetailFitlerModel *oritentModel = [[YWTDetailFitlerModel alloc]init];
        oritentModel.name = @"全部";
        oritentModel.value = @"";
        oritentModel.isSelect = YES;
        [orientedArr addObject:oritentModel];
        
        NSMutableArray *deviceArr = [NSMutableArray array];
        YWTDetailFitlerModel *deviceModel = [[YWTDetailFitlerModel alloc]init];
        deviceModel.name = @"全部";
        deviceModel.value = @"";
        deviceModel.isSelect = YES;
        [deviceArr addObject:deviceModel];
        
        NSMutableArray *timeArr = [NSMutableArray array];
        YWTDetailFitlerModel *nowDayModel = [[YWTDetailFitlerModel alloc]init];
        nowDayModel.name = @"今天";
        nowDayModel.value = @"0";
        YWTDetailFitlerModel *yesterDayModel = [[YWTDetailFitlerModel alloc]init];
        yesterDayModel.name = @"昨天";
        yesterDayModel.value = @"-1";
        YWTDetailFitlerModel *sevenDayModel = [[YWTDetailFitlerModel alloc]init];
        sevenDayModel.name = @"近7天";
        sevenDayModel.value = @"7";
        YWTDetailFitlerModel *oneMonthModel = [[YWTDetailFitlerModel alloc]init];
        oneMonthModel.name = @"近30天";
        oneMonthModel.value = @"30";
        [timeArr addObject:nowDayModel];
        [timeArr addObject:yesterDayModel];
        [timeArr addObject:sevenDayModel];
        [timeArr addObject:oneMonthModel];
        
        [_dataArr  addObject:orientedArr];
        [_dataArr  addObject:deviceArr];
        [_dataArr  addObject:timeArr];
    }
    return _dataArr;
}

-(NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
        NSIndexPath *oritentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *deviceIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [_selectArr addObject:oritentIndexPath];
        [_selectArr addObject:deviceIndexPath];
    }
    return _selectArr;
}
-(void)setTowerId:(NSString *)towerId{
    _towerId = towerId;
    [self requestLoadOrienListData];
}
#pragma mark  ------  数据相关 --------
//杆塔下对应监拍朝向
-(void) requestLoadOrienListData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"tower_id"] = self.towerId;
    [[YWTHttpManager sharedManager] getRequestUrl:HTTP_APIWECHATORIENLIST_URL params:param waitView:self complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        if (error) {
            [self showErrorWithTitle:error];
            return ;
        }
        id data = showdata[@"data"];
        if (![data isKindOfClass:[NSArray class]]) {
            return;
        }
        NSArray *listArr = (NSArray*)data;
        NSMutableArray *orientedArr = self.dataArr[0];
        for (NSDictionary *dict in listArr) {
             YWTDetailFitlerModel *oritentModel = [[YWTDetailFitlerModel alloc]init];
            oritentModel.Id = dict[@"id"];
            oritentModel.name = dict[@"orientation_name"];
            oritentModel.code = dict[@"orientation_code"];
            oritentModel.deviceId = dict[@"photo_device_id"];
            oritentModel.value = dict[@"orientation_code"];
            oritentModel.isSelect = NO;
            [orientedArr addObject:oritentModel];
        }
        // 刷新
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.filterCollection reloadSections:indexSet];
    }];
}
// 查询朝向下设备list
-(void)requestLoadDeviceListCode:(NSString*)code{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"tower_id"] = self.towerId;
    param[@"orientation_code"] = code;
    [[YWTHttpManager sharedManager]postRequestUrl:HTTP_APIWECHATDEVICELIST_URL params:param waitView:self complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        if (error) {
            [self showErrorWithTitle:error];
            return ;
        }
        id data = showdata[@"data"];
        if (![data isKindOfClass:[NSArray class]]) {
            return;
        }
        NSArray *listArr = (NSArray*)data;
        NSMutableArray *orientedArr = self.dataArr[1];
        // 先移除 数据
        for (int i= 1; i<orientedArr.count; i++) {
            [orientedArr removeObjectAtIndex:i];
        }
        for (NSDictionary *dict in listArr) {
             YWTDetailFitlerModel *oritentModel = [[YWTDetailFitlerModel alloc]init];
            oritentModel.Id = dict[@"id"];
            oritentModel.name = dict[@"device_model_name"];
            oritentModel.code = dict[@"cms_code"];
            oritentModel.deviceId = dict[@"iccid"];
            oritentModel.value = dict[@"id"];
            oritentModel.isSelect = NO;
            [orientedArr addObject:oritentModel];
        }
        //更新选中
        NSIndexPath *deviceIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.selectArr replaceObjectAtIndex:1 withObject:deviceIndexPath];
        
        YWTDetailFitlerModel *model = orientedArr[0];
        model.isSelect = YES;
        //贴换数据源
        [orientedArr replaceObjectAtIndex:0 withObject:model];
        [self.dataArr replaceObjectAtIndex:1 withObject:orientedArr];
        // 刷新UI
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        [self.filterCollection reloadSections:indexSet];
    }];
}



@end
