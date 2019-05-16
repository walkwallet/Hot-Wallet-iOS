//
//  VThemeRootView.m
//  Wallet
//
//  All rights reserved.
//

#import "VThemeRootView.h"

#import "VColor.h"

@implementation VThemeRootView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self themeInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self themeInit];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self themeInit];
    }
    return self;
}

- (void)themeInit {
    self.backgroundColor = VColor.rootViewBgColor;
}

@end
