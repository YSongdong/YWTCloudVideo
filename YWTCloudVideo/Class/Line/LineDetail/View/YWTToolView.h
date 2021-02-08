//
//  YWTToolView.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/25.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWTToolViewDelegate <NSObject>

-(void) selectToolBtnActionTag:(NSInteger)btnTag;

@end

@interface YWTToolView : UIView

@property (nonatomic,weak) id <YWTToolViewDelegate>delegate;

@end


