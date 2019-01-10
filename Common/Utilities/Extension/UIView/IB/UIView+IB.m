//
//  UIView+IB.m
//  Wallet
//
//  All rights reserved.
//

#import "UIView+IB.h"

@implementation UIView (IB)
@dynamic borderColor;
@dynamic cornerRadius;
@dynamic borderWidth;

@dynamic shadowOpacity;
@dynamic shadowRadius;
@dynamic shadowOffset;
@dynamic shadowColor;

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (borderWidth < 0) return;
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}

@end
