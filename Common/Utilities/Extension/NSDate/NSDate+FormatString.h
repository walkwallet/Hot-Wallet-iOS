//
//  NSDate+FormatString.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (FormatString)

- (NSString *)pastTimeFormatString;

- (NSString *)stringWithDateFormat:(NSString *)dateFormat;

- (NSString *)dateString;

@end

NS_ASSUME_NONNULL_END
