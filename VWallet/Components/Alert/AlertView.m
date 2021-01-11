#import "AlertView.h"
#import "UIColor+Hex.h"
#import "UIView+Efficiency.h"

@interface AlertView() <UIGestureRecognizerDelegate>
@end

@implementation AlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        tap.delegate = self;
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)onTap:(UITapGestureRecognizer*)tap {
    CGPoint tapPoint = [tap locationInView:self];
    if (!CGRectContainsPoint(self.contentWrap.frame, tapPoint)) {
        [self dismiss];
    }
}

- (void)show {
    switch (self.showType) {
        case AlertShowTypeSladeUp: {
            [[UIApplication sharedApplication].keyWindow addSubview:self];
            self.alpha = 0;
            self.contentWrap.top = SCREEN_HEIGHT;
            [UIView animateWithDuration:0.28 animations:^{
                self.alpha = 1;
                self.contentWrap.top = SCREEN_HEIGHT - self.contentWrap.height - [UIView bottomBarHeight];
            }];
        } break;
        case AlertShowTypeFade: {
            [[UIApplication sharedApplication].keyWindow addSubview:self];
            self.alpha = 0;
            [UIView animateWithDuration:0.28 animations:^{
                self.alpha = 1;
            }];
        } break;
        default:
            break;
    }
}

- (void)dismiss {
    switch (self.showType) {
        case AlertShowTypeSladeUp: {
            [UIView animateWithDuration:0.28 animations:^{
                self.alpha = 0;
                self.contentWrap.top = SCREEN_HEIGHT;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        } break;
        case AlertShowTypeFade: {
            [UIView animateWithDuration:0.28 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        } break;
        default:
            break;
    }
}

- (BOOL)showing {
    if (self.superview != nil) {
        return YES;
    }
    return NO;
}

@end
