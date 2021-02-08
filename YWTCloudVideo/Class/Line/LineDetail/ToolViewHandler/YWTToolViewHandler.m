//
//  YWTToolViewHandler.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/27.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTToolViewHandler.h"

#import "YBIBImageData.h"
#import "YBIBToastView.h"

@interface YWTToolViewHandler () <YBIBOperateBrowserProtocol>

@property (nonatomic,strong) UIView *toolTopView;

@property (nonatomic,strong) UILabel *showTotalCountLab;

@property (nonatomic,strong) UILabel *showContentLab;

@end

@implementation YWTToolViewHandler
#pragma mark - <YBIBToolViewHandler>

@synthesize yb_containerView = _yb_containerView;
@synthesize yb_containerSize = _yb_containerSize;
@synthesize yb_currentPage = _yb_currentPage;
@synthesize yb_totalPage = _yb_totalPage;
@synthesize yb_currentOrientation = _yb_currentOrientation;
@synthesize yb_currentData = _yb_currentData;

- (void)yb_containerViewIsReadied {
    [self.yb_containerView addSubview:self.toolTopView];
    CGSize size = self.yb_containerSize(self.yb_currentOrientation());
    self.toolTopView.frame = CGRectMake(0, 0, size.width, 90);
    
    [self.toolTopView addSubview:self.showTotalCountLab];
    self.showTotalCountLab.frame = CGRectMake(20, 10, 40, 30);
    [self.toolTopView addSubview:self.showContentLab];
    self.showContentLab.frame = CGRectMake(20, 40, size.width-40, 50);
}
- (void)yb_hide:(BOOL)hide {
   
}
-(void)yb_pageChanged{
    id  data = self.yb_currentData();
    if ([data isKindOfClass:[YBIBImageData class]]) {
        YBIBImageData *data =(YBIBImageData*) self.yb_currentData();
        NSInteger page =self.yb_currentPage();
        self.showTotalCountLab.text = [NSString stringWithFormat:@"%ld/%ld",page+1,self.yb_totalPage()];
        
        NSString *name = data.extraData;
        self.showContentLab.text = [NSString stringWithFormat:@"%@",name];
    }else if([data isKindOfClass:[YBIBVideoData class]]){
        YBIBVideoData *data =(YBIBVideoData*) self.yb_currentData();
        NSInteger page =self.yb_currentPage();
        self.showTotalCountLab.text = [NSString stringWithFormat:@"%ld/%ld",page+1,self.yb_totalPage()];
        
        NSString *name = data.extraData;
        self.showContentLab.text = [NSString stringWithFormat:@"%@",name];
    }
}
#pragma mark ---- get -----
-(UIView *)toolTopView{
    if (!_toolTopView) {
        _toolTopView = [[UIView alloc]init];
    }
    return _toolTopView;
}
-(UILabel *)showTotalCountLab{
    if (!_showTotalCountLab) {
        _showTotalCountLab = [[UILabel alloc]init];
        _showTotalCountLab.textColor = [UIColor colorTextWhiteColor];
        _showTotalCountLab.font = Font(14);
        _showTotalCountLab.textAlignment = NSTextAlignmentCenter;
    }
    return _showTotalCountLab;
}
-(UILabel *)showContentLab{
    if (!_showContentLab) {
        _showContentLab = [[UILabel alloc]init];
        _showContentLab.textColor = [UIColor colorTextWhiteColor];
        _showContentLab.font = Font(14);
        _showContentLab.numberOfLines = 2;
    }
    return _showContentLab;
}


@end
