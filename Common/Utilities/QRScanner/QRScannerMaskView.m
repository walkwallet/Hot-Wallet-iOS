//
//  QRScannerMaskView.m
//  Wallet
//
//  All rights reserved.
//

#import "QRScannerMaskView.h"

#import "Language.h"
#import "VColor.h"

@interface QRScannerMaskView ()

@property (nonatomic, strong) UIImageView *slider;

@end

@implementation QRScannerMaskView

- (void)setRectOfInterest:(CGRect)rectOfInterest {
    _rectOfInterest = rectOfInterest;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat interestMinx = width * CGRectGetMinX(_rectOfInterest);
    CGFloat interestMinY = height * CGRectGetMinY(_rectOfInterest);
    CGFloat interestWidth = width * CGRectGetWidth(_rectOfInterest);
    CGFloat interestHeight = height * CGRectGetHeight(_rectOfInterest);
    _interestRect = CGRectMake(interestMinx, interestMinY, interestWidth, interestHeight);
    self.backgroundColor = UIColor.clearColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat x = CGRectGetMinX(rect);
    CGFloat y = CGRectGetMinY(rect);
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    [[UIColor colorWithWhite:0.f alpha:0.7f] setFill];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_interestRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8.f, 8.f)];
    [path moveToPoint:CGPointMake(x, y)];
    [path addLineToPoint:CGPointMake(x + width, y)];
    [path addLineToPoint:CGPointMake(x + width, y + height)];
    [path addLineToPoint:CGPointMake(x, y + height)];
    path.usesEvenOddFillRule = YES;
    [path fill];
    
    path = [UIBezierPath bezierPathWithRoundedRect:_interestRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8.f, 8.f)];
    path.lineWidth = 2.f;
    [[UIColor colorWithWhite:1.f alpha:0.2f] setStroke];
    [path stroke];
    
    NSString *tipStr = VLocalize(@"scan.qrcode.title");
    UIFont *tipFont = [UIFont systemFontOfSize:13.f];
    CGSize tipSize = [tipStr sizeWithAttributes:@{NSFontAttributeName : tipFont}];
    [tipStr drawAtPoint:CGPointMake(CGRectGetMinX(_interestRect) + CGRectGetWidth(_interestRect) / 2 - tipSize.width / 2, CGRectGetMinY(_interestRect) - 15.f - tipSize.height) withAttributes:@{NSFontAttributeName : tipFont, NSForegroundColorAttributeName : UIColor.whiteColor}];
}

- (UIImageView *)slider {
    if (!_slider) {
        CGRect frame = _interestRect;
        frame.size.height = 4.f;
        _slider = [[UIImageView alloc] initWithFrame:frame];
        _slider.image = [UIImage imageNamed:@"scan_slider"];
        _slider.tintColor = VColor.themeColor;
        [self addSubview:_slider];
    }
    return _slider;
}

- (void)startScanAnimation {
    self.slider.tag = 1;
    [self scanAnimation];
}

- (void)scanAnimation {
    if (!self.slider.tag) return;
    [UIView animateWithDuration:2.f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.slider.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.interestRect) - CGRectGetHeight(self.slider.bounds));
    } completion:^(BOOL finished) {
        self.slider.transform = CGAffineTransformIdentity;
        [self scanAnimation];
    }];
}

- (void)pauseScanAnimation {
    self.slider.tag = 0;
}

- (void)stopScanAnimation {
    [self.slider removeFromSuperview];
    self.slider = nil;
}

@end
