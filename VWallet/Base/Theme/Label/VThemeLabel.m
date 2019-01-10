//
//  VThemeLabel.m
//  Wallet
//
//  All rights reserved.
//

#import "VThemeLabel.h"

#import "VColor.h"

@implementation VThemeLabel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self updateThemeColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self updateThemeColor];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self updateThemeColor];
    }
    return self;
}

- (void)updateThemeColor {
    UIColor *color = @[VColor.textColor, VColor.textSecondColor, VColor.textSecondDeepenColor][_colorLevel];
    self.textColor = color;
}

- (void)setColorLevel:(NSInteger)colorLevel {
    _colorLevel = abs((int)colorLevel) % 3;
    [self updateThemeColor];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (_lineSpecing != 0 && text.length) {
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        ps.alignment = self.textAlignment;
        ps.lineSpacing = _lineSpecing;
        self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName : ps}];
    }
}

@end
