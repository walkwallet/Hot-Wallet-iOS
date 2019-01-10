//
//  UIImage+QRCode.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (QRCode)

+ (instancetype)imageWithQrCodeStr:(NSString *)qrCodeStr;

+ (instancetype)imageWithQrCodeStr:(NSString *)qrCodeStr size:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
