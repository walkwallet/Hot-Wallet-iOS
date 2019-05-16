//
//  UIColor+Hex.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHexStr:(NSString *)hexStr;
- (NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
