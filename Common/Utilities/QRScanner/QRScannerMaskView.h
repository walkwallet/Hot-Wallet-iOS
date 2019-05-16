//
//  QRScannerMaskView.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRScannerMaskView : UIView

/** range[0,1] */
@property (nonatomic, assign) CGRect rectOfInterest;

@property (nonatomic, assign) CGRect interestRect;

- (void)startScanAnimation;
- (void)pauseScanAnimation;
- (void)stopScanAnimation;

@end

NS_ASSUME_NONNULL_END
