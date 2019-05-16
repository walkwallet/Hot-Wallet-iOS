//
// LevelBar.m
//  Wallet
//
//  All rights reserved.
//

#import "VLevelBar.h"

#import "VColor.h"
#import "UIColor+Hex.h"

@implementation VLevelBar

- (void)drawRect:(CGRect)rect {
    CGFloat totalSegmentSpecing = (self.maxLevel - 1) * self.segmentSpecing;
    if (totalSegmentSpecing >= CGRectGetWidth(rect)) return;
    CGFloat segmentWidth = (CGRectGetWidth(rect) - totalSegmentSpecing) / self.maxLevel;
    CGFloat centerY = CGRectGetHeight(rect) / 2;
    [self.levelColor setStroke];
    UIBezierPath *path;
    CGFloat offsetX = 0.f;
    for (int i = 0; i < self.maxLevel; i++) {
        if (i >= _level) {
            [self.tintColor setStroke];
        }
        path = [UIBezierPath bezierPath];
        [path setLineWidth:2.f];
        [path moveToPoint:CGPointMake(offsetX, centerY)];
        [path addLineToPoint:CGPointMake(offsetX + segmentWidth, centerY)];
        [path stroke];
        offsetX += self.segmentSpecing + segmentWidth;
    }
}

- (void)setLevel:(NSInteger)level {
    _level = level;
    [self setNeedsDisplay];
}

#pragma mark - Default
- (UIColor *)levelColor {
    if (_levelColor) {
        return _levelColor;
    }
    if (self.maxLevel == 5 && _level > 0 && _level <= 5) {
        return @[[UIColor colorWithHex:0xE8E8EB],
                 [UIColor colorWithHex:0xF5354B],
                 [UIColor colorWithHex:0xFF8737],
                 [UIColor colorWithHex:0xFFCC66],
                 [UIColor colorWithHex:0x51D72E],
                 [UIColor colorWithHex:0x7CB342]][_level];
    }
    return VColor.orangeColor;
}

- (CGFloat)segmentSpecing {
    if (_segmentSpecing > 0) {
        return _segmentSpecing;
    }
    return 4.f;
}

- (NSInteger)maxLevel {
    if (_maxLevel > 0) {
        return _maxLevel;
    }
    return 5;
}

#pragma mark - Password Secure Level
- (void)updateLevelWithPassword:(NSString *)password {
    self.level = [self passwordSecureLevelWithPassword:password];
}

- (NSInteger)passwordSecureLevelWithPassword:(NSString *)password {
    if (!password.length) return 0;
    NSInteger secureScore = 0;
    // length
    if (password.length >= 8) {
        secureScore += 25;
    } else if (password.length > 4) {
        secureScore += 10;
    } else {
        secureScore += 5;
    }
    // alpha
    NSInteger majusculeCount = [self containsWithStr:password regexStr:@"[A-Z]"];
    NSInteger lowercaseCount = [self containsWithStr:password regexStr:@"[a-z]"];
    if (lowercaseCount && majusculeCount) {
        secureScore += 30;
    } else if (lowercaseCount ^ majusculeCount) {
        secureScore += 15;
    }
    // number
    NSInteger numberCount = [self containsWithStr:password regexStr:@"\\d"];
    if (numberCount > 1) {
        secureScore += 15;
    } else if (numberCount > 0) {
        secureScore += 5;
    }
    // symbol
    NSInteger symbolCount = [self containsWithStr:password regexStr:@"[!-/:-@\\[-\\\\'\\{-~]"];
    if (symbolCount > 1) {
        secureScore += 25;
    } else if (symbolCount > 0) {
        secureScore += 10;
    }
    // other
    if (majusculeCount && lowercaseCount && numberCount && symbolCount) {
        secureScore += 5;
    } else if ((majusculeCount ^ lowercaseCount) && numberCount && symbolCount) {
        secureScore += 3;
    } else if ((majusculeCount || lowercaseCount) && numberCount) {
        secureScore += 2;
    }
    NSInteger level = ceilf(secureScore / (100.f / self.maxLevel));
    return level;
}

- (NSInteger)containsWithStr:(NSString *)str regexStr:(NSString *)regexStr {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:nil];
    return [regex numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
}

@end
