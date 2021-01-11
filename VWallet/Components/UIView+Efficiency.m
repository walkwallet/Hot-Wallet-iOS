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
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        CGRect size = [UIScreen mainScreen].bounds;
        if (size.size.width == 375 && size.size.height > 800) {
            return YES;
        }
        if (size.size.width == 414 && size.size.height > 800) {
            return YES;
        }
        return NO;
    }
    BOOL isIPhoneX = [platform containsString:@"iPhone1"];
    return isIPhoneX;
}

@end
