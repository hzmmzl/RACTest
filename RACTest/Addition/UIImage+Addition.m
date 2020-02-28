//
//  UIImage+Addition.m

#import "UIImage+Addition.h"
#import <objc/runtime.h>

static const void *kPolygonBorderWidthKey = &kPolygonBorderWidthKey;

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

@implementation UIImage (SSJColor)

//改变图片颜色
- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    return [self imageWithColor:color
                               path:[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, MAX(size.width, 1), MAX(size.height, 1))]];
}

+ (UIImage *)imageWithColor:(UIColor *)color
                           size:(CGSize)size
                roundingCorners:(UIRectCorner)corners
                    cornerRadii:(CGSize)cornerRadii {
    return [self imageWithColor:color
                               path:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:corners cornerRadii:cornerRadii]];
}

+ (UIImage *)imageWithColor:(UIColor *)color path:(UIBezierPath *)path {
    UIGraphicsBeginImageContext(path.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, path.bounds.size.width, path.bounds.size.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
