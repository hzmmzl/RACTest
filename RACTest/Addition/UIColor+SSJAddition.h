//
//  UIColor+SSJAddition.h

#import <UIKit/UIKit.h>

@interface UIColor (SSJCategory)

/**
 *  十六进制颜色转换
 *
 *  @return (UIColor *)
 */
+ (UIColor *)colorWithHex:(NSString *)hexColor;

+ (UIColor *)colorWithHex:(NSString *)hexColor alpha:(CGFloat)alpha;

@end
