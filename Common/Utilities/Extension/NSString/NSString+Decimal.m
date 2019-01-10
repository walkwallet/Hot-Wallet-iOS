//
//  NSString+Decimal.m
//  Wallet
//
//  All rights reserved.
//

#import "NSString+Decimal.h"

@implementation NSString (Decimal)

+ (instancetype)stringWithDecimal:(double)decimal maxFractionDigits:(int)maxFractionDigits minFractionDigits:(int)minFractionDigits trimTrailing:(BOOL)trimTrailing {
    NSString *placeholderStr = [NSString stringWithFormat:@"%%.%df", MAX(maxFractionDigits, minFractionDigits)];
    NSString *decimalStr = [NSString stringWithFormat:placeholderStr, decimal];
    if (!trimTrailing || ![decimalStr containsString:@"."]) {
        return decimalStr;
    }
    NSArray<NSString *> *numStrArray = [decimalStr componentsSeparatedByString:@"."];
    NSString *integerStr = numStrArray.firstObject;
    NSString *fractionStr = numStrArray.lastObject;
    NSString *trimFractionStr = fractionStr;
    while ([trimFractionStr hasSuffix:@"0"]) {
        trimFractionStr = [trimFractionStr substringToIndex:trimFractionStr.length - 1];
    }
    if (minFractionDigits > trimFractionStr.length) {
        return [integerStr stringByAppendingFormat:@".%@", [fractionStr substringToIndex:minFractionDigits]];
    }
    if (decimal == (NSInteger)decimal) {
        return integerStr;
    }
    return [integerStr stringByAppendingFormat:@".%@", trimFractionStr];
}

@end
