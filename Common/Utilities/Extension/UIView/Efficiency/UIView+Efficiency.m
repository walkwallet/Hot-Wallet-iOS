//
//  UIView+Frame.m
//  DaLong-iOS
//
//  Created by joy on 2019/6/19.
//  Copyright © 2019 togreat tech. All rights reserved.
//

#import "UIView+Efficiency.h"
#import "sys/utsname.h"

@implementation UIView(Efficiency)

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight: (CGFloat) newheight {
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth: (CGFloat) newwidth {
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat) x {
    CGRect newframe = self.frame;
    newframe.origin.x = x;
    self.frame = newframe;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat) y {
    CGRect newframe = self.frame;
    newframe.origin.y = y;
    self.frame = newframe;
}

- (void)setRight:(CGFloat)right {
    CGRect newframe = self.frame;
    newframe.origin.x = right -self.frame.size.width;
    self.frame = newframe;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom: (CGFloat) newbottom {
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (void)setBackgroundImage: (NSString *) imageName {
    UIGraphicsBeginImageContext(self.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:self.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.backgroundColor = [UIColor colorWithPatternImage:image];
}

+ (CGFloat)topMargin {
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 13.0) {
        return 54;
    }else {
        return 0;
    }
}

+ (CGFloat)topPadding {
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 13.0) {
        return 0;
    }else {
        return UIView.topBarHeight;
    }
}

+ (CGFloat)topBarHeight {
    if ([self isIphoneX]) {
        return 44;
    }else {
        return 20;
    }
}

+ (CGFloat)bottomBarHeight {
    if ([self isIphoneX]) {
        return 34;
    }
    return 0;
}

+ (BOOL)isIphoneX {
    BOOL isPhoneX = NO;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        isPhoneX = window.safeAreaInsets.bottom > 0;
    }
    return isPhoneX;
}

+ (CGFloat)sFactor {
    if (SCREEN_HEIGHT < 667) {
        return 0.8;
    }else if (SCREEN_HEIGHT == 667) {
        return 0.95;
    }
    
    return 1;
}

+ (BOOL)darkMode {
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return YES;
        }
        return NO;
    }else {
        return NO;
    }
}

@end
