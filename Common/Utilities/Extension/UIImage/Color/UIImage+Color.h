//
//  UIImage+Color.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GradientType) {
    GradientTypeTopToBottom = 0,
    GradientTypeLeftToRight,
    GradientTypeUpleftToLowright,
    GradientTypeUprightToLowleft
};

@interface UIImage (Color)

+ (instancetype)imageWithColor:(UIColor *)color;

+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (instancetype)imageWithColors:(NSArray<UIColor *> *)colors gradientType:(GradientType)gradientType size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
