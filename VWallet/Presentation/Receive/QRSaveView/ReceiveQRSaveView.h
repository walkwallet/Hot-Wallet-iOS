//
// ReceiveQRSaveView.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReceiveQRSaveView : UIView

- (instancetype)initWithData:(NSDictionary *)data;

- (UIImage *)toImage;

@end

NS_ASSUME_NONNULL_END
