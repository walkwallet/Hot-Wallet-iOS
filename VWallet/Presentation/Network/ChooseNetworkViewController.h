//
// ChooseNetworkViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseNetworkViewController : UIViewController

- (void)setNextBlock:(void(^)(void))next;

@end

NS_ASSUME_NONNULL_END
