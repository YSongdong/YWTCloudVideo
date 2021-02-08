//
//  YWTDetailHeaderView.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/22.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWTDetailHeaderViewDelegate <NSObject>
// 选择图片或者视频  1 图片 2 视频
-(void)selectPhotoOrVideoBtnActionTag:(NSInteger)tag;
// 筛选
-(void)selectSiftBtnAction;
@end
@interface YWTDetailHeaderView : UIView
@property (nonatomic,weak) id <YWTDetailHeaderViewDelegate>delegate;

@end


