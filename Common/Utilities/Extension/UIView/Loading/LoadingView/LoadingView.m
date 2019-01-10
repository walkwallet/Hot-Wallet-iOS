//
//  LoadingView.m
//  Wallet
//
//  All rights reserved.
//

#import "LoadingView.h"
#import <Masonry.h>

@interface LoadingView ()

@property (nonatomic, assign) BOOL loading;
@property (nonatomic, weak) UIImageView *imgView;

@end

@implementation LoadingView

- (instancetype)init {
    if (self = [super init]) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_loading_white"]];
        [self addSubview:imgView];
        self.imgView = imgView;
        [self rectLayout];
        [self startAnimating];
    }
    return self;
}

- (void)rectLayout {
    self.frame = CGRectMake(0, 0, 64.f, 64.f);
    self.imgView.frame = CGRectMake(0, 0, 36, 36);
    self.imgView.center = self.center;
}

- (void)constraintLayout {
    __weak typeof(self) weakSelf = self;
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_loading_white"]];
        [self addSubview:imgView];
        self.imgView = imgView;
        [self constraintLayout];
    }
    return self;
}

- (void)setOffsetY:(CGFloat)offsetY {
    _offsetY = offsetY;
    [self updateConstraintLayout];
}

- (void)setCenterMultiple:(CGFloat)centerMultiple {
    _centerMultiple = centerMultiple;
    [self updateConstraintLayout];
}

- (void)updateConstraintLayout {
    __weak typeof(self) weakSelf = self;
    if (self.centerMultiple > 0) {
        [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.mas_centerY).multipliedBy(2);
        }];
    } else {
        [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.mas_centerY).mas_offset(weakSelf.offsetY);
        }];
    }
}

- (void)setColor:(UIColor *)color {
    self.imgView.tintColor = color;
}

- (void)startAnimating {
    if (!self.loading) {
        self.loading = YES;
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        rotationAnimation.duration = 0.7f;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = INFINITY;
        [self.imgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

- (void)stopAnimating {
    if (self.loading) {
        self.loading = NO;
        [self.imgView.layer removeAnimationForKey:@"rotationAnimation"];
    }
}

@end
