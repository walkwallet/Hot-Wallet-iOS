//
// MnemonicWordCheckViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MnemonicWordCheckViewController : UIViewController

- (instancetype)initWithMnemonicWordArray:(NSArray<NSString *> *)mnemonicWordArrsy createWallet:(BOOL)createWallet;

@end

NS_ASSUME_NONNULL_END
