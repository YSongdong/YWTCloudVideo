//
//  UIColor+ColorChange.h
//  PlayDemo
//
//  Created by tiao on 2018/1/12.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)
//文字白色
+ (UIColor *) colorTextWhiteColor;
//文字常用黑色
+ (UIColor *) colorCommonBlackColor;
//文字常用灰黑色
+ (UIColor *) colorCommonGrayBlackColor;
//文字常用绿色
+ (UIColor *) colorCommonGreenColor;
//常用线条颜色
+ (UIColor *) colorCommonLineColor;
//常用View背景色
+ (UIColor *) colorCommonBgViewColor;
//常用F5View背景色
+ (UIColor *) colorCommonF5BgViewColor;


// 黑暗主颜色
+ (UIColor *) colorConstantStyleDarkColor;
// 黑暗浅灰颜色
+ (UIColor *) colorConstantStylGrayeDarkColor;

// 适配黑暗模式的颜色
+ (UIColor *) colorStyleLeDarkWithConstantColor:(UIColor*)ConstantColor normalCorlor:(UIColor*)normalColor;

+ (UIColor *) colorWithHexString: (NSString *)color;

@end
