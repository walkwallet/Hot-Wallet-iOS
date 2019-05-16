//
//  LoadingView.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoadingView : UIView

@property (nonatomic, copy) IBInspectable UIColor *color;

- (void)rectLayout;
- (void)constraintLayout;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat centerMultiple;

- (void)startAnimating;

- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
