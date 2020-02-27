//
//  UIView+GJAddition.h
//  TestModuleStock
//
//  Created by mzl on 2020/2/10.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CALayer+GJAddition.h"


NS_ASSUME_NONNULL_BEGIN
/*
 简化frame写法
 */

@interface UIView (GJFrame)

//  左边间距
@property (nonatomic) CGFloat left;

//  顶部间距
@property (nonatomic) CGFloat top;

//  右边间距
@property (nonatomic) CGFloat right;

//  底部间距
@property (nonatomic) CGFloat bottom;

//  左上角
@property (nonatomic) CGPoint leftTop;

//  左下角
@property (nonatomic) CGPoint leftBottom;

//  右上角
@property (nonatomic) CGPoint rightTop;

//  右下角
@property (nonatomic) CGPoint rightBottom;

//  宽度
@property (nonatomic) CGFloat width;

//  高度
@property (nonatomic) CGFloat height;

//  X轴中心点
@property (nonatomic) CGFloat centerX;

//  Y轴中心点
@property (nonatomic) CGFloat centerY;

//  原点
@property (nonatomic) CGPoint origin;

//  大小
@property (nonatomic) CGSize size;

@end

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////


@interface UIView (GJBorder)
- (UIRectCorner)gj_cornerStyle;

- (void)gj_setCornerStyle:(UIRectCorner)cornerStyle;

- (CGFloat)gj_cornerRadius;

- (void)gj_setCornerRadius:(CGFloat)cornerRadius;

//  边框线类型
- (GJBorderStyle)gj_borderStyle;

//  设置边框线类型
- (void)gj_setBorderStyle:(GJBorderStyle)customBorderStyle;

//  边框线颜色
- (UIColor *)gj_borderColor;

//  设置边框线颜色
- (void)gj_setBorderColor:(UIColor *)color;

//  边框线宽度
- (CGFloat)gj_borderWidth;

//  设置边框线宽度
- (void)gj_setBorderWidth:(CGFloat)width;

//  边框线内凹
- (UIEdgeInsets)gj_borderInsets;

//  设置边框线内凹
- (void)gj_setBorderInsets:(UIEdgeInsets)insets;
@end

NS_ASSUME_NONNULL_END
