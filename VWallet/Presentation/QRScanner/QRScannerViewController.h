//
// QRScannerViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface QRScannerViewController : UIViewController

- (instancetype)initWithQRRegexStr:(NSString *_Nullable)qrRegexStr
                    noMatchTipText:(NSString *_Nullable)noMatchTipText
                            result:(void(^)(NSString *__nullable qrCode))result;

@end

NS_ASSUME_NONNULL_END
