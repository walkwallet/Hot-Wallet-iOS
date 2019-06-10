//
//  NSString+Decimal.m
//  Wallet
//
//  All rights reserved.
//

#import "NSString+Decimal.h"

@implementation NSString (Decimal)

+ (instancetype)stringWithDecimal:(NSDecimalNumber *)decimal maxFractionDigits:(int)maxFractionDigits minFractionDigits:(int)minFractionDigits trimTrailing:(BOOL)trimTrailing {
    NSString *decimalStr = decimal.stringValue;
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
        if (minFractionDigits > fractionStr.length) {
            for (int i = 0;i < minFractionDigits - fractionStr.length;i++){
                fractionStr = [fractionStr stringByAppendingString:@"0"];
            }
        }
        return [integerStr stringByAppendingFormat:@".%@", [fractionStr substringToIndex:minFractionDigits]];
    }
    if (decimal.integerValue == (NSInteger)decimal) {
        return integerStr;
    }
    return [integerStr stringByAppendingFormat:@".%@", trimFractionStr];
}

+ (BOOL)isNilOrEmpty:(NSString *)string {
    return string == nil || string.length == 0;
}

+ (int)getDecimal:(int64_t)unity {
    for (int i = 0; i <= 16; i++){
        if (pow(10, i) == unity) {
            return i;
        }
    }
    return 0;
}

+ (NSDecimalNumber *)getAccurateDouble:(long long)value unity:(long long)unity {
    return [[[NSDecimalNumber alloc] initWithLongLong:value] decimalNumberByDividingBy:[[NSDecimalNumber alloc] initWithLongLong:unity]];
}

@end
