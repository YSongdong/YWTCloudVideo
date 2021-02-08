//
//  UIColor+ColorChange.m
//  PlayDemo
//
//  Created by tiao on 2018/1/12.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "UIColor+ColorChange.h"

@implementation UIColor (ColorChange)

//文字白色
+ (UIColor *) colorTextWhiteColor{
    return [UIColor colorWithHexString:@"#ffffff"];
}
//文字常用黑色
+ (UIColor *) colorCommonBlackColor{
    UIColor *color = [self colorStyleLeDarkWithConstantColor:[self colorTextWhiteColor] normalCorlor:[UIColor colorWithHexString:@"#222222"]];
     return color;
}
//文字常用灰黑色
+ (UIColor *) colorCommonGrayBlackColor{
    UIColor *color = [self colorStyleLeDarkWithConstantColor:[[self colorTextWhiteColor]colorWithAlphaComponent:0.8] normalCorlor:[UIColor colorWithHexString:@"#999999"]];
     return color;
}
//文字常用绿色
+ (UIColor *) colorCommonGreenColor{
    return [UIColor colorWithHexString:@"#009588"];
}
//常用线条颜色
+ (UIColor *) colorCommonLineColor{
    return [UIColor colorWithHexString:@"#dddddd"];
}

//常用View背景色
+ (UIColor *) colorCommonBgViewColor{
    UIColor *color = [self colorStyleLeDarkWithConstantColor:[self colorConstantStyleDarkColor] normalCorlor:[UIColor colorWithHexString:@"#f2f2f2"]];
    return color;
}
 //常用F5View背景色
 + (UIColor *) colorCommonF5BgViewColor{
     UIColor *color = [self colorStyleLeDarkWithConstantColor:[self colorConstantStyleDarkColor] normalCorlor:[UIColor colorWithHexString:@"#f5f5f5"]];
     return color;
 }

#pragma mark ----- 黑暗模式 --------
// 黑暗主颜色
+ (UIColor *) colorConstantStyleDarkColor{
    return [UIColor colorWithHexString:@"#222222"];
}
// 黑暗浅灰颜色
+ (UIColor *) colorConstantStylGrayeDarkColor{
    return [UIColor colorWithHexString:@"#333333"];
}
// 适配黑暗模式的颜色
+ (UIColor *) colorStyleLeDarkWithConstantColor:(UIColor*)ConstantColor normalCorlor:(UIColor*)normalColor{
    if (@available(iOS 13.0, *)) {
         return  [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if ([traitCollection userInterfaceStyle] == UIUserInterfaceStyleDark) {
                return ConstantColor;
            }else{
                return normalColor;
            }
        }];
    }else{
        return normalColor;
    }
}

+ (UIColor *) colorWithHexString: (NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
