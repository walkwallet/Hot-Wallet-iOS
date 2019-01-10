//
// AddMonitorAddressViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddMonitorAddressViewController : UIViewController

- (void)processWithQrCode: (NSString *)qrcode;

@property (nonatomic, copy) void(^configureBlock)(AddMonitorAddressViewController *vc);

@end

NS_ASSUME_NONNULL_END
