//
//  NSDate+FormatString.m
//  Wallet
//
//  All rights reserved.
//

#import "NSDate+FormatString.h"
#import "Language.h"

@implementation NSDate (FormatString)

- (NSString *)pastTimeFormatString {
    NSTimeInterval timeInterval = -self.timeIntervalSinceNow;
    NSDate *now = NSDate.date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyyMMdd";
    NSString *todayStr = [df stringFromDate:now];
    NSDate *todayWeeHours = [df dateFromString:todayStr];   // today 0'clock
    NSTimeInterval now_todayWeeHours_timeInterval = -todayWeeHours.timeIntervalSinceNow;
    if (timeInterval < now_todayWeeHours_timeInterval) {
        df.dateFormat = @"HH:mm";
    } else {
        df.dateFormat = @"yyyy";
        if ([[df stringFromDate:self] isEqualToString:[df stringFromDate:now]]) {
            df.dateFormat = @"MM.dd HH:mm";
        } else {
            df.dateFormat = Language.shareInstance.languageType == LanguageTypeCN ? @"yyyy.MM.dd HH:mm" : @"MM.dd.yyyy HH:mm";
        }
    }
    return [df stringFromDate:self];
}

- (NSString *)stringWithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = dateFormat;
    return [df stringFromDate:self];
}

- (NSString *)dateString {
    switch (Language.shareInstance.languageType) {
        case LanguageTypeEN: {
            NSInteger month = [[self stringWithDateFormat:@"M"] integerValue];
            NSString *monthStr = [self toMonthEnStr:month];
            return [NSString stringWithFormat:@"%@ %@", monthStr, [self stringWithDateFormat:@"dd, yyyy"]];
        } break;
        default: {
            return [self stringWithDateFormat:@"yyyy-MM-dd"];
        } break;
    }
}

- (NSString *)toMonthEnStr:(NSInteger)month {
    if (month < 1 || month > 12) return @"";
    return @[@"", @"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"][month];
}

@end
