//
//  Regex.m
//  Wallet
//
//  All rights reserved.
//

#import "Regex.h"

@implementation Regex

+ (BOOL)matchRegexStr:(NSString *)regexStr string:(NSString *)string {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr] evaluateWithObject:string];
}

+ (NSArray *)seekRegexStr:(NSString *)regexStr string:(NSString *)string {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionAnchorsMatchLines error:nil];
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSMutableArray *array = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        for (int i = 0; i < [match numberOfRanges]; i++) {
            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
            [array addObject:component];
        }
    }
    return array;
}

+ (NSString *)replaceRegexStr:(NSString *)regexStr replaceStr:(NSString *)replaceStr string:(NSString *)string {
    if (!string.length) return string;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionAnchorsMatchLines error:nil];
    string  = [regex stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:replaceStr];
    return string;
}

@end
