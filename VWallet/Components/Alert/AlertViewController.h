//
//  AlertViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertViewController : UIViewController

@property (nonatomic, assign) BOOL autoDismiss;

@property (weak, nonatomic) IBOutlet UIView *mainView;

- (instancetype)initWithTitle:(NSString *)title confirmTitle:(NSString *)confirmTitle configureContent:(void(^)(UIViewController *vc, UIStackView *parentView))configureBlock cancel:(void(^)(UIViewController *vc))cancel confirm:(void(^)(UIViewController *vc))confirm back:(BOOL)backEnable;

@end

NS_ASSUME_NONNULL_END
