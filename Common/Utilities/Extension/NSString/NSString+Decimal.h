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
+ (instancetype)stringWithDecimal:(double)decimal maxFractionDigits:(int)maxFractionDigits minFractionDigits:(int)minFractionDigits trimTrailing:(BOOL)trimTrailing;

@end

NS_ASSUME_NONNULL_END
