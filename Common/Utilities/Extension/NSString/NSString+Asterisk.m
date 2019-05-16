//
//  NSString+Asterisk.m
//  Wallet
//
//  All rights reserved.
//

#import "NSString+Asterisk.h"

@implementation NSString (Asterisk)

- (NSString *)implicitCount:(NSInteger)count {
    if (!self.length || count <= 0) return self;
    if (self.length <= 2) {
        return [[self substringToIndex:1] stringByAppendingString:@"*"];
    }
    if (self.length <= count + 2) {
        return [NSString stringWithFormat:@"%@%@%@", [self substringToIndex:1], [self asteriskStrWithCount:self.length - 2], [self substringFromIndex:self.length - 1]];
    }
    NSInteger frontCount = (self.length - count) / 2;
    return [NSString stringWithFormat:@"%@%@%@", [self substringToIndex:frontCount], [self asteriskStrWithCount:count], [self substringFromIndex:(frontCount + count)]];
}

- (NSString *)explicitCount:(NSInteger)count {
    return [self explicitCount:count maxAsteriskCount:-1];
}

- (NSString *)explicitCount:(NSInteger)count maxAsteriskCount:(NSInteger)maxAsteriskCount {
    if (!self.length || count >= self.length) {
        return self;
    }
    if (count <= 0) {
        return [self asteriskStrWithCount:self.length];
    }
    NSInteger frontCount = count / 2;
    return [NSString stringWithFormat:@"%@%@%@",
            [self substringToIndex:frontCount],
            [self asteriskStrWithCount:(maxAsteriskCount > 0 ? maxAsteriskCount : (self.length - count))],
            [self substringFromIndex:(self.length - count + frontCount)]];
}

- (NSString *)asteriskStrWithCount:(NSInteger)count {
    NSMutableString *str = [NSMutableString string];
    while (count > 0) {
        [str appendString:@"*"];
        count -= 1;
    }
    return str.copy;
}

@end
