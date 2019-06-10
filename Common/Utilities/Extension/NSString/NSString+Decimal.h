//
//  NSString+Decimal.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Decimal)

/**
 decimal string formatter
 @param decimal decimal
 @param maxFractionDigits maxFractionDigits
 @param minFractionDigits minFractionDigits
 @param trimTrailing whether remove zero in tail
 @return string
 */
+ (instancetype)stringWithDecimal:(NSDecimalNumber *)decimal maxFractionDigits:(int)maxFractionDigits minFractionDigits:(int)minFractionDigits trimTrailing:(BOOL)trimTrailing;

+ (BOOL)isNilOrEmpty:(NSString *)string;

+ (int)getDecimal:(int64_t)unity;

+ (NSDecimalNumber *)getAccurateDouble:(long long)value unity:(long long)unity;

@end

NS_ASSUME_NONNULL_END
