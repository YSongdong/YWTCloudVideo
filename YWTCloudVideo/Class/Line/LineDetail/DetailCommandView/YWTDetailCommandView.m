//
//  YWTDetailCommandView.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/29.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTDetailCommandView.h"

#import "YWTCollectHeaderView.h"
#import "YWTFilterOrientedCell.h"
#define YWTFILTERORIENTED_CELL  @"YWTFilterOrientedCell"



@interface YWTDetailCommandView ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UICollectionView *commandCollection;

@property (nonatomic,strong) NSMutableArray *dataArr;
// 选中数组
@property (nonatomic,strong) NSMutableArray *selectArr;
@end

@implementation YWTDetailCommandView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createCommandView];
    }
    return self;
}
#pragma mark ---- UICollectionViewDataSource ---
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArr.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *dict = self.dataArr[section];
    NSArray *arr = dict[@"listArr"];
    return arr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YWTFilterOrientedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YWTFILTERORIENTED_CELL forIndexPath:indexPath];
    cell.cellType = showDetailCommandCellType;
    cell.indexPath = indexPath;
    NSDictionary *dict = self.dataArr[indexPath.section];
    NSArray *arr = dict[@"listArr"];
    YWTDetailFitlerModel *model  = arr[indexPath.row];
    cell.model = model;
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArr[indexPath.section];
    NSArray *arr = dict[@"listArr"];
    YWTDetailFitlerModel *model  = arr[indexPath.row];
    CGFloat with = [self calculateRowWidth:model.name];
    return CGSizeMake(with, 45);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YWTCollectHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HEADER" forIndexPath:indexPath];
        NSDictionary   *dict = self.dataArr[indexPath.section];
        headerView.titleLab.text = dict[@"keyName"];
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
        // 设备
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[indexPath.section]];
        NSMutableArray *arr =[NSMutableArray arrayWithArray:dict[@"listArr"]];
        YWTDetailFitlerModel *model  = arr[indexPath.row];
        model.isSelect = YES;
        
        // 选中
        NSMutableArray *selectDeviceArr = self.selectArr[indexPath.section];
        if (selectDeviceArr.count == 0) {
            [selectDeviceArr addObject:indexPath];
        }else{
            NSIndexPath *oldIndexPath = selectDeviceArr[0];
            if (oldIndexPath.row != indexPath.row) {
                NSMutableDictionary *oldDict = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[oldIndexPath.section]];
                NSMutableArray *oldArr =[NSMutableArray arrayWithArray:oldDict[@"listArr"]];
                YWTDetailFitlerModel *model  = oldArr[oldIndexPath.row];
                model.isSelect = NO;
                [selectDeviceArr replaceObjectAtIndex:0 withObject:indexPath];
                 // 刷新UI
                [self.commandCollection reloadItemsAtIndexPaths:@[oldIndexPath]];
            }
        }
        // 刷新UI
        [self.commandCollection reloadItemsAtIndexPaths:@[indexPath]];
        
        if (self.commandType == showDetailCommandPhotoType || self.commandType == showDetailCommandVideoType) {
            dispatch_async(dispatch_get_main_queue(), ^{
                  [self requestLoadDeviceChannelId:model.deviceId];
             });
        }
    }else{
            // 选中
            NSMutableArray *selectArr = self.selectArr[indexPath.section];
            if (selectArr.count == 0) {
                if (self.commandType == showDetailCommandPhotoType) {
                    /* -------拍照--------*/
                    /* ---- ----当点击全部时 ---- - - -*/
                    if (indexPath.row == 0) {
                        [self getWithSelectDataAll:YES andSelectIndexPath:indexPath];
                    }else{
                        /* ---- ----单选 ---- - - -*/
                        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[indexPath.section]];
                        NSMutableArray *arr =[NSMutableArray arrayWithArray:dict[@"listArr"]];
                        YWTDetailFitlerModel *model  = arr[indexPath.row];
                        model.isSelect = YES;
                        
                        [selectArr addObject:indexPath];
                        // 刷新数据源
                        [self.commandCollection reloadItemsAtIndexPaths:@[indexPath]];
                        // 当单选 满足全部时
                        if ([self judgeIsSelectAllDataIndexPath:indexPath]) {
                            [self getWithSelectDataAll:YES andSelectIndexPath:indexPath];
                        }
                    }
                }else{
                    /* -------视频--------*/
                    /* ---- ----单选 ---- - - -*/
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[indexPath.section]];
                    NSMutableArray *arr =[NSMutableArray arrayWithArray:dict[@"listArr"]];
                    YWTDetailFitlerModel *model  = arr[indexPath.row];
                    model.isSelect = YES;
                    
                    [selectArr addObject:indexPath];
                    // 刷新数据源
                    [self.commandCollection reloadItemsAtIndexPaths:@[indexPath]];
                }
            }else{
                if (self.commandType == showDetailCommandPhotoType) {
                    /* -------拍照--------*/
                    /* ---- ----当点击全部时 ---- - - -*/
                    if (indexPath.row == 0) {
                        if ([self getWithDataArr:selectArr andFindIndexPath:indexPath]) {
                            [self getWithSelectDataAll:NO andSelectIndexPath:indexPath];
                        }else{
                            [self getWithSelectDataAll:YES andSelectIndexPath:indexPath];
                        }
                    }else{
                        /* ---- ----单选 ---- - - -*/
                        if ([self getWithDataArr:selectArr andFindIndexPath:indexPath]) {
                            NSString *indexStr = [self getWithDataArr:selectArr findLocation:indexPath];
                            [selectArr removeObjectAtIndex:[indexStr intValue]];
                        }else{
                            [selectArr addObject:indexPath];
                        }
                        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[indexPath.section]];
                        NSMutableArray *arr =[NSMutableArray arrayWithArray:dict[@"listArr"]];
                        YWTDetailFitlerModel *model  = arr[indexPath.row];
                        model.isSelect = !model.isSelect;
                        // 刷新数据源
                        [self.commandCollection reloadItemsAtIndexPaths:@[indexPath]];
                        // 当单选 满足全部时
                        if ([self judgeIsSelectAllDataIndexPath:indexPath]) {
                            [self getWithSelectDataAll:YES andSelectIndexPath:indexPath];
                        }else{
                            YWTDetailFitlerModel *model= arr[0];
                            model.isSelect = NO;
                            NSIndexPath *allIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
                            // 刷新数据源
                           [self.commandCollection reloadItemsAtIndexPaths:@[indexPath,allIndexPath]];
                            NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
                            if ([self getWithDataArr:selectArr andFindIndexPath:selectIndexPath]) {
                                NSString *indexStr = [self getWithDataArr:selectArr findLocation:indexPath];
                                [selectArr removeObjectAtIndex:[indexStr intValue]];
                            }
                
                        }
                    }
                }else{
                    /* -------视频--------*/
                    /* ---- ----单选 ---- - - -*/
                   if ([self getWithDataArr:selectArr andFindIndexPath:indexPath]) {
                       NSString *indexStr = [self getWithDataArr:selectArr findLocation:indexPath];
                       [selectArr removeObjectAtIndex:[indexStr intValue]];
                   }else{
                       [selectArr addObject:indexPath];
                   }
                   NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[indexPath.section]];
                   NSMutableArray *arr =[NSMutableArray arrayWithArray:dict[@"listArr"]];
                   YWTDetailFitlerModel *model  = arr[indexPath.row];
                   model.isSelect = !model.isSelect;
                   // 刷新数据源
                   [self.commandCollection reloadItemsAtIndexPaths:@[indexPath]];
                }
            }
    }
}
///  判断数组是否包含元素
/// @param arr 数组源
/// @param findIndexPath 元素
-(BOOL) getWithDataArr:(NSArray*)arr andFindIndexPath:(NSIndexPath*)findIndexPath{
    BOOL isEqual = NO;
    for (NSIndexPath *indexPath in arr) {
        if ([indexPath isEqual:findIndexPath]) {
            isEqual = YES;
        }
    }
    return isEqual;
}
/// 查找元素位置
/// @param arr 数组
/// @param fIndexPath 元素
/// @ return  NSString   等于空 没有找到
-(NSString*) getWithDataArr:(NSArray*)arr findLocation:(NSIndexPath*)fIndexPath{
    NSString *indexStr = @"";
    for (int i=0; i<arr.count; i++) {
        NSIndexPath *indexPath = arr[i];
       if ([indexPath isEqual:fIndexPath]) {
           indexStr =[NSString stringWithFormat:@"%d",i];
        }
    }
    return indexStr;
}
// 点击全部
-(void)getWithSelectDataAll:(BOOL)isSelect andSelectIndexPath:(NSIndexPath*)indexPath{
    // 数据源
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[indexPath.section]];
    NSMutableArray *arr =[NSMutableArray arrayWithArray:dict[@"listArr"]];
    //选中数组
    NSMutableArray *selectArr = self.selectArr[indexPath.section];
    for (int i=0; i<arr.count; i++) {
        YWTDetailFitlerModel *model  = arr[i];
        model.isSelect = isSelect;
        NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        if (![self getWithDataArr:selectArr andFindIndexPath:selectIndexPath]) {
            [selectArr addObject:selectIndexPath];
        }
    }
    if (!isSelect) {
        [selectArr removeAllObjects];
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
    [self.commandCollection reloadSections:indexSet];
}
// 判断是否选择全部  默认yes
-(BOOL) judgeIsSelectAllDataIndexPath:(NSIndexPath*)indexPath{
    BOOL isSelectAll = YES;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[indexPath.section]];
    NSMutableArray *arr =[NSMutableArray arrayWithArray:dict[@"listArr"]];
    for (int i=1; i<arr.count; i++) {
        YWTDetailFitlerModel *model  = arr[i];
        if (!model.isSelect) {
            isSelectAll = NO;
        }
    }
    return  isSelectAll;
}
#pragma mark ---- 计算宽度 ----
-(CGFloat) calculateRowWidth:(NSString*)string {
    NSDictionary *dict = @{NSFontAttributeName :Font(14)};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 45) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil];
    return rect.size.width+20;
}
#pragma mark ---- 创建----
-(void) createCommandView{
    UIView *bigBgView = [[UIView alloc]initWithFrame:self.frame];
    [self addSubview:bigBgView];
    bigBgView.backgroundColor = [UIColor blackColor];
    bigBgView.alpha = 0.35;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap)];
    [bigBgView addGestureRecognizer:tap];
    
    WS(weakSelf);
    self.bgView = [[UIView alloc]init];
    [self addSubview:self.bgView];
    self.bgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-KSTabbarH);
        make.height.equalTo(@(KSIphonScreenH(300)));
    }];
    
    UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bgView addSubview:trueBtn];
    [trueBtn setTitle:@"确定" forState:UIControlStateNormal];
    [trueBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    trueBtn.titleLabel.font = Font(16);
    [trueBtn setBackgroundImage:[YWTTools imageWithColor:[UIColor colorCommonGreenColor]] forState:UIControlStateNormal];
    [trueBtn setBackgroundImage:[YWTTools imageWithColor:[[UIColor colorCommonGreenColor]colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
    [trueBtn addTarget:self action:@selector(selectTrueBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.bgView).offset(-KSIphonScreenH(10));
        make.left.equalTo(weakSelf.bgView).offset(KSIphonScreenW(15));
        make.right.equalTo(weakSelf.bgView).offset(-KSIphonScreenW(15));
        make.height.equalTo(@40);
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
    }];
    trueBtn.layer.cornerRadius = 40/2;
    trueBtn.layer.masksToBounds = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, KSIphonScreenW(15), 0, KSIphonScreenW(15));
    
    self.commandCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.bgView addSubview:self.commandCollection];
    self.commandCollection.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorConstantStyleDarkColor] normalCorlor:[UIColor colorTextWhiteColor]];
    self.commandCollection.delegate = self;
    self.commandCollection.dataSource = self;
    [self.commandCollection registerClass:[YWTFilterOrientedCell class] forCellWithReuseIdentifier:YWTFILTERORIENTED_CELL];
    [self.commandCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FOOTER"];
    [self.commandCollection registerClass:[YWTCollectHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HEADER"];
    [self.commandCollection mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(trueBtn.mas_top).offset(-KSIphonScreenH(5));
        make.top.left.right.equalTo(weakSelf.bgView);
    }];
}
-(void) selectTap{
    [self removeFromSuperview];
}
// 确定
-(void) selectTrueBtnAction:(UIButton*)sender{
    NSMutableArray *channels = [NSMutableArray array];
    NSMutableArray *presets = [NSMutableArray array];
    // 选中设备
    NSMutableArray *selectDeviceArr = self.selectArr[0];
    NSIndexPath *deviceIndexPath = selectDeviceArr[0];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[deviceIndexPath.section]];
    NSMutableArray *arr =[NSMutableArray arrayWithArray:dict[@"listArr"]];
    YWTDetailFitlerModel *model  = arr[deviceIndexPath.row];
    
    if (self.commandType ==showDetailCommandPhotoType ) {
        //拍照
        for (int i=1; i<self.selectArr.count; i++) {
            NSArray *channelArr = self.selectArr[i];
            NSMutableArray *listArr = [NSMutableArray array];
            NSMutableDictionary *channelDict = [NSMutableDictionary dictionary];
            for (int j =0; j<channelArr.count; j++) {
                NSIndexPath *channelIndexPath = channelArr[j];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[channelIndexPath.section]];
                channelDict[@"channel_cms_code"] = dict[@"channelCmsCode"];
                NSMutableArray *arr =[NSMutableArray arrayWithArray:dict[@"listArr"]];
                YWTDetailFitlerModel *model  = arr[channelIndexPath.row];
                if (![model.name isEqualToString:@"全部"]) {
                    [listArr addObject:model];
                }
            }
            channelDict[@"preset_list"] =listArr;
            [channels addObject:channelDict];
        }
        
    }else if (self.commandType == showDetailCommandVideoType){
        for (int i=1; i<self.selectArr.count; i++) {
               NSArray *channelArr = self.selectArr[i];
               for (int j =0; j<channelArr.count; j++) {
                   NSIndexPath *channelIndexPath = channelArr[j];
                   NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[channelIndexPath.section]];
                   NSMutableArray *arr =[NSMutableArray arrayWithArray:dict[@"listArr"]];
                   YWTDetailFitlerModel *model  = arr[channelIndexPath.row];
                  [presets addObject:model];
               }
           }
    }
    if ([self.delegate respondsToSelector:@selector(selectDevice:channels:presets:commandType:)]) {
        [self.delegate selectDevice:model channels:presets presets:channels commandType:self.commandType];
    }
}
#pragma mark ---- get ----
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}
-(void)setCommandType:(showDetailCommandType)commandType{
    _commandType = commandType;
}
-(void)setTowerId:(NSString *)towerId{
    _towerId = towerId;
    [self requestLoadTowerdevice];
}
#pragma mark ---- 数据相关 -----
-(void) requestLoadTowerdevice{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.towerId;
    [[YWTHttpManager sharedManager]postRequestUrl:HTTP_APIWECHATMOITORTOWERDEVICE_URL params:param waitView:self complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        if (error) {
            [self showErrorWithTitle:error];
            return ;
        }
        id data = showdata[@"data"];
        if (![data isKindOfClass:[NSArray class]]) {
            return;
        }
        NSArray *arr = (NSArray*)data;
        NSMutableDictionary *nameDict = [NSMutableDictionary dictionary];
        nameDict[@"keyName"] = @"设备";
        NSMutableArray *listArr = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            YWTDetailFitlerModel *model = [[YWTDetailFitlerModel alloc]init];
            model.name = dict[@"device_name"];
            model.deviceId =  dict[@"device_id"];
            [listArr addObject:model];
        }
        nameDict[@"listArr"] = listArr;
        [self.dataArr addObject:nameDict];
        
        // 默认选中
        NSMutableArray *deviceArr = [NSMutableArray array];
        [self.selectArr addObject:deviceArr];
        
        // 刷新
        [self.commandCollection reloadData];
        
        if (self.commandType == showDetailCommandWakeType) {
            CGFloat height = self.commandCollection.collectionViewLayout.collectionViewContentSize.height;
            WS(weakSelf);
            [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(weakSelf);
                make.bottom.equalTo(weakSelf).offset(-KSTabbarH);
                make.height.equalTo(@(height+60));
            }];
        }
    }];
}
//查询设备通道预置位
-(void) requestLoadDeviceChannelId:(NSString *)Id{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = Id;
    [[YWTHttpManager sharedManager]postRequestUrl:HTTP_APIWECHATMOITORDEVICECHANNELPRESET_URL params:param waitView:self complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        if (error) {
            [self showErrorWithTitle:error];
            return ;
        }
  
        // 先移除选中数据源
        NSMutableArray *deviceArr = [self.selectArr firstObject];
        [self.selectArr removeAllObjects];
        [self.selectArr addObject:deviceArr];
       
        // 先移除数据源
        NSDictionary *deviceDict = [self.dataArr firstObject];
        [self.dataArr removeAllObjects];
        [self.dataArr addObject:deviceDict];
       
        id data = showdata[@"data"];
//        if (![data isKindOfClass:[NSArray class]] || ![data isKindOfClass:[NSMutableArray class]]) {
//            return;
//        }
        NSArray *arr = (NSArray*)data;
        if (self.commandType == showDetailCommandPhotoType ) {
            /* -------拍照--------*/
            for (NSDictionary *dict in arr) {
                NSMutableDictionary *channelDict = [NSMutableDictionary dictionary];
                channelDict[@"keyName"]=dict[@"channel_name"];
                channelDict[@"channelCmsCode"]=dict[@"channel_cms_code"];
                NSMutableArray *listArr = [NSMutableArray array];
                YWTDetailFitlerModel *model = [[YWTDetailFitlerModel alloc]init];
                model.name = @"全部";
                model.value =  @"";
                model.isSelect= NO;
                [listArr addObject:model];
                NSArray *plistArr = dict[@"preset_list"];
                for (NSDictionary *dic in plistArr) {
                    YWTDetailFitlerModel *model = [[YWTDetailFitlerModel alloc]init];
                    model.name = dic[@"value"];
                    model.value =  dic[@"key"];
                    model.code=dict[@"channel_cms_code"];
                    model.isSelect= NO;
                    [listArr addObject:model];
                }
                channelDict[@"listArr"] = listArr;
                [self.dataArr addObject:channelDict];
                // 默认选中
                NSMutableArray *channelArr = [NSMutableArray array];
                [self.selectArr addObject:channelArr];
            }
        }else{
            /* -------视频--------*/
            NSMutableDictionary *channelDict = [NSMutableDictionary dictionary];
            channelDict[@"keyName"]=@"通道";
            NSMutableArray *listArr = [NSMutableArray array];
            for (NSDictionary *dict in arr) {
                YWTDetailFitlerModel *model = [[YWTDetailFitlerModel alloc]init];
                model.value = dict[@"channel_number"];
                model.name = dict[@"channel_name"];
                model.code = dict[@"channel_cms_code"];
                model.isSelect= NO;
                [listArr addObject:model];
            }
            channelDict[@"listArr"] = listArr;
            [self.dataArr addObject:channelDict];
            
            // 默认选中
            NSMutableArray *channelArr = [NSMutableArray array];
            [self.selectArr addObject:channelArr];
        }
        
        // 刷新
        [self.commandCollection reloadData];

//        CGFloat height = self.commandCollection.collectionViewLayout.collectionViewContentSize.height;
//        height = height > 300 ? 300:height;
//        WS(weakSelf);
//        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(weakSelf);
//            make.bottom.equalTo(weakSelf).offset(-KSTabbarH);
//            make.height.equalTo(@(height+60));
//        }];
    }];
}




@end
