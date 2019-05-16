//
// MnemonicWordBackupViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MnemonicWordBackupViewController : UIViewController

- (instancetype)initWithMnemonicWordArray:(NSArray<NSString *> *)mnemonicWordArrsy createWallet:(BOOL)createWallet;

- (UINavigationController *)naviVC;

@end

NS_ASSUME_NONNULL_END
