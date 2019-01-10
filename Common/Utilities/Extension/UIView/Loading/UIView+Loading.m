//
//  UIView+Loading.m
//  Wallet
//
//  All rights reserved.
//

#import "UIView+Loading.h"
#import "LoadingView.h"

@implementation UIView (Loading)

- (void)startLoading {
    [self startLoadingWithColor:UIColor.orangeColor];
}

- (void)startLoadingWithColor:(UIColor *)color {
    LoadingView *loadingView = [self loadingView];
    if (loadingView) return;
    loadingView = [[LoadingView alloc] init];
    loadingView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7f];
    loadingView.layer.cornerRadius = 6.f;
    if (color) loadingView.color = color;
    loadingView.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
    [self addSubview:loadingView];
}

- (void)stopLoading {
    LoadingView *loadingView = [self loadingView];
    if (!loadingView) return;
    [loadingView removeFromSuperview];
}

- (LoadingView *)loadingView {
    for (UIView *subV in self.subviews) {
        if ([subV isMemberOfClass:LoadingView.class]) {
            return (LoadingView *)subV;
        }
    }
    return nil;
}

@end
