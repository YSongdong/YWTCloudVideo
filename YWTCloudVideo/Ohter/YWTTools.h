//
//  YWTTools.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/12.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTTools : NSObject
// 判断是深色模式
+(BOOL)judgeStyleDark;
// 获取机型
+ (NSString *)getCurrentDeviceModel; 
//根据颜色值来生成UIImage
+ (UIImage *)imageWithColor:(UIColor *)color;
//图片显示 placeholderStr 默认图片
+(void)sd_setImageView:(UIImageView *)imageView WithURL:(NSString *)str andPlaceholder:(NSString *)placeholderStr;
/**
 * 抽取成一个方法
 * 传入控制器、标题、正常状态下图片、选中状态下图片
 * 直接调用这个方法就可以了
 */
+ (void)controller:(UIViewController *)controller Title:(NSString *)title tabBarItemImage:(NSString *)image tabBarItemSelectedImage:(NSString *)selectedImage;
//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font;
/**
 改变字体和颜色
 @param totalStr 总文字
 @param textArr 改变的文字 数组
 @param textColor 改变文字颜色
 @return    UIlabel  富文本
 */
+(NSMutableAttributedString *) getAttrbuteTotalStr:(NSString *)totalStr  andAlterTextArr:(NSArray *)textArr andTextColor:(UIColor *)textColor andTextFont:(UIFont *) textFont;
@end

NS_ASSUME_NONNULL_END
