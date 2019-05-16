//
//  ToastPasswordViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToastPasswordViewController : UIViewController

- (instancetype)initWithConfirmTitle:(NSString *)confirmTitle result:(void (^)(BOOL))result;

@end

NS_ASSUME_NONNULL_END
