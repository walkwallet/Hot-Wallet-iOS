//
//  VThemeButton.m
//  Wallet
//
//  All rights reserved.
//

#import "VThemeButton.h"

#import "VColor.h"

@implementation VThemeButton

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
    [self updateShowStyle];
}

- (void)updateShowStyle {
    if (_submit) {
        if (_hollow) {
            self.backgroundColor = UIColor.clearColor;
            self.layer.borderWidth = 1.f;
            self.layer.borderColor = VColor.themeColor.CGColor;
            self.tintColor = VColor.themeColor;
            [self setTitleColor:self.tintColor forState:UIControlStateNormal];
        } else {
            self.backgroundColor = VColor.themeColor;
            self.layer.borderWidth = 0.f;
            self.tintColor = UIColor.whiteColor;
            [self setTitleColor:self.tintColor forState:UIControlStateNormal];
        }
    } else {
        self.backgroundColor = UIColor.clearColor;
        self.tintColor = _secondTheme ? VColor.textSecondColor : VColor.textColor;
        [self setTitleColor:self.tintColor forState:UIControlStateNormal];
        if (_hollow) {
            self.layer.borderWidth = 1.f;
            self.layer.borderColor = VColor.borderColor.CGColor;
        } else {
            self.layer.borderWidth = 0.f;
        }
    }
    self.enabled = self.enabled;
}

- (void)setSecondTheme:(BOOL)secondTheme {
    _secondTheme = secondTheme;
    [self updateShowStyle];
}

- (void)setSubmit:(BOOL)submit {
    _submit = submit;
    [self updateShowStyle];
}

- (void)setHollow:(BOOL)hollow {
    _hollow = hollow;
    [self updateShowStyle];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (_submit && !_hollow) {
        self.backgroundColor = enabled ? VColor.themeColor : VColor.disaleBgColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
     
}

@end
