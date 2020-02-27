//
//  CALayer+GJAddition.h
//  TestModuleStock
//
//  Created by mzl on 2020/2/10.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (GJCategory)

//  左边间距
@property (nonatomic) CGFloat left;

//  顶部间距
@property (nonatomic) CGFloat top;

//  右边间距
@property (nonatomic) CGFloat right;

//  底部间距
@property (nonatomic) CGFloat bottom;

//  宽度
@property (nonatomic) CGFloat width;

//  高度
@property (nonatomic) CGFloat height;

//  原点
@property (nonatomic) CGPoint origin;

//  大小
@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat centerX;

@property (nonatomic) CGFloat centerY;


//  边框线类型
typedef NS_OPTIONS(NSUInteger, GJBorderStyle) {
    GJBorderStyleleNone  = 0,      //  没有边框线
    GJBorderStyleTop     = 1 << 0, //  顶部边框线
    GJBorderStyleLeft    = 1 << 1, //  左边边框线
    GJBorderStyleBottom  = 1 << 2, //  底部边框线
    GJBorderStyleRight   = 1 << 3, //  右边边框线
    GJBorderStyleAll     = GJBorderStyleTop | GJBorderStyleLeft | GJBorderStyleBottom | GJBorderStyleRight //  所有边框线
};

@end

@interface CALayer (GJBorder)

/**
 获取圆角类型
 
 @return <#return value description#>
 */
- (UIRectCorner)gj_cornerStyle;

/**
 设置圆角类型
 
 @param cornerStyle <#cornerStyle description#>
 */
- (void)gj_setCornerStyle:(UIRectCorner)cornerStyle;

/**
 获取圆角半径
 
 @return <#return value description#>
 */
- (CGFloat)gj_cornerRadius;

/**
 设置圆角半径
 
 @param cornerRadius <#cornerRadius description#>
 */
- (void)gj_setCornerRadius:(CGFloat)cornerRadius;

// 设置边框线类型
- (void)gj_setBorderStyle:(GJBorderStyle)customBorderStyle;

// 边框线类型
- (GJBorderStyle)gj_borderStyle;

// 设置边框线颜色
- (void)gj_setBorderColor:(UIColor *)color;

// 边框线颜色
- (UIColor *)gj_borderColor;

/**
 设置边框线宽度
 注意：以物理像素为单位，而不是逻辑像素
 
 @param with 边框线宽度
 */
- (void)gj_setBorderWidth:(CGFloat)with;

/**
 边框线宽度；
 注意：以物理像素为单位，而不是逻辑像素
 
 @return <#return value description#>
 */
- (CGFloat)gj_borderWidth;

// 设置边框线内凹
- (void)gj_setBorderInsets:(UIEdgeInsets)insets;

// 边框线内凹
- (UIEdgeInsets)gj_borderInsets;

// 重新布局边框线，如果在设置了边框线之后view的大小发生变化，需要调用此方法
- (void)gj_relayoutBorder;

@end

NS_ASSUME_NONNULL_END
