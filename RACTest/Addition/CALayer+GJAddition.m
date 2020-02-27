//
//  CALayer+GJAddition.m
//  TestModuleStock
//
//  Created by mzl on 2020/2/10.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import "CALayer+GJAddition.h"

#import <objc/runtime.h>

@implementation CALayer (GJCategory)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.position.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.position = CGPointMake(centerX, self.position.y);
}

- (CGFloat)centerY {
    return self.position.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.position = CGPointMake(self.position.x, centerY);
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

@interface _GJBorderLayer : CALayer

//  边框线类型
@property (nonatomic, assign) GJBorderStyle customBorderStyle;

@property (nonatomic, assign) UIRectCorner cornerStyle;

@property (nonatomic, assign) CGFloat customCornerRadius;

//  边框线宽度 dufault 1.0
@property (nonatomic, assign) CGFloat customBorderWidth;

//  边框线颜色 default black
@property (nonatomic, strong) UIColor *customBorderColor;

@end

@implementation _GJBorderLayer

+ (instancetype)layer {
    _GJBorderLayer *layer = [super layer];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.customBorderColor = [UIColor blackColor];
    layer.customBorderWidth = 1.0;
    layer.contentsScale = [UIScreen mainScreen].scale;
    return layer;
}

- (void)setCustomBorderStyle:(GJBorderStyle)customBorderStyle {
    if (_customBorderStyle != customBorderStyle) {
        _customBorderStyle = customBorderStyle;
        [self setNeedsDisplay];
    }
}

- (void)setCornerStyle:(UIRectCorner)cornerType {
    if (_cornerStyle != cornerType) {
        _cornerStyle = cornerType;
        [self setNeedsDisplay];
    }
}

- (void)setCustomCornerRadius:(CGFloat)customCornerRadius {
    if (_customCornerRadius != customCornerRadius) {
        _customCornerRadius = customCornerRadius;
        [self setNeedsDisplay];
    }
}

- (void)setCustomBorderColor:(UIColor *)customBorderColor {
    _customBorderColor = customBorderColor;
    [self setNeedsDisplay];
}

- (void)setCustomBorderWidth:(CGFloat)customBorderWidth {
    if (_customBorderWidth != customBorderWidth) {
        _customBorderWidth = customBorderWidth;
        [self setNeedsDisplay];
    }
}

- (void)drawInContext:(CGContextRef)ctx {
    if (_customBorderStyle == GJBorderStyleleNone
        || _customBorderWidth <= 0) {
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat lineWidth = self.customBorderWidth / [UIScreen mainScreen].scale;
    CGFloat inset = lineWidth / 2;
    CGRect contentFrame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(inset, inset, inset, inset));
    CGPoint leftTop = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMinY(contentFrame));
    CGPoint rightTop = CGPointMake(CGRectGetMaxX(contentFrame), CGRectGetMinY(contentFrame));
    CGPoint rightBottom = CGPointMake(CGRectGetMaxX(contentFrame), CGRectGetMaxY(contentFrame));
    CGPoint leftBottom = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
    
    if ((_customBorderStyle & GJBorderStyleTop) == GJBorderStyleTop) {
        CGPoint point_1 = CGPointMake(0, inset);
        CGPoint point_2 = CGPointMake(self.width, inset);
        if ((_cornerStyle & UIRectCornerTopLeft) == UIRectCornerTopLeft) {
            point_1 = CGPointMake(leftTop.x + self.customCornerRadius, leftTop.y);
        }
        if ((_cornerStyle & UIRectCornerTopRight) == UIRectCornerTopRight) {
            point_2 = CGPointMake(rightTop.x - self.customCornerRadius, leftTop.y);
        }
        [path moveToPoint:point_1];
        [path addLineToPoint:point_2];
    }
    
    if ((_customBorderStyle & GJBorderStyleRight) == GJBorderStyleRight) {
        CGPoint point_1 = CGPointMake(self.width - inset, 0);
        CGPoint point_2 = CGPointMake(self.width - inset, self.height);
        if ((_cornerStyle & UIRectCornerTopRight) == UIRectCornerTopRight) {
            point_1 = CGPointMake(rightTop.x, rightTop.y + self.customCornerRadius);
        }
        if ((_cornerStyle & UIRectCornerBottomRight) == UIRectCornerBottomRight) {
            point_2 = CGPointMake(rightBottom.x, rightBottom.y - self.customCornerRadius);
        }
        [path moveToPoint:point_1];
        [path addLineToPoint:point_2];
    }
    
    if ((_customBorderStyle & GJBorderStyleBottom) == GJBorderStyleBottom) {
        CGPoint point_1 = CGPointMake(self.width, self.height - inset);
        CGPoint point_2 = CGPointMake(0, self.height - inset);
        if ((_cornerStyle & UIRectCornerBottomRight) == UIRectCornerBottomRight) {
            point_1 = CGPointMake(rightBottom.x - self.customCornerRadius, rightBottom.y);
        }
        if ((_cornerStyle & UIRectCornerBottomLeft) == UIRectCornerBottomLeft) {
            point_2 = CGPointMake(leftBottom.x + self.customCornerRadius, leftBottom.y);
        }
        [path moveToPoint:point_1];
        [path addLineToPoint:point_2];
    }
    
    if ((_customBorderStyle & GJBorderStyleLeft) == GJBorderStyleLeft) {
        CGPoint point_1 = CGPointMake(inset, self.height);
        CGPoint point_2 = CGPointMake(inset, 0);
        if ((_cornerStyle & UIRectCornerBottomLeft) == UIRectCornerBottomLeft) {
            point_1 = CGPointMake(leftBottom.x, leftBottom.y - self.customCornerRadius);
        }
        if ((_cornerStyle & UIRectCornerTopLeft) == UIRectCornerTopLeft) {
            point_2 = CGPointMake(leftTop.x, leftTop.y + self.customCornerRadius);
        }
        [path moveToPoint:point_1];
        [path addLineToPoint:point_2];
    }
    
    CGFloat radius = self.customCornerRadius;
    if ((_customBorderStyle & GJBorderStyleTop) == GJBorderStyleTop
        && (_customBorderStyle & GJBorderStyleLeft) == GJBorderStyleLeft
        && (_cornerStyle & UIRectCornerTopLeft) == UIRectCornerTopLeft) {
        CGPoint point = CGPointMake(leftTop.x, leftTop.y + radius);
        CGPoint center = CGPointMake(leftTop.x + radius, leftTop.y + radius);
        [path moveToPoint:point];
        [path addArcWithCenter:center radius:radius startAngle:M_PI endAngle:M_PI * 1.5 clockwise:YES];
    }
    
    if ((_customBorderStyle & GJBorderStyleTop) == GJBorderStyleTop
        && (_customBorderStyle & GJBorderStyleRight) == GJBorderStyleRight
        && (_cornerStyle & UIRectCornerTopRight) == UIRectCornerTopRight) {
        CGPoint point = CGPointMake(rightTop.x - radius, rightTop.y);
        CGPoint center = CGPointMake(rightTop.x - radius, rightTop.y + radius);
        [path moveToPoint:point];
        [path addArcWithCenter:center radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 2 clockwise:YES];
    }
    
    if ((_customBorderStyle & GJBorderStyleRight) == GJBorderStyleRight
        && (_customBorderStyle & GJBorderStyleBottom) == GJBorderStyleBottom
        && (_cornerStyle & UIRectCornerBottomRight) == UIRectCornerBottomRight) {
        CGPoint point = CGPointMake(rightBottom.x, rightBottom.y - radius);
        CGPoint center = CGPointMake(rightBottom.x - radius, rightBottom.y - radius);
        [path moveToPoint:point];
        [path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    }
    
    if ((_customBorderStyle & GJBorderStyleBottom) == GJBorderStyleBottom
        && (_customBorderStyle & GJBorderStyleLeft) == GJBorderStyleLeft
        && (_cornerStyle & UIRectCornerBottomLeft) == UIRectCornerBottomLeft) {
        CGPoint point = CGPointMake(leftBottom.x + radius, leftBottom.y);
        CGPoint center = CGPointMake(leftBottom.x + radius, leftBottom.y - radius);
        [path moveToPoint:point];
        [path addArcWithCenter:center radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    }
    
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetStrokeColorWithColor(ctx, _customBorderColor.CGColor);
    CGContextStrokePath(ctx);
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

static const void *kBorderLayerKey = &kBorderLayerKey;
static const void *kBorderInsetsKey = &kBorderInsetsKey;

@implementation CALayer (GJBorder)

+ (void)load {
//    gjSwizzleSelector([self class], @selector(setBounds:), @selector(gjLayerAddition_setBounds:));
    Method originalMethod = class_getInstanceMethod([self class], @selector(setBounds:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(gjLayerAddition_setBounds:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)gjLayerAddition_setBounds:(CGRect)bounds {
    [self gjLayerAddition_setBounds:bounds];
    [self gj_updateBorderLayerFrame];
}

- (void)gj_setCornerStyle:(UIRectCorner)cornerStyle {
    [[self gj_borderLayer] setCornerStyle:cornerStyle];
}

- (UIRectCorner)gj_cornerStyle {
    return [[self gj_borderLayer] cornerStyle];
}

- (void)gj_setCornerRadius:(CGFloat)cornerRadius {
    [self gj_borderLayer].customCornerRadius = cornerRadius;
}

- (CGFloat)gj_cornerRadius {
    return [self gj_borderLayer].customCornerRadius;
}

- (void)gj_setBorderStyle:(GJBorderStyle)customBorderStyle {
    [[self gj_borderLayer] setCustomBorderStyle:customBorderStyle];
}

- (GJBorderStyle)gj_borderStyle {
    return [[self gj_borderLayer] customBorderStyle];
}

- (void)gj_setBorderColor:(UIColor *)color {
    [[self gj_borderLayer] setCustomBorderColor:color];
}

- (UIColor *)gj_borderColor {
    return [[self gj_borderLayer] customBorderColor];
}

- (void)gj_setBorderWidth:(CGFloat)with {
    [[self gj_borderLayer] setCustomBorderWidth:with];
}

- (CGFloat)gj_borderWidth {
    return [[self gj_borderLayer] customBorderWidth];
}

- (void)gj_setBorderInsets:(UIEdgeInsets)insets {
    NSValue *insetsValue = [NSValue valueWithUIEdgeInsets:insets];
    objc_setAssociatedObject(self, kBorderInsetsKey, insetsValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self gj_updateBorderLayerFrame];
}

- (UIEdgeInsets)gj_borderInsets {
    return [objc_getAssociatedObject(self, kBorderInsetsKey) UIEdgeInsetsValue];
}

- (void)gj_relayoutBorder {
    [self gj_borderLayer].frame = self.bounds;
}

- (_GJBorderLayer *)gj_borderLayer {
    _GJBorderLayer *layer = objc_getAssociatedObject(self, kBorderLayerKey);
    if (!layer) {
        layer = [_GJBorderLayer layer];
        layer.frame = self.bounds;
        [self addSublayer:layer];
        objc_setAssociatedObject(self, kBorderLayerKey, layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return layer;
}

- (void)gj_updateBorderLayerFrame {
    _GJBorderLayer *layer = objc_getAssociatedObject(self, kBorderLayerKey);
    if (layer) {
        CGRect frame = UIEdgeInsetsInsetRect(self.bounds, [self gj_borderInsets]);
        if (isnan(frame.origin.x)) {
#ifdef DEBUG
            [NSException raise:NSInvalidArgumentException format:@"frame.origin.x=Nan", nil];
#endif
            frame.origin.x = 0;
        } else if (isnan(frame.origin.y)) {
#ifdef DEBUG
            [NSException raise:NSInvalidArgumentException format:@"frame.origin.y=Nan", nil];
#endif
            frame.origin.y = 0;
        } else if (isnan(frame.size.width)) {
#ifdef DEBUG
            [NSException raise:NSInvalidArgumentException format:@"frame.size.width=Nan", nil];
#endif
            frame.size.width = 0;
        } else if (isnan(frame.size.height)) {
#ifdef DEBUG
            [NSException raise:NSInvalidArgumentException format:@"frame.size.height=Nan", nil];
#endif
            frame.size.height = 0;
        }
        layer.frame = frame;
    }
}

@end
