//
//  YWTDetailFilterView.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/22.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWTDetailFilterViewDelegate <NSObject>

-(void) selectFilterViewOrien:(NSString*)orien andDeviceId:(NSString*)deviceId andTime:(NSString*)time;

@end

@interface YWTDetailFilterView : UIView

@property (nonatomic,weak) id <YWTDetailFilterViewDelegate>delegate;

@property (nonatomic,strong) NSString *towerId;

@end

